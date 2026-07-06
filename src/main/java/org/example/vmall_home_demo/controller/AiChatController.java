package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.dto.ChatMessage;
import org.example.vmall_home_demo.dto.ChatRequest;
import org.example.vmall_home_demo.dto.ChatResponse;
import org.example.vmall_home_demo.security.JwtTokenProvider;
import org.example.vmall_home_demo.service.AiChatService;
import org.example.vmall_home_demo.service.ConversationService;
import org.springframework.http.HttpHeaders;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ai")
public class AiChatController {

    private static final String BEARER_PREFIX = "Bearer ";

    private final AiChatService aiChatService;
    private final ConversationService conversationService;
    private final JwtTokenProvider jwtTokenProvider;

    public AiChatController(AiChatService aiChatService,
                            ConversationService conversationService,
                            JwtTokenProvider jwtTokenProvider) {
        this.aiChatService = aiChatService;
        this.conversationService = conversationService;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @PostMapping("/chat")
    public ChatResponse chat(@RequestBody ChatRequest request,
                             @RequestHeader(HttpHeaders.AUTHORIZATION) String authHeader) {
        Long userId = extractUserId(authHeader);
        ChatMessage currentMsg = new ChatMessage("user", request.getMessage());
        ConversationService.ConversationResult result = conversationService.ensureConversation(
                request.getConversationId(), userId, currentMsg);
        if (result.isNew()) {
            conversationService.addMessage(result.conversationId(),
                    new ChatMessage("assistant", GREETING));
        }
        conversationService.addMessage(result.conversationId(), currentMsg);
        String reply = aiChatService.chat(currentMsg, request.getHistory(), userId);
        conversationService.addMessage(result.conversationId(), new ChatMessage("assistant", reply));
        return new ChatResponse(reply, result.conversationId());
    }

    private static final String GREETING = "你好！我是智能导购助手，可以帮你推荐商品、了解产品信息。请问有什么需要帮助的吗？";

    private Long extractUserId(String authHeader) {
        if (authHeader == null || !authHeader.startsWith(BEARER_PREFIX)) {
            return null;
        }
        String token = authHeader.substring(BEARER_PREFIX.length()).trim();
        if (token.isEmpty()) {
            return null;
        }
        try {
            if (jwtTokenProvider.validateToken(token)) {
                return jwtTokenProvider.getUserId(token);
            }
        } catch (Exception ignored) {}
        return null;
    }
}

package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.dto.ChatMessage;
import org.example.vmall_home_demo.entity.Conversation;
import org.example.vmall_home_demo.security.JwtTokenProvider;
import org.example.vmall_home_demo.service.ConversationService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/ai/conversations")
public class ConversationController {

    private static final String BEARER_PREFIX = "Bearer ";

    private final ConversationService conversationService;
    private final JwtTokenProvider jwtTokenProvider;

    public ConversationController(ConversationService conversationService,
                                  JwtTokenProvider jwtTokenProvider) {
        this.conversationService = conversationService;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @GetMapping
    public List<Conversation> listConversations(@RequestHeader(HttpHeaders.AUTHORIZATION) String authHeader) {
        Long userId = extractUserId(authHeader);
        if (userId == null) {
            return List.of();
        }
        return conversationService.listConversations(userId);
    }

    @GetMapping("/{id}")
    public ConversationDetail getConversation(@PathVariable Long id,
                                              @RequestHeader(HttpHeaders.AUTHORIZATION) String authHeader) {
        Long userId = extractUserId(authHeader);
        Conversation conversation = conversationService.listConversations(userId).stream()
                .filter(c -> c.getId().equals(id))
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Conversation not found"));
        List<ChatMessage> messages = conversationService.getMessages(id);
        return new ConversationDetail(conversation, messages);
    }

    @DeleteMapping("/{id}")
    public void deleteConversation(@PathVariable Long id,
                                   @RequestHeader(HttpHeaders.AUTHORIZATION) String authHeader) {
        Long userId = extractUserId(authHeader);
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required");
        }
        conversationService.deleteConversation(id, userId);
    }

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

    public record ConversationDetail(Conversation conversation, List<ChatMessage> messages) {}
}

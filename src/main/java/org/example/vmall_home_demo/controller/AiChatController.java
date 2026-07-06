package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.dto.ChatRequest;
import org.example.vmall_home_demo.dto.ChatResponse;
import org.example.vmall_home_demo.service.AiChatService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ai")
public class AiChatController {

    private final AiChatService aiChatService;

    public AiChatController(AiChatService aiChatService) {
        this.aiChatService = aiChatService;
    }

    @PostMapping("/chat")
    public ChatResponse chat(@RequestBody ChatRequest request) {
        String reply = aiChatService.chat(request.getMessage());
        return new ChatResponse(reply);
    }
}

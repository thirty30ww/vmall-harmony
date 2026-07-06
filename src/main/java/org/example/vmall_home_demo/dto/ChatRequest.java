package org.example.vmall_home_demo.dto;

import java.util.List;

public class ChatRequest {
    private String message;
    private List<ChatMessage> history;
    private Long conversationId;

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public List<ChatMessage> getHistory() { return history; }
    public void setHistory(List<ChatMessage> history) { this.history = history; }
    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
}

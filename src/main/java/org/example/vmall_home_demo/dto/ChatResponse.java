package org.example.vmall_home_demo.dto;

public class ChatResponse {
    private String reply;
    private Long conversationId;

    public ChatResponse() {}

    public ChatResponse(String reply) {
        this.reply = reply;
    }

    public ChatResponse(String reply, Long conversationId) {
        this.reply = reply;
        this.conversationId = conversationId;
    }

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }
    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
}

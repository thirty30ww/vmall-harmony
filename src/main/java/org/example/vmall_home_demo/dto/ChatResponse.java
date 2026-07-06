package org.example.vmall_home_demo.dto;

import java.util.List;

public class ChatResponse {
    private String reply;
    private Long conversationId;
    private List<RecommendedProduct> recommendedProducts;

    public ChatResponse() {}

    public ChatResponse(String reply) {
        this.reply = reply;
    }

    public ChatResponse(String reply, Long conversationId) {
        this.reply = reply;
        this.conversationId = conversationId;
    }

    public ChatResponse(String reply, Long conversationId, List<RecommendedProduct> recommendedProducts) {
        this.reply = reply;
        this.conversationId = conversationId;
        this.recommendedProducts = recommendedProducts;
    }

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }
    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }
    public List<RecommendedProduct> getRecommendedProducts() { return recommendedProducts; }
    public void setRecommendedProducts(List<RecommendedProduct> recommendedProducts) { this.recommendedProducts = recommendedProducts; }
}

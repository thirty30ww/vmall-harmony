package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.dto.ChatMessage;
import org.example.vmall_home_demo.dto.RecommendedProduct;
import org.example.vmall_home_demo.entity.CartItem;
import org.example.vmall_home_demo.entity.Category;
import org.example.vmall_home_demo.entity.User;
import org.example.vmall_home_demo.mapper.CartItemMapper;
import org.example.vmall_home_demo.mapper.CategoryMapper;
import org.example.vmall_home_demo.mapper.UserMapper;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class AiChatService {

    private static final Pattern RECOMMEND_PATTERN = Pattern.compile(
            "【推荐商品编号:\\s*([\\d,\\s]+)】");

    private final ChatClient chatClient;
    private final CategoryMapper categoryMapper;
    private final UserMapper userMapper;
    private final CartItemMapper cartItemMapper;

    public AiChatService(ChatClient.Builder chatClientBuilder,
                         CategoryMapper categoryMapper,
                         UserMapper userMapper,
                         CartItemMapper cartItemMapper) {
        this.chatClient = chatClientBuilder.build();
        this.categoryMapper = categoryMapper;
        this.userMapper = userMapper;
        this.cartItemMapper = cartItemMapper;
    }

    public static class ChatResult {
        private final String reply;
        private final List<RecommendedProduct> recommendedProducts;

        public ChatResult(String reply, List<RecommendedProduct> recommendedProducts) {
            this.reply = reply;
            this.recommendedProducts = recommendedProducts;
        }

        public String getReply() { return reply; }
        public List<RecommendedProduct> getRecommendedProducts() { return recommendedProducts; }
    }

    public ChatResult chat(ChatMessage currentMessage, List<ChatMessage> history, Long userId) {
        List<Category> allCategories = categoryMapper.findAll();
        List<Message> messages = new ArrayList<>();
        messages.add(new SystemMessage(buildSystemPrompt(userId, allCategories)));
        if (history != null) {
            for (ChatMessage msg : history) {
                String role = msg.getRole();
                String content = msg.getContent();
                if ("user".equals(role)) {
                    messages.add(new UserMessage(content));
                } else if ("assistant".equals(role) || "ai".equals(role)) {
                    messages.add(new AssistantMessage(content));
                }
            }
        }
        messages.add(new UserMessage(currentMessage.getContent()));
        String reply = chatClient.prompt()
                .messages(messages)
                .call()
                .content();
        return parseRecommendation(reply, allCategories);
    }

    private ChatResult parseRecommendation(String reply, List<Category> allCategories) {
        if (reply == null) {
            return new ChatResult(null, null);
        }
        String cleaned = cleanMarkdown(reply);
        Matcher matcher = RECOMMEND_PATTERN.matcher(cleaned);
        if (!matcher.find()) {
            return new ChatResult(cleaned, null);
        }
        String idsStr = matcher.group(1);
        String textWithoutMarker = cleaned.replace(matcher.group(), "").trim();
        Map<Integer, Category> categoryMap = allCategories.stream()
                .collect(Collectors.toMap(Category::getId, c -> c, (a, b) -> a));
        String[] parts = idsStr.split("[,\\s]+");
        List<RecommendedProduct> products = new ArrayList<>();
        for (String part : parts) {
            try {
                int id = Integer.parseInt(part.trim());
                Category cat = categoryMap.get(id);
                if (cat != null) {
                    products.add(new RecommendedProduct(
                            cat.getId(),
                            cat.getProductName(),
                            cat.getImageUrl(),
                            cat.getPrice(),
                            cat.getFeature()
                    ));
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return new ChatResult(textWithoutMarker, products.isEmpty() ? null : products);
    }

    private String buildSystemPrompt(Long userId, List<Category> categories) {
        StringBuilder sb = new StringBuilder();
        sb.append("""
                你是一个华为商城(Vmall)的智能导购助手。你的任务是根据商品目录，为用户推荐合适的商品。
                
                请根据用户的需求（预算、用途、偏好等），从商品目录中筛选出最匹配的商品推荐给用户。
                推荐时请说明商品名称、价格和推荐理由。
                如果用户需求不明确，可以主动询问预算或用途。
                如果商品目录中没有合适的商品，请如实告知。
                严禁使用Markdown格式。不要使用任何标记符号。
                注意：回答时不要称呼用户的姓名或用户名，直接回答问题即可。
                
                非常重要：如果你推荐了商品，请在回复的最后一行加上【推荐商品编号: 编号1, 编号2, 编号3】，列出你最推荐的1-3个商品的编号（必须是下面商品目录中【商品编号:XXX】里的整数编号）。多个编号用逗号分隔。
                """);
        if (userId != null) {
            User user = userMapper.findById(userId);
            if (user != null) {
                sb.append("\n当前用户信息：\n");
                List<CartItem> cartItems = cartItemMapper.findByUserId(userId);
                if (!cartItems.isEmpty()) {
                    sb.append("- 购物车商品：\n");
                    for (CartItem item : cartItems) {
                        sb.append("  · ").append(item.getProductName())
                                .append(" ￥").append(item.getProductPrice()).append("\n");
                    }
                }
            }
        }
        sb.append("\n以下是当前商品目录：\n");
        for (Category cat : categories) {
            sb.append("【商品编号:").append(cat.getId()).append("】 ")
                    .append("分类: ").append(cat.getName())
                    .append(" | 组: ").append(cat.getGroupName())
                    .append(" | 商品: ").append(cat.getProductName())
                    .append(" | 描述: ").append(cat.getFeature())
                    .append(" | 价格: ").append(cat.getPrice()).append("元\n");
        }
        return sb.toString();
    }

    private String cleanMarkdown(String text) {
        if (text == null) return null;
        return text
                .replaceAll("\\*\\*|__", "")
                .replaceAll("\\*", "")
                .replaceAll("`{1,3}", "")
                .replaceAll("#{1,6}\\s?", "")
                .replaceAll(">\\s?", "");
    }
}

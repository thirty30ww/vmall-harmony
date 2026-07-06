package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.dto.ChatMessage;
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

@Service
public class AiChatService {

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

    public String chat(ChatMessage currentMessage, List<ChatMessage> history, Long userId) {
        List<Message> messages = new ArrayList<>();
        messages.add(new SystemMessage(buildSystemPrompt(userId)));
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
        return cleanMarkdown(reply);
    }

    private String buildSystemPrompt(Long userId) {
        StringBuilder sb = new StringBuilder();
        sb.append("""
                你是一个华为商城(Vmall)的智能导购助手。你的任务是根据商品目录，为用户推荐合适的商品。
                
                请根据用户的需求（预算、用途、偏好等），从商品目录中筛选出最匹配的商品推荐给用户。
                推荐时请说明商品名称、价格和推荐理由。
                如果用户需求不明确，可以主动询问预算或用途。
                如果商品目录中没有合适的商品，请如实告知。
                严禁使用Markdown格式。不要使用任何标记符号。
                注意：回答时不要称呼用户的姓名或用户名，直接回答问题即可。
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
        List<Category> categories = categoryMapper.findAll();
        for (Category cat : categories) {
            sb.append("- 分类: ").append(cat.getName())
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

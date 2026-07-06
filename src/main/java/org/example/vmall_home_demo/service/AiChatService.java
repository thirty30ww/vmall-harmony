package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.entity.Category;
import org.example.vmall_home_demo.entity.Product;
import org.example.vmall_home_demo.mapper.CategoryMapper;
import org.example.vmall_home_demo.mapper.ProductMapper;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AiChatService {

    private final ChatClient chatClient;
    private final ProductMapper productMapper;
    private final CategoryMapper categoryMapper;

    public AiChatService(ChatClient.Builder chatClientBuilder,
                         ProductMapper productMapper,
                         CategoryMapper categoryMapper) {
        this.chatClient = chatClientBuilder.build();
        this.productMapper = productMapper;
        this.categoryMapper = categoryMapper;
    }

    public String chat(String userMessage) {
        String context = buildProductContext();

        String systemPrompt = """
                你是一个华为商城(Vmall)的智能导购助手。你的任务是根据下面的商品目录，为用户推荐合适的商品。
                
                请根据用户的需求（预算、用途、偏好等），从商品目录中筛选出最匹配的商品推荐给用户。
                推荐时请说明商品名称、价格和推荐理由。
                如果用户需求不明确，可以主动询问预算或用途。
                如果商品目录中没有合适的商品，请如实告知。
                
                以下是当前商品目录：
                %s
                """.formatted(context);

        return chatClient.prompt()
                .system(systemPrompt)
                .user(userMessage)
                .call()
                .content();
    }

    private String buildProductContext() {
        StringBuilder sb = new StringBuilder();

        List<Category> categories = categoryMapper.findAll();
        if (!categories.isEmpty()) {
            sb.append("【分类商品目录】\n");
            for (Category cat : categories) {
                sb.append("- 分类: ").append(cat.getName())
                        .append(" | 组: ").append(cat.getGroupName())
                        .append(" | 商品: ").append(cat.getProductName())
                        .append(" | 描述: ").append(cat.getFeature())
                        .append(" | 价格: ").append(cat.getPrice()).append("元\n");
            }
        }

        List<Product> products = productMapper.findAll(null, 200);
        if (!products.isEmpty()) {
            sb.append("\n【全部商品列表】\n");
            for (Product p : products) {
                sb.append("- 商品名: ").append(p.getName())
                        .append(" | 描述: ").append(p.getFeature())
                        .append(" | 价格: ").append(p.getPrice()).append("元")
                        .append(" | 链接: ").append(p.getProductUrl()).append("\n");
            }
        }

        return sb.toString();
    }
}

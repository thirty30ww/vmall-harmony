package org.example.vmall_home_demo.entity;

import java.time.LocalDateTime;

public class Category {
    private int id;
    private String name;           // 对应 category 字段（一级分类）
    private String groupName;      // 对应 group 字段（二级分组）
    private String productName;    // 产品名称
    private String imageUrl;       // 图片链接
    private LocalDateTime scrapedAt;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public LocalDateTime getScrapedAt() {
        return scrapedAt;
    }

    public void setScrapedAt(LocalDateTime scrapedAt) {
        this.scrapedAt = scrapedAt;
    }

}

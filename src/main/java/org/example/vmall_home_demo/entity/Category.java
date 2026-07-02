package org.example.vmall_home_demo.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Category {
    private int id;
    private String name;           // first-level category
    private String groupName;      // second-level group
    private String productName;    // product name
    private String feature;        // product description
    private BigDecimal price;      // product price
    private String imageUrl;       // product image URL
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

    public String getFeature() {
        return feature;
    }

    public void setFeature(String feature) {
        this.feature = feature;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
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

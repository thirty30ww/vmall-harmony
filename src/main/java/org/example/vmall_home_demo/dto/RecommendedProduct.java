package org.example.vmall_home_demo.dto;

import java.math.BigDecimal;

public class RecommendedProduct {
    private int productId;
    private String productName;
    private String imageUrl;
    private BigDecimal price;
    private String feature;

    public RecommendedProduct() {}

    public RecommendedProduct(int productId, String productName, String imageUrl, BigDecimal price, String feature) {
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.price = price;
        this.feature = feature;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public String getFeature() { return feature; }
    public void setFeature(String feature) { this.feature = feature; }
}

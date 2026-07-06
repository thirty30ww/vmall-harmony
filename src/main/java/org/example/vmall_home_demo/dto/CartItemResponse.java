package org.example.vmall_home_demo.dto;

import java.math.BigDecimal;

public class CartItemResponse {
    private Long id;
    private Long productId;
    private String productSource;
    private String productName;
    private String productImage;
    private BigDecimal productPrice;
    private String productFeature;
    private Integer quantity;
    private BigDecimal lineAmount;

    public CartItemResponse(Long id, Long productId, String productSource, String productName,
                            String productImage, BigDecimal productPrice, String productFeature,
                            Integer quantity, BigDecimal lineAmount) {
        this.id = id;
        this.productId = productId;
        this.productSource = productSource;
        this.productName = productName;
        this.productImage = productImage;
        this.productPrice = productPrice;
        this.productFeature = productFeature;
        this.quantity = quantity;
        this.lineAmount = lineAmount;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public String getProductSource() {
        return productSource;
    }

    public void setProductSource(String productSource) {
        this.productSource = productSource;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductImage() {
        return productImage;
    }

    public void setProductImage(String productImage) {
        this.productImage = productImage;
    }

    public BigDecimal getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(BigDecimal productPrice) {
        this.productPrice = productPrice;
    }

    public String getProductFeature() {
        return productFeature;
    }

    public void setProductFeature(String productFeature) {
        this.productFeature = productFeature;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getLineAmount() {
        return lineAmount;
    }

    public void setLineAmount(BigDecimal lineAmount) {
        this.lineAmount = lineAmount;
    }
}
package org.example.vmall_home_demo.dto;

public class CategoryPageProductDto {
    private Integer id;
    private Integer categoryId;
    private String name;
    private String imageUrl;
    private String productUrl;
    private Integer sortOrder;

    public CategoryPageProductDto(Integer id, Integer categoryId, String name, String imageUrl, String productUrl, Integer sortOrder) {
        this.id = id;
        this.categoryId = categoryId;
        this.name = name;
        this.imageUrl = imageUrl;
        this.productUrl = productUrl;
        this.sortOrder = sortOrder;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getProductUrl() {
        return productUrl;
    }

    public void setProductUrl(String productUrl) {
        this.productUrl = productUrl;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }
}

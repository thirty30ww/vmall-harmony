package org.example.vmall_home_demo.dto;

import java.util.List;

public class CategoryPageCategoryDto {
    private Integer id;
    private String name;
    private Integer sortOrder;
    private List<CategoryPageProductDto> products;

    public CategoryPageCategoryDto(Integer id, String name, Integer sortOrder, List<CategoryPageProductDto> products) {
        this.id = id;
        this.name = name;
        this.sortOrder = sortOrder;
        this.products = products;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public List<CategoryPageProductDto> getProducts() {
        return products;
    }

    public void setProducts(List<CategoryPageProductDto> products) {
        this.products = products;
    }
}

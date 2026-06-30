package org.example.vmall_home_demo.dto;

import java.util.List;

public class CategoryPageResponse {
    private List<CategoryPageCategoryDto> categories;

    public CategoryPageResponse(List<CategoryPageCategoryDto> categories) {
        this.categories = categories;
    }

    public List<CategoryPageCategoryDto> getCategories() {
        return categories;
    }

    public void setCategories(List<CategoryPageCategoryDto> categories) {
        this.categories = categories;
    }
}

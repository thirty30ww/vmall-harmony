package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.dto.CategoryPageResponse;
import org.example.vmall_home_demo.service.CategoryPageService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/category-page")
public class CategoryPageController {
    private final CategoryPageService categoryPageService;

    public CategoryPageController(CategoryPageService categoryPageService) {
        this.categoryPageService = categoryPageService;
    }

    @GetMapping
    public CategoryPageResponse getCategoryPage() {
        return categoryPageService.getCategoryPage();
    }
}

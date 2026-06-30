package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.entity.Category;
import org.example.vmall_home_demo.mapper.CategoryMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {
    private final CategoryMapper categoryMapper;

    public CategoryService(CategoryMapper categoryMapper) {
        this.categoryMapper = categoryMapper;
    }

    public List<Category> listCategories() {
        return categoryMapper.findAll();
    }
}

package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.dto.CategoryPageCategoryDto;
import org.example.vmall_home_demo.dto.CategoryPageResponse;
import org.example.vmall_home_demo.entity.CategoryPageMenu;
import org.example.vmall_home_demo.mapper.CategoryPageMapper;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CategoryPageService {
    private final CategoryPageMapper categoryPageMapper;

    public CategoryPageService(CategoryPageMapper categoryPageMapper) {
        this.categoryPageMapper = categoryPageMapper;
    }

    public CategoryPageResponse getCategoryPage() {
        List<CategoryPageMenu> menus = categoryPageMapper.findMenus();
        List<CategoryPageCategoryDto> categories = menus.stream()
                .map(this::toCategoryDto)
                .toList();
        return new CategoryPageResponse(categories);
    }

    private CategoryPageCategoryDto toCategoryDto(CategoryPageMenu menu) {
        // 直接使用数据库的 id 字段，sortOrder 暂时设为 0
        return new CategoryPageCategoryDto(
                menu.getId(),
                menu.getName(),
                0,
                List.of()
        );
    }
}
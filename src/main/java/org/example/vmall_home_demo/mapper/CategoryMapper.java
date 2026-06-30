package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.vmall_home_demo.entity.Category;

import java.util.List;

@Mapper
public interface CategoryMapper {
    @Select("""
            SELECT id,
                   category AS name,
                   `group` AS groupName,
                   product_name AS productName,
                   image_url AS imageUrl,
                   scraped_at AS scrapedAt
            FROM vmall_homepage_categories
            ORDER BY id ASC
            """)
    List<Category> findAll();
}
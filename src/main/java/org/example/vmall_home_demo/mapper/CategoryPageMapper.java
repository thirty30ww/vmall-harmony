package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.vmall_home_demo.entity.CategoryPageMenu;

import java.util.List;

@Mapper
public interface CategoryPageMapper {
    @Select("""
            SELECT 
                   MIN(id) AS id,
                   category AS name
            FROM vmall_homepage_categories
            GROUP BY category
            ORDER BY MIN(id) ASC
            """)
    List<CategoryPageMenu> findMenus();
}
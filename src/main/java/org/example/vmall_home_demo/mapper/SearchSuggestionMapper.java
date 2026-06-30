package org.example.vmall_home_demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.example.vmall_home_demo.entity.SearchSuggestion;

import java.util.List;

@Mapper
public interface SearchSuggestionMapper {
    @Select("""
            SELECT id,
                   keyword,
                   scraped_at AS scrapedAt
            FROM vmall_homepage_search_suggestions
            ORDER BY id ASC
            """)
    List<SearchSuggestion> findAll();
}

package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.entity.SearchSuggestion;
import org.example.vmall_home_demo.mapper.SearchSuggestionMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SearchSuggestionService {
    private final SearchSuggestionMapper searchSuggestionMapper;

    public SearchSuggestionService(SearchSuggestionMapper searchSuggestionMapper) {
        this.searchSuggestionMapper = searchSuggestionMapper;
    }

    public List<SearchSuggestion> listSearchSuggestions() {
        return searchSuggestionMapper.findAll();
    }
}

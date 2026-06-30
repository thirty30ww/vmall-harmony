package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.entity.SearchSuggestion;
import org.example.vmall_home_demo.service.SearchSuggestionService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/search-suggestions")
public class SearchSuggestionController {
    private final SearchSuggestionService searchSuggestionService;

    public SearchSuggestionController(SearchSuggestionService searchSuggestionService) {
        this.searchSuggestionService = searchSuggestionService;
    }

    @GetMapping
    public List<SearchSuggestion> listSearchSuggestions() {
        return searchSuggestionService.listSearchSuggestions();
    }
}

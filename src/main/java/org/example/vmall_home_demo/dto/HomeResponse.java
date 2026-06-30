package org.example.vmall_home_demo.dto;

import org.example.vmall_home_demo.entity.Activity;
import org.example.vmall_home_demo.entity.Category;
import org.example.vmall_home_demo.entity.Product;
import org.example.vmall_home_demo.entity.SearchSuggestion;

import java.util.List;

public class HomeResponse {
    private List<Category> categories;
    private List<SearchSuggestion> suggestions;
    private List<Activity> activities;
    private List<Product> products;

    public HomeResponse(List<Category> categories,
                        List<SearchSuggestion> suggestions,
                        List<Activity> activities,
                        List<Product> products) {
        this.categories = categories;
        this.suggestions = suggestions;
        this.activities = activities;
        this.products = products;
    }

    public List<Category> getCategories() {
        return categories;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
    }

    public List<SearchSuggestion> getSuggestions() {
        return suggestions;
    }

    public void setSuggestions(List<SearchSuggestion> suggestions) {
        this.suggestions = suggestions;
    }

    public List<Activity> getActivities() {
        return activities;
    }

    public void setActivities(List<Activity> activities) {
        this.activities = activities;
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }
}

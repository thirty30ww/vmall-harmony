package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.dto.HomeResponse;
import org.springframework.stereotype.Service;

@Service
public class HomeService {
    private static final int HOME_PRODUCT_LIMIT = 20;

    private final CategoryService categoryService;
    private final SearchSuggestionService searchSuggestionService;
    private final ActivityService activityService;
    private final ProductService productService;

    public HomeService(CategoryService categoryService,
                       SearchSuggestionService searchSuggestionService,
                       ActivityService activityService,
                       ProductService productService) {
        this.categoryService = categoryService;
        this.searchSuggestionService = searchSuggestionService;
        this.activityService = activityService;
        this.productService = productService;
    }

    public HomeResponse getHomeData() {
        return new HomeResponse(
                categoryService.listCategories(),
                searchSuggestionService.listSearchSuggestions(),
                activityService.listActivities(),
                productService.listProducts(null, HOME_PRODUCT_LIMIT)
        );
    }
}

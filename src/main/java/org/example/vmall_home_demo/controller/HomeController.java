package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.dto.HomeResponse;
import org.example.vmall_home_demo.service.HomeService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/home")
public class HomeController {
    private final HomeService homeService;

    public HomeController(HomeService homeService) {
        this.homeService = homeService;
    }

    @GetMapping
    public HomeResponse getHomeData() {
        return homeService.getHomeData();
    }
}

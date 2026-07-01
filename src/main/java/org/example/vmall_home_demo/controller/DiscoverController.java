package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.dto.DiscoverResponse;
import org.example.vmall_home_demo.dto.DiscoverSectionDto;
import org.example.vmall_home_demo.entity.DiscoverItem;
import org.example.vmall_home_demo.entity.DiscoverTab;
import org.example.vmall_home_demo.service.DiscoverService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/discover")
public class DiscoverController {
    private final DiscoverService discoverService;

    public DiscoverController(DiscoverService discoverService) {
        this.discoverService = discoverService;
    }

    @GetMapping
    public DiscoverResponse getDiscoverPage(
            @RequestParam(required = false) String pageId,
            @RequestParam(required = false) String tabName
    ) {
        return discoverService.getDiscoverPage(pageId, tabName);
    }

    @GetMapping("/tabs")
    public List<DiscoverTab> listTabs(@RequestParam(required = false) String pageId) {
        return discoverService.listTabs(pageId);
    }

    @GetMapping("/sections")
    public List<DiscoverSectionDto> listSections(
            @RequestParam(required = false) String pageId,
            @RequestParam(required = false) String tabName
    ) {
        return discoverService.listSections(pageId, tabName);
    }

    @GetMapping("/items")
    public List<DiscoverItem> listItemsByCardId(@RequestParam String cardId) {
        return discoverService.listItemsByCardId(cardId);
    }
}

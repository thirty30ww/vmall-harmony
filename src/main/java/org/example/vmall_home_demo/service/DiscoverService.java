package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.dto.DiscoverResponse;
import org.example.vmall_home_demo.dto.DiscoverSectionDto;
import org.example.vmall_home_demo.entity.DiscoverItem;
import org.example.vmall_home_demo.entity.DiscoverNavIcon;
import org.example.vmall_home_demo.entity.DiscoverPage;
import org.example.vmall_home_demo.entity.DiscoverSection;
import org.example.vmall_home_demo.entity.DiscoverTab;
import org.example.vmall_home_demo.mapper.DiscoverMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service
public class DiscoverService {
    private final DiscoverMapper discoverMapper;

    public DiscoverService(DiscoverMapper discoverMapper) {
        this.discoverMapper = discoverMapper;
    }

    public DiscoverResponse getDiscoverPage(String pageId, String tabName) {
        String normalizedPageId = normalize(pageId);
        String normalizedTabName = normalize(tabName);
        String contentPageId = resolveContentPageId(normalizedPageId, normalizedTabName);

        List<DiscoverPage> pages = discoverMapper.findPages(normalizedPageId);
        List<DiscoverTab> tabs = discoverMapper.findTabs(normalizedPageId);
        if (tabs.isEmpty()) {
            tabs = discoverMapper.findTabs(null);
        }
        List<DiscoverNavIcon> navIcons = discoverMapper.findNavIcons(normalizedPageId);
        List<DiscoverSection> sections = discoverMapper.findSections(contentPageId, normalizedTabName);
        List<DiscoverItem> items = discoverMapper.findItems(contentPageId, normalizedTabName);

        if (normalizedTabName != null && sections.isEmpty()) {
            sections = discoverMapper.findSections(contentPageId, null);
            items = discoverMapper.findItems(contentPageId, null);
        }

        if (normalizedTabName != null && normalizedPageId != null && contentPageId != null && !normalizedPageId.equals(contentPageId)) {
            List<DiscoverSection> bannerSections = discoverMapper.findSections(normalizedPageId, null);
            List<DiscoverItem> bannerItems = discoverMapper.findItems(normalizedPageId, null);
            sections = concat(bannerSections, sections);
            items = concat(bannerItems, items);
        }

        return buildResponse(pages, tabs, navIcons, sections, items);
    }

    public List<DiscoverTab> listTabs(String pageId) {
        List<DiscoverTab> tabs = discoverMapper.findTabs(normalize(pageId));
        if (tabs.isEmpty()) {
            return discoverMapper.findTabs(null);
        }
        return tabs;
    }

    public List<DiscoverSectionDto> listSections(String pageId, String tabName) {
        String normalizedPageId = normalize(pageId);
        String normalizedTabName = normalize(tabName);
        String contentPageId = resolveContentPageId(normalizedPageId, normalizedTabName);
        List<DiscoverSection> sections = discoverMapper.findSections(contentPageId, normalizedTabName);
        List<DiscoverItem> items = discoverMapper.findItems(contentPageId, normalizedTabName);

        if (normalizedTabName != null && sections.isEmpty()) {
            sections = discoverMapper.findSections(contentPageId, null);
            items = discoverMapper.findItems(contentPageId, null);
        }

        return buildSections(sections, items);
    }

    public List<DiscoverItem> listItemsByCardId(String cardId) {
        return discoverMapper.findItemsByCardId(cardId);
    }

    private DiscoverResponse buildResponse(
            List<DiscoverPage> pages,
            List<DiscoverTab> tabs,
            List<DiscoverNavIcon> navIcons,
            List<DiscoverSection> sections,
            List<DiscoverItem> items
    ) {
        return new DiscoverResponse(pages, tabs, navIcons, buildSections(sections, items));
    }

    private List<DiscoverSectionDto> buildSections(List<DiscoverSection> sections, List<DiscoverItem> items) {
        Map<String, List<DiscoverItem>> itemsByCardId = items.stream()
                .collect(Collectors.groupingBy(DiscoverItem::getCardId));

        return sections.stream()
                .map(section -> new DiscoverSectionDto(
                        section,
                        itemsByCardId.getOrDefault(section.getCardId(), List.of())
                ))
                .toList();
    }

    private String resolveContentPageId(String pageId, String tabName) {
        if (tabName == null) {
            return pageId;
        }

        DiscoverTab tab = discoverMapper.findTabByName(tabName);
        if (tab != null && tab.getRelatedPageId() != null && !tab.getRelatedPageId().isBlank()) {
            return tab.getRelatedPageId();
        }
        return pageId;
    }

    private <T> List<T> concat(List<T> first, List<T> second) {
        return Stream.concat(first.stream(), second.stream()).toList();
    }

    private String normalize(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
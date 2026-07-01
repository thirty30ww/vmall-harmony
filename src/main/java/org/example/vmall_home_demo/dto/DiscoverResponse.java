package org.example.vmall_home_demo.dto;

import org.example.vmall_home_demo.entity.DiscoverNavIcon;
import org.example.vmall_home_demo.entity.DiscoverPage;
import org.example.vmall_home_demo.entity.DiscoverTab;

import java.util.List;

public class DiscoverResponse {
    private List<DiscoverPage> pages;
    private List<DiscoverTab> tabs;
    private List<DiscoverNavIcon> navIcons;
    private List<DiscoverSectionDto> sections;

    public DiscoverResponse(
            List<DiscoverPage> pages,
            List<DiscoverTab> tabs,
            List<DiscoverNavIcon> navIcons,
            List<DiscoverSectionDto> sections
    ) {
        this.pages = pages;
        this.tabs = tabs;
        this.navIcons = navIcons;
        this.sections = sections;
    }

    public List<DiscoverPage> getPages() {
        return pages;
    }

    public void setPages(List<DiscoverPage> pages) {
        this.pages = pages;
    }

    public List<DiscoverTab> getTabs() {
        return tabs;
    }

    public void setTabs(List<DiscoverTab> tabs) {
        this.tabs = tabs;
    }

    public List<DiscoverNavIcon> getNavIcons() {
        return navIcons;
    }

    public void setNavIcons(List<DiscoverNavIcon> navIcons) {
        this.navIcons = navIcons;
    }

    public List<DiscoverSectionDto> getSections() {
        return sections;
    }

    public void setSections(List<DiscoverSectionDto> sections) {
        this.sections = sections;
    }
}

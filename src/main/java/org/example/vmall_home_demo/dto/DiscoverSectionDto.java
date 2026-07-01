package org.example.vmall_home_demo.dto;

import org.example.vmall_home_demo.entity.DiscoverItem;
import org.example.vmall_home_demo.entity.DiscoverSection;

import java.util.List;

public class DiscoverSectionDto {
    private DiscoverSection section;
    private List<DiscoverItem> items;

    public DiscoverSectionDto(DiscoverSection section, List<DiscoverItem> items) {
        this.section = section;
        this.items = items;
    }

    public DiscoverSection getSection() {
        return section;
    }

    public void setSection(DiscoverSection section) {
        this.section = section;
    }

    public List<DiscoverItem> getItems() {
        return items;
    }

    public void setItems(List<DiscoverItem> items) {
        this.items = items;
    }
}

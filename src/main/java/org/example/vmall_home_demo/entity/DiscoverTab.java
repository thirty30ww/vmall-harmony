package org.example.vmall_home_demo.entity;

import java.time.LocalDateTime;

public class DiscoverTab {
    private Integer id;
    private String tabKey;
    private String tabName;
    private String relatedPageId;
    private Integer sortOrder;
    private LocalDateTime createdAt;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTabKey() {
        return tabKey;
    }

    public void setTabKey(String tabKey) {
        this.tabKey = tabKey;
    }

    public String getTabName() {
        return tabName;
    }

    public void setTabName(String tabName) {
        this.tabName = tabName;
    }

    public String getRelatedPageId() {
        return relatedPageId;
    }

    public void setRelatedPageId(String relatedPageId) {
        this.relatedPageId = relatedPageId;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

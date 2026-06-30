package org.example.vmall_home_demo.entity;

import java.time.LocalDateTime;

public class CategoryPageMenu {
    private int id;
    private String name;          // 一级分类名称（如：手机、穿戴）
    private LocalDateTime createdAt;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
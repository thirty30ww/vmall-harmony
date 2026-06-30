package org.example.vmall_home_demo.dto;

public class UserInfo {
    private Long id;
    private String phone;
    private String username;

    public UserInfo(Long id, String phone, String username) {
        this.id = id;
        this.phone = phone;
        this.username = username;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
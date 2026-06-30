package org.example.vmall_home_demo.dto;

public class SendCodeResponse {
    private String phone;
    private Integer expiresInSeconds;
    private String message;

    public SendCodeResponse(String phone, Integer expiresInSeconds, String message) {
        this.phone = phone;
        this.expiresInSeconds = expiresInSeconds;
        this.message = message;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Integer getExpiresInSeconds() {
        return expiresInSeconds;
    }

    public void setExpiresInSeconds(Integer expiresInSeconds) {
        this.expiresInSeconds = expiresInSeconds;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
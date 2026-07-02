package org.example.vmall_home_demo.dto;

import java.math.BigDecimal;
import java.util.List;

public class CartSummaryResponse {
    private List<CartItemResponse> items;
    private Integer selectedCount;
    private BigDecimal totalAmount;

    public CartSummaryResponse(List<CartItemResponse> items, Integer selectedCount, BigDecimal totalAmount) {
        this.items = items;
        this.selectedCount = selectedCount;
        this.totalAmount = totalAmount;
    }

    public List<CartItemResponse> getItems() {
        return items;
    }

    public void setItems(List<CartItemResponse> items) {
        this.items = items;
    }

    public Integer getSelectedCount() {
        return selectedCount;
    }

    public void setSelectedCount(Integer selectedCount) {
        this.selectedCount = selectedCount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
}
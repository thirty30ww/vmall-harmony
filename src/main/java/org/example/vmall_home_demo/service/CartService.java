package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.dto.AddCartItemRequest;
import org.example.vmall_home_demo.dto.CartItemResponse;
import org.example.vmall_home_demo.dto.CartSummaryResponse;
import org.example.vmall_home_demo.dto.SelectAllCartRequest;
import org.example.vmall_home_demo.dto.UpdateCartItemRequest;
import org.example.vmall_home_demo.entity.CartItem;
import org.example.vmall_home_demo.mapper.CartItemMapper;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.util.List;

@Service
public class CartService {
    private final CartItemMapper cartItemMapper;

    public CartService(CartItemMapper cartItemMapper) {
        this.cartItemMapper = cartItemMapper;
    }

    public CartSummaryResponse getCart(Long userId) {
        return buildSummary(cartItemMapper.findByUserId(userId));
    }

    public CartSummaryResponse addItem(Long userId, AddCartItemRequest request) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "request is required");
        }
        String source = trimToNull(request.getProductSource());
        String name = trimToNull(request.getProductName());
        if (source == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "productSource is required");
        }
        if (name == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "productName is required");
        }

        CartItem item = new CartItem();
        item.setUserId(userId);
        item.setProductId(request.getProductId() == null ? 0L : request.getProductId());
        item.setProductSource(source);
        item.setProductName(name);
        item.setProductImage(trimToNull(request.getProductImage()));
        item.setProductPrice(request.getProductPrice() == null ? BigDecimal.ZERO : request.getProductPrice());
        item.setProductFeature(trimToNull(request.getProductFeature()));
        item.setQuantity(normalizeQuantity(request.getQuantity()));
        cartItemMapper.insertOrIncrease(item);
        return getCart(userId);
    }

    public CartSummaryResponse updateItem(Long userId, Long itemId, UpdateCartItemRequest request) {
        if (itemId == null || itemId <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "cart item id is invalid");
        }
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "request is required");
        }
        Integer quantity = request.getQuantity() == null ? null : normalizeQuantity(request.getQuantity());
        if (quantity != null) {
            cartItemMapper.updateQuantity(itemId, userId, quantity);
        }
        if (request.getSelected() != null) {
            cartItemMapper.updateSelected(itemId, userId, boolToInt(request.getSelected()));
        }
        return getCart(userId);
    }

    public CartSummaryResponse deleteItem(Long userId, Long itemId) {
        if (itemId == null || itemId <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "cart item id is invalid");
        }
        cartItemMapper.deleteByIdAndUserId(itemId, userId);
        return getCart(userId);
    }

    public CartSummaryResponse selectAll(Long userId, SelectAllCartRequest request) {
        if (request == null || request.getSelected() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "selected is required");
        }
        cartItemMapper.updateAllSelected(userId, boolToInt(request.getSelected()));
        return getCart(userId);
    }

    private CartSummaryResponse buildSummary(List<CartItem> items) {
        List<CartItemResponse> responses = items.stream()
                .map(this::toResponse)
                .toList();
        int selectedCount = 0;
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItemResponse item : responses) {
            if (Boolean.TRUE.equals(item.getSelected())) {
                selectedCount += item.getQuantity() == null ? 0 : item.getQuantity();
                totalAmount = totalAmount.add(item.getLineAmount());
            }
        }
        return new CartSummaryResponse(responses, selectedCount, totalAmount);
    }

    private CartItemResponse toResponse(CartItem item) {
        int quantity = item.getQuantity() == null ? 1 : item.getQuantity();
        BigDecimal price = item.getProductPrice() == null ? BigDecimal.ZERO : item.getProductPrice();
        BigDecimal lineAmount = price.multiply(BigDecimal.valueOf(quantity));
        return new CartItemResponse(
                item.getId(),
                item.getProductId(),
                item.getProductSource(),
                item.getProductName(),
                item.getProductImage(),
                price,
                item.getProductFeature(),
                quantity,
                isSelected(item.getSelected()),
                lineAmount
        );
    }

    private boolean isSelected(Integer selected) {
        return selected != null && selected == 1;
    }

    private Integer boolToInt(Boolean value) {
        return Boolean.TRUE.equals(value) ? 1 : 0;
    }

    private Integer normalizeQuantity(Integer quantity) {
        if (quantity == null || quantity < 1) {
            return 1;
        }
        return Math.min(quantity, 99);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
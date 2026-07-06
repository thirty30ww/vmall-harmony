package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.dto.AddCartItemRequest;
import org.example.vmall_home_demo.dto.CartSummaryResponse;
import org.example.vmall_home_demo.dto.SelectAllCartRequest;
import org.example.vmall_home_demo.dto.UpdateCartItemRequest;
import org.example.vmall_home_demo.dto.UserInfo;
import org.example.vmall_home_demo.service.CartService;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/cart")
public class CartController {
    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping
    public CartSummaryResponse getCart(@AuthenticationPrincipal UserInfo user) {
        return cartService.getCart(currentUserId(user));
    }

    @PostMapping("/items")
    public CartSummaryResponse addItem(@AuthenticationPrincipal UserInfo user,
                                       @RequestBody AddCartItemRequest request) {
        return cartService.addItem(currentUserId(user), request);
    }

    @PutMapping("/items/{id}")
    public CartSummaryResponse updateItem(@AuthenticationPrincipal UserInfo user,
                                          @PathVariable Long id,
                                          @RequestBody UpdateCartItemRequest request) {
        return cartService.updateItem(currentUserId(user), id, request);
    }

    @RequestMapping(value = "/items/{id}", method = { RequestMethod.DELETE, RequestMethod.POST })
    public CartSummaryResponse deleteItem(@AuthenticationPrincipal UserInfo user,
                                          @PathVariable Long id) {
        return cartService.deleteItem(currentUserId(user), id);
    }

    @PutMapping("/select-all")
    public CartSummaryResponse selectAll(@AuthenticationPrincipal UserInfo user,
                                         @RequestBody SelectAllCartRequest request) {
        return cartService.selectAll(currentUserId(user), request);
    }

    private Long currentUserId(UserInfo user) {
        if (user == null || user.getId() == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "login required");
        }
        return user.getId();
    }
}
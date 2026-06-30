package org.example.vmall_home_demo.controller;

import org.example.vmall_home_demo.entity.Product;
import org.example.vmall_home_demo.service.ProductService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {
    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public List<Product> listProducts(@RequestParam(required = false) String keyword,
                                      @RequestParam(required = false) Integer limit) {
        return productService.listProducts(keyword, limit);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductDetail(@PathVariable Integer id) {
        Product product = productService.getProductById(id);
        if (product == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(product);
    }
}

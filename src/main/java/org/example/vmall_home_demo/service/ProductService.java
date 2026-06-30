package org.example.vmall_home_demo.service;

import org.example.vmall_home_demo.entity.Product;
import org.example.vmall_home_demo.mapper.ProductMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {
    private final ProductMapper productMapper;

    public ProductService(ProductMapper productMapper) {
        this.productMapper = productMapper;
    }

    public List<Product> listProducts(String keyword, Integer limit) {
        return productMapper.findAll(keyword, limit);
    }

    public Product getProductById(Integer id) {
        return productMapper.findById(id);
    }
}

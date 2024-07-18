package com.example.simplemicroservice.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.simplemicroservice.entities.Product;
import com.example.simplemicroservice.services.ImplProductService;

@RestController
@RequestMapping("/api")
public class ProductController {
    
    @Autowired
    private ImplProductService productService;

    @GetMapping("/products")
    public List<Product> listAllProducts() {
        return productService.listAllProducts();
    }

    @GetMapping("/products/{id}")
    public Product getProductById(@PathVariable Long id) {
        return productService.getProductById(id);
    }
}

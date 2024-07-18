package com.example.itemsMicroservice;

import com.example.itemsMicroservice.entities.Product;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@FeignClient(name = "service.product", url = "localhost:8081")
public interface ProductClientRest {
    @GetMapping("/api/products")
    public List<Product> getProducts();

    @GetMapping("api/products/{id}")
    public Product getProductById(@PathVariable  Long id);
}

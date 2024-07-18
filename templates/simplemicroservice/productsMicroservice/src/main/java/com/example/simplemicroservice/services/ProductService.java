package com.example.simplemicroservice.services;

import java.util.List;

import com.example.simplemicroservice.entities.Product;

public interface ProductService {
    public List<Product> listAllProducts();

    public Product getProductById(Long id);

    public Product saveProduct(Product product);

    public void deleteProduct(Long id);
}

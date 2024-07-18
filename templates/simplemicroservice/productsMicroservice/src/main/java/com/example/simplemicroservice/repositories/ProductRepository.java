package com.example.simplemicroservice.repositories;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.example.simplemicroservice.entities.Product;

@Repository
public interface ProductRepository extends CrudRepository<Product, Long> {

}

package com.example.itemsMicroservice.controllers;


import com.example.itemsMicroservice.services.ItemService;
import main.java.com.example.itemsMicroservice.entities.Item;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api")
public class ProductController {

    @Autowired
    private ItemService itemService;

    @GetMapping("/items")
    public List<main.java.com.example.itemsMicroservice.entities.Item> getItems() {
        return itemService.findAll();
    }

    @GetMapping("/items/{id}/quantity/{quantity}")
    public Item getItems(@PathVariable long id, @PathVariable int quantity) {
        return itemService.findById(id, quantity);
    }
}
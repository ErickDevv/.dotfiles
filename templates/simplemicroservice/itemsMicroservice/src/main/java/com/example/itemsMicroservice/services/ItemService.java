package com.example.itemsMicroservice.services;

import java.util.List;
import main.java.com.example.itemsMicroservice.entities.Item;

public interface ItemService {
    public List<Item> findAll();
    public Item findById(Long id, Integer quantity);
}

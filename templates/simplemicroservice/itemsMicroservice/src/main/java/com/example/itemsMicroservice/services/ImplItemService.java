package com.example.itemsMicroservice.services;

import com.example.itemsMicroservice.entities.Product;
import main.java.com.example.itemsMicroservice.entities.Item;
import org.springframework.context.annotation.Primary;
import org.springframework.web.client.RestTemplate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import java.util.List;

@Service("serviceRestTemplate")
public class ImplItemService implements ItemService {

    private List<Item> items;

    @Autowired
    private RestTemplate clientRest;

    @Override
    public List<Item> findAll() {
        List<Product> products = Arrays.asList(clientRest.getForObject("http://localhost:8081/api/products", Product[].class));
        return products.stream().map(p -> new Item(p, 1)).collect(Collectors.toList());
    }

    @Override
    public Item findById(Long id, Integer cantidad) {
        Map<String, String> pathVariables = new HashMap<String, String>();
        pathVariables.put("id", id.toString());
        Product producto = clientRest.getForObject("http://localhost:8081/api/products/{id}", Product.class, pathVariables);
        return new Item(producto, cantidad);
    }
}

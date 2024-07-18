package main.java.com.example.itemsMicroservice.entities;

import com.example.itemsMicroservice.entities.Product;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
public class Item {
    private Product product;
    private Integer quantity;

    private double getTotal() {
        return product.getPrice() * quantity.doubleValue();
    }
}

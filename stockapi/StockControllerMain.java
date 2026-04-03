package com.example.stockapi.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/v1/stock")
public class StockController {

    private Map<String, Map<String, Stock>> database = new HashMap<>();

    // Model
    static class Stock {
        public String product_id;
        public String location_id;
        public int quantity;
        public int reserved;

        public Stock(String product_id, String location_id, int quantity) {
            this.product_id = product_id;
            this.location_id = location_id;
            this.quantity = quantity;
            this.reserved = 0;
        }
    }

    // GET all
    @GetMapping
    public ResponseEntity<?> getAll() {
        List<Stock> result = new ArrayList<>();
        database.values().forEach(map -> result.addAll(map.values()));
        return ResponseEntity.ok(result);
    }

    // GET by product_id
    @GetMapping("/{product_id}")
    public ResponseEntity<?> getByProduct(@PathVariable String product_id) {
        if (!database.containsKey(product_id)) {
            return ResponseEntity.status(404).body(Map.of(
                    "error", "product_not_found",
                    "message", "Produto não encontrado"
            ));
        }
        return ResponseEntity.ok(database.get(product_id).values());
    }

    // POST create
    @PostMapping
    public ResponseEntity<?> create(@RequestBody Stock request) {
        if (request.quantity < 0) {
            return ResponseEntity.badRequest().body(Map.of(
                    "error", "invalid_request",
                    "message", "Quantidade inválida"
            ));
        }

        database.putIfAbsent(request.product_id, new HashMap<>());
        database.get(request.product_id).put(request.location_id,
                new Stock(request.product_id, request.location_id, request.quantity));

        return ResponseEntity.status(201).body(Map.of(
                "message", "stock_created",
                "product_id", request.product_id,
                "location_id", request.location_id,
                "quantity", request.quantity
        ));
    }

    // PUT update
    @PutMapping("/{product_id}/{location_id}")
    public ResponseEntity<?> update(@PathVariable String product_id,
                                    @PathVariable String location_id,
                                    @RequestBody Stock request) {

        if (!database.containsKey(product_id) ||
                !database.get(product_id).containsKey(location_id)) {
            return ResponseEntity.status(404).body(Map.of(
                    "error", "stock_not_found",
                    "message", "Registro de estoque não encontrado"
            ));
        }

        Stock stock = database.get(product_id).get(location_id);
        stock.quantity = request.quantity;
        stock.reserved = request.reserved;

        return ResponseEntity.ok(Map.of(
                "message", "stock_updated",
                "product_id", product_id,
                "location_id", location_id,
                "quantity", stock.quantity,
                "reserved", stock.reserved
        ));
    }

    // DELETE
    @DeleteMapping("/{product_id}/{location_id}")
    public ResponseEntity<?> delete(@PathVariable String product_id,
                                    @PathVariable String location_id) {

        if (!database.containsKey(product_id) ||
                !database.get(product_id).containsKey(location_id)) {
            return ResponseEntity.status(404).body(Map.of(
                    "error", "stock_not_found",
                    "message", "Registro de estoque não encontrado"
            ));
        }

        database.get(product_id).remove(location_id);

        return ResponseEntity.ok(Map.of(
                "message", "stock_deleted"
        ));
    }
}


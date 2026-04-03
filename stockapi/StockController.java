package com.example.stockapi.controller;

import com.example.stockapi.model.Stock;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/v1/stock")
public class StockController {

    private Map<String, Map<String, Stock>> database = new HashMap<>();

    //pega tudo
    @GetMapping
    public ResponseEntity<?> getAll() {
        List<Stock> result = new ArrayList<>();
        for (Map<String, Stock> map : database.values()) {
            for (Stock s : map.values()) {
                result.add(s);
            }
        }
        return ResponseEntity.ok(result);
    }

    //pega por id
    @GetMapping("/{product_id}")
    public ResponseEntity<?> getByProduct(@PathVariable String product_id) {
        if (database.containsKey(product_id) == false) {
            return ResponseEntity.status(404).body("Produto não encontrado");
        }
        return ResponseEntity.ok(database.get(product_id).values());
    }

    //criar
    @PostMapping
    public ResponseEntity<?> create(@RequestBody Stock request) {
        if (request.quantity < 0) {
            return ResponseEntity.status(400).body("quantidade invalida");
        }

        if (database.get(request.product_id) == null) {
            database.put(request.product_id, new HashMap<>());
        }

        database.get(request.product_id).put(request.location_id, request);

        return ResponseEntity.status(201).body("criado com sucesso");
    }

    //atualizar
    @PutMapping("/{product_id}/{location_id}")
    public ResponseEntity<?> update(@PathVariable String product_id,
                                    @PathVariable String location_id,
                                    @RequestBody Stock request) {

        if (database.get(product_id) == null) {
            return ResponseEntity.status(404).body("nao encontrado");
        }

        if (database.get(product_id).get(location_id) == null) {
            return ResponseEntity.status(404).body("nao encontrado");
        }

        Stock stock = database.get(product_id).get(location_id);
        stock.quantity = request.quantity;
        stock.reserved = request.reserved;

        return ResponseEntity.ok("atualizado");
    }

    //deletar
    @DeleteMapping("/{product_id}/{location_id}")
    public ResponseEntity<?> delete(@PathVariable String product_id,
                                    @PathVariable String location_id) {

        if (database.get(product_id) == null || database.get(product_id).get(location_id) == null) {
            return ResponseEntity.status(404).body("nao encontrado");
        }

        database.get(product_id).remove(location_id);

        return ResponseEntity.ok("deletado");
    }
}

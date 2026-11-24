package com.Backend_vynta.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.Backend_vynta.dto.PedidoItemDTO;
import com.Backend_vynta.service.PedidoItemService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api")
public class PedidoItemController {

    private final PedidoItemService itemService;

    public PedidoItemController(PedidoItemService itemService) {
        this.itemService = itemService;
    }

    @GetMapping("/pedidos/{pedidoId}/items")
    public List<PedidoItemDTO> listarPorPedido(@PathVariable Long pedidoId) {
        return itemService.listarPorPedido(pedidoId);
    }

    @PostMapping("/pedidos/{pedidoId}/items")
    public ResponseEntity<PedidoItemDTO> agregar(@PathVariable Long pedidoId,@Valid @RequestBody PedidoItemDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(itemService.agregar(pedidoId, dto));
    }

    @DeleteMapping("/items/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        itemService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
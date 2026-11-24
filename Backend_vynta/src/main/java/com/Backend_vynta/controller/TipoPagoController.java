package com.Backend_vynta.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.Backend_vynta.dto.TipoPagoDTO;
import com.Backend_vynta.service.TipoPagoService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/tipos-pago")
public class TipoPagoController {

    private final TipoPagoService tipoPagoService;

    public TipoPagoController(TipoPagoService tipoPagoService) {
        this.tipoPagoService = tipoPagoService;
    }

    @GetMapping
    public List<TipoPagoDTO> listar() {
        return tipoPagoService.listar();
    }

    @GetMapping("/{id}")
    public TipoPagoDTO buscarPorId(@PathVariable Long id) {
        return tipoPagoService.buscarPorId(id);
    }

    @PostMapping
    public ResponseEntity<TipoPagoDTO> crear(@Valid @RequestBody TipoPagoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(tipoPagoService.crear(dto));
    }

    @PutMapping("/{id}")
    public TipoPagoDTO actualizar(@PathVariable Long id, @Valid @RequestBody TipoPagoDTO dto) {
        return tipoPagoService.actualizar(id, dto);
    }
}
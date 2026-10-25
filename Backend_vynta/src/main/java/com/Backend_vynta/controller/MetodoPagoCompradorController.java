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

import com.Backend_vynta.dto.MetodoPagoCompradorDTO;
import com.Backend_vynta.service.MetodoPagoCompradorService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/metodos-pago")
public class MetodoPagoCompradorController {

    private final MetodoPagoCompradorService metodoPagoService;

    public MetodoPagoCompradorController(MetodoPagoCompradorService metodoPagoService) {
        this.metodoPagoService = metodoPagoService;
    }

    @GetMapping("/comprador/{compradorId}")
    public List<MetodoPagoCompradorDTO> listarPorComprador(@PathVariable Long compradorId) {
        return metodoPagoService.listarPorComprador(compradorId);
    }

    @PostMapping
    public ResponseEntity<MetodoPagoCompradorDTO> crear(@Valid @RequestBody MetodoPagoCompradorDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(metodoPagoService.crear(dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        metodoPagoService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
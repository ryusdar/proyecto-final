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

import com.Backend_vynta.dto.VendedorDTO;
import com.Backend_vynta.service.VendedorService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/vendedores")
public class VendedorController {

    private final VendedorService vendedorService;

    public VendedorController(VendedorService vendedorService) {
        this.vendedorService = vendedorService;
    }

    @GetMapping
    public List<VendedorDTO> listar() {
        return vendedorService.listar();
    }

    @GetMapping("/{id}")
    public VendedorDTO buscarPorId(@PathVariable Long id) {
        return vendedorService.buscarPorId(id);
    }

    @PostMapping
    public ResponseEntity<VendedorDTO> crear(@Valid @RequestBody VendedorDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(vendedorService.crear(dto));
    }

    @PutMapping("/{id}")
    public VendedorDTO actualizar(@PathVariable Long id, @Valid @RequestBody VendedorDTO dto) {
        return vendedorService.actualizar(id, dto);
    }
}
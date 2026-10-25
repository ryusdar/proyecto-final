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

import com.Backend_vynta.dto.ProvinciaDTO;
import com.Backend_vynta.service.ProvinciaService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/provincias")
public class ProvinciaController {

    private final ProvinciaService provinciaService;

    public ProvinciaController(ProvinciaService provinciaService) {
        this.provinciaService = provinciaService;
    }

    @GetMapping
    public List<ProvinciaDTO> listar() {
        return provinciaService.listar();
    }

    @GetMapping("/{id}")
    public ProvinciaDTO buscarPorId(@PathVariable Long id) {
        return provinciaService.buscarPorId(id);
    }

    @GetMapping("/pais/{paisId}")
    public List<ProvinciaDTO> listarPorPais(@PathVariable Long paisId) {
        return provinciaService.listarPorPais(paisId);
    }

    @PostMapping
    public ResponseEntity<ProvinciaDTO> crear(@Valid @RequestBody ProvinciaDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(provinciaService.crear(dto));
    }

    @PutMapping("/{id}")
    public ProvinciaDTO actualizar(@PathVariable Long id, @Valid @RequestBody ProvinciaDTO dto) {
        return provinciaService.actualizar(id, dto);
    }
}
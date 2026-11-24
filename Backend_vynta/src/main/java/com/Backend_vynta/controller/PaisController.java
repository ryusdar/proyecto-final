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

import com.Backend_vynta.dto.PaisDTO;
import com.Backend_vynta.service.PaisService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/paises")
public class PaisController {

    private final PaisService paisService;

    public PaisController(PaisService paisService) {
        this.paisService = paisService;
    }

    @GetMapping
    public List<PaisDTO> listar() {
        return paisService.listar();
    }

    @GetMapping("/{id}")
    public PaisDTO buscarPorId(@PathVariable Long id) {
        return paisService.buscarPorId(id);
    }

    @PostMapping
    public ResponseEntity<PaisDTO> crear(@Valid @RequestBody PaisDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(paisService.crear(dto));
    }

    @PutMapping("/{id}")
    public PaisDTO actualizar(@PathVariable Long id, @Valid @RequestBody PaisDTO dto) {
        return paisService.actualizar(id, dto);
    }
}
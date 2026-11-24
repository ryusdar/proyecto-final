package com.Backend_vynta.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.Backend_vynta.dto.CompradorDTO;
import com.Backend_vynta.service.CompradorService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/compradores")
public class CompradorController {

    private final CompradorService compradorService;

    public CompradorController(CompradorService compradorService) {
        this.compradorService = compradorService;
    }

    @GetMapping
    public List<CompradorDTO> listar() {
        return compradorService.listar();
    }

    @GetMapping("/{id}")
    public CompradorDTO buscarPorId(@PathVariable Long id) {
        return compradorService.buscarPorId(id);
    }

    @GetMapping("/usuario/{usuarioId}")
    public CompradorDTO buscarPorUsuario(@PathVariable Long usuarioId) {
        return compradorService.buscarPorUsuario(usuarioId);
    }

    @PostMapping
    public ResponseEntity<CompradorDTO> crear(@Valid @RequestBody CompradorDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(compradorService.crear(dto));
    }

    @PatchMapping("/{id}/estado")
    public CompradorDTO cambiarEstado(@PathVariable Long id, @RequestParam boolean activo) {
        return compradorService.cambiarEstado(id, activo);
    }
}
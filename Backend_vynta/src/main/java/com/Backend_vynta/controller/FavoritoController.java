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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.Backend_vynta.dto.FavoritoDTO;
import com.Backend_vynta.service.FavoritoService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/favoritos")
public class FavoritoController {

    private final FavoritoService favoritoService;

    public FavoritoController(FavoritoService favoritoService) {
        this.favoritoService = favoritoService;
    }

    @GetMapping("/comprador/{compradorId}")
    public List<FavoritoDTO> listarPorComprador(@PathVariable Long compradorId) {
        return favoritoService.listarPorComprador(compradorId);
    }

    @GetMapping("/existe")
    public boolean esFavorito(@RequestParam Long compradorId, @RequestParam Long productoId) {
        return favoritoService.esFavorito(compradorId, productoId);
    }

    @PostMapping
    public ResponseEntity<FavoritoDTO> agregar(@Valid @RequestBody FavoritoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(favoritoService.agregar(dto));
    }

    @DeleteMapping
    public ResponseEntity<Void> quitar(@RequestParam Long compradorId, @RequestParam Long productoId) {
        favoritoService.quitar(compradorId, productoId);
        return ResponseEntity.noContent().build();
    }
}
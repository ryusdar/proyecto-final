package com.Backend_vynta.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.Backend_vynta.dto.UbicacionDTO;
import com.Backend_vynta.service.UbicacionService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/ubicaciones")
public class UbicacionController {

    private final UbicacionService ubicacionService;

    public UbicacionController(UbicacionService ubicacionService) {
        this.ubicacionService = ubicacionService;
    }

    @GetMapping("/usuario/{usuarioId}")
    public List<UbicacionDTO> listarPorUsuario(@PathVariable Long usuarioId) {
        return ubicacionService.listarPorUsuario(usuarioId);
    }

    @GetMapping("/{id}")
    public UbicacionDTO buscarPorId(@PathVariable Long id) {
        return ubicacionService.buscarPorId(id);
    }

    @PostMapping
    public ResponseEntity<UbicacionDTO> crear(@Valid @RequestBody UbicacionDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(ubicacionService.crear(dto));
    }

    @PutMapping("/{id}")
    public UbicacionDTO actualizar(@PathVariable Long id, @Valid @RequestBody UbicacionDTO dto) {
        return ubicacionService.actualizar(id, dto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        ubicacionService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
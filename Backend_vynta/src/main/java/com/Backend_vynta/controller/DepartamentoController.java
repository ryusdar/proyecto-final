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

import com.Backend_vynta.dto.DepartamentoDTO;
import com.Backend_vynta.service.DepartamentoService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/departamentos")
public class DepartamentoController {

    private final DepartamentoService departamentoService;

    public DepartamentoController(DepartamentoService departamentoService) {
        this.departamentoService = departamentoService;
    }

    @GetMapping
    public List<DepartamentoDTO> listar() {
        return departamentoService.listar();
    }

    @GetMapping("/{id}")
    public DepartamentoDTO buscarPorId(@PathVariable Long id) {
        return departamentoService.buscarPorId(id);
    }

    @GetMapping("/provincia/{provinciaId}")
    public List<DepartamentoDTO> listarPorProvincia(@PathVariable Long provinciaId) {
        return departamentoService.listarPorProvincia(provinciaId);
    }

    @PostMapping
    public ResponseEntity<DepartamentoDTO> crear(@Valid @RequestBody DepartamentoDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(departamentoService.crear(dto));
    }

    @PutMapping("/{id}")
    public DepartamentoDTO actualizar(@PathVariable Long id, @Valid @RequestBody DepartamentoDTO dto) {
        return departamentoService.actualizar(id, dto);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        departamentoService.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}
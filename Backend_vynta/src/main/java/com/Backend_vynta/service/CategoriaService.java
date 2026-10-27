package com.Backend_vynta.service;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.CategoriaDTO;
import com.Backend_vynta.model.Categoria;
import com.Backend_vynta.repository.CategoriaRepository;

import java.util.List;

@Service
public class CategoriaService {
    private final CategoriaRepository categoriaRepository;

    public CategoriaService(CategoriaRepository categoriaRepository) {
        this.categoriaRepository = categoriaRepository;
    }

    public List<CategoriaDTO> listar() {
        return categoriaRepository.findAll().stream().map(this::aDTO)
                .toList();
    }

    public CategoriaDTO crear(CategoriaDTO dto) {
        String nombre = dto.nombre().trim();
        if (categoriaRepository.existsByNombreIgnoreCase(nombre)) {
            throw new RuntimeException("La categoría ya existe");
        }
        Categoria categoria = new Categoria();
        categoria.setNombre(nombre);
        return aDTO(categoriaRepository.save(categoria));
    }

    // Conversión entidad -> DTO
    private CategoriaDTO aDTO(Categoria c) {
        return new CategoriaDTO(c.getId(), c.getNombre());
    }
}
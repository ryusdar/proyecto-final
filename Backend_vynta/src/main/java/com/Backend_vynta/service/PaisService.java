package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.PaisDTO;
import com.Backend_vynta.model.Pais;
import com.Backend_vynta.repository.PaisRepository;

@Service
public class PaisService {

    private final PaisRepository paisRepository;

    public PaisService(PaisRepository paisRepository) {
        this.paisRepository = paisRepository;
    }

    public List<PaisDTO> listar() {
        return paisRepository.findAll().stream()
                .map(this::aDTO)
                .toList();
    }

    public PaisDTO buscarPorId(Long id) {
        Pais p = paisRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("País no encontrado"));
        return aDTO(p);
    }

    public PaisDTO crear(PaisDTO dto) {
        if (paisRepository.existsByNombre(dto.nombre())) {
            throw new RuntimeException("El país ya existe");
        }

        Pais p = new Pais();
        p.setNombre(dto.nombre());
        p.setActivo(true);

        return aDTO(paisRepository.save(p));
    }

    public PaisDTO actualizar(Long id, PaisDTO dto) {
        Pais p = paisRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("País no encontrado"));

        p.setNombre(dto.nombre());
        if (dto.activo() != null) {
            p.setActivo(dto.activo());
        }

        return aDTO(paisRepository.save(p));
    }

    private PaisDTO aDTO(Pais p) {
        return new PaisDTO(p.getIdPais(), p.getNombre(), p.getActivo());
    }
}
package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.ProvinciaDTO;
import com.Backend_vynta.model.Pais;
import com.Backend_vynta.model.Provincia;
import com.Backend_vynta.repository.PaisRepository;
import com.Backend_vynta.repository.ProvinciaRepository;

@Service
public class ProvinciaService {

    private final ProvinciaRepository provinciaRepository;
    private final PaisRepository paisRepository;

    public ProvinciaService(ProvinciaRepository provinciaRepository,
                            PaisRepository paisRepository) {
        this.provinciaRepository = provinciaRepository;
        this.paisRepository = paisRepository;
    }

    public List<ProvinciaDTO> listar() {
        return provinciaRepository.findAll().stream()
                .map(this::aDTO)
                .toList();
    }

    public List<ProvinciaDTO> listarPorPais(Long paisId) {
        return provinciaRepository.findByPaisIdPais(paisId).stream()
                .map(this::aDTO)
                .toList();
    }

    public ProvinciaDTO buscarPorId(Long id) {
        return aDTO(buscarEntidad(id));
    }

    public ProvinciaDTO crear(ProvinciaDTO dto) {
        Pais pais = paisRepository.findById(dto.paisId())
                .orElseThrow(() -> new RuntimeException("País no encontrado"));

        Provincia p = new Provincia();
        p.setNombre(dto.nombre());
        p.setPais(pais);
        p.setActivo(true);

        return aDTO(provinciaRepository.save(p));
    }

    public ProvinciaDTO actualizar(Long id, ProvinciaDTO dto) {
        Provincia p = buscarEntidad(id);
        Pais pais = paisRepository.findById(dto.paisId())
                .orElseThrow(() -> new RuntimeException("País no encontrado"));

        p.setNombre(dto.nombre());
        p.setPais(pais);
        if (dto.activo() != null) {
            p.setActivo(dto.activo());
        }

        return aDTO(provinciaRepository.save(p));
    }

    private Provincia buscarEntidad(Long id) {
        return provinciaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Provincia no encontrada"));
    }

    private ProvinciaDTO aDTO(Provincia p) {
        return new ProvinciaDTO(
                p.getIdProvincia(),
                p.getNombre(),
                p.getPais().getIdPais(),
                p.getActivo()
        );
    }
}
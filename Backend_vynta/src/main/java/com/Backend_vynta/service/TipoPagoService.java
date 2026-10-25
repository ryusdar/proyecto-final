package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.TipoPagoDTO;
import com.Backend_vynta.model.TipoPago;
import com.Backend_vynta.repository.TipoPagoRepository;

@Service
public class TipoPagoService {

    private final TipoPagoRepository tipoPagoRepository;

    public TipoPagoService(TipoPagoRepository tipoPagoRepository) {
        this.tipoPagoRepository = tipoPagoRepository;
    }

    public List<TipoPagoDTO> listar() {
        return tipoPagoRepository.findAll().stream()
                .map(this::aDTO)
                .toList();
    }

    public TipoPagoDTO buscarPorId(Long id) {
        return aDTO(buscarEntidad(id));
    }

    public TipoPagoDTO crear(TipoPagoDTO dto) {
        if (tipoPagoRepository.existsByCodigo(dto.codigo())) {
            throw new RuntimeException("Ya existe un tipo de pago con ese código");
        }

        TipoPago t = new TipoPago();
        t.setCodigo(dto.codigo());
        t.setNombre(dto.nombre());
        t.setDescripcion(dto.descripcion());

        return aDTO(tipoPagoRepository.save(t));
    }

    public TipoPagoDTO actualizar(Long id, TipoPagoDTO dto) {
        TipoPago t = buscarEntidad(id);
        t.setCodigo(dto.codigo());
        t.setNombre(dto.nombre());
        t.setDescripcion(dto.descripcion());

        return aDTO(tipoPagoRepository.save(t));
    }

    private TipoPago buscarEntidad(Long id) {
        return tipoPagoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Tipo de pago no encontrado"));
    }

    private TipoPagoDTO aDTO(TipoPago t) {
        return new TipoPagoDTO(t.getId(), t.getCodigo(), t.getNombre(), t.getDescripcion());
    }
}
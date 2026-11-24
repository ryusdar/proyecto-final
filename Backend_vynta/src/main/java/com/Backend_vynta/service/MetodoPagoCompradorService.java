package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.MetodoPagoCompradorDTO;
import com.Backend_vynta.model.Comprador;
import com.Backend_vynta.model.MetodoPagoComprador;
import com.Backend_vynta.model.TipoPago;
import com.Backend_vynta.repository.CompradorRepository;
import com.Backend_vynta.repository.MetodoPagoCompradorRepository;
import com.Backend_vynta.repository.TipoPagoRepository;

@Service
public class MetodoPagoCompradorService {

    private final MetodoPagoCompradorRepository metodoPagoRepository;
    private final CompradorRepository compradorRepository;
    private final TipoPagoRepository tipoPagoRepository;

    public MetodoPagoCompradorService(MetodoPagoCompradorRepository metodoPagoRepository,
                                      CompradorRepository compradorRepository,
                                      TipoPagoRepository tipoPagoRepository) {
        this.metodoPagoRepository = metodoPagoRepository;
        this.compradorRepository = compradorRepository;
        this.tipoPagoRepository = tipoPagoRepository;
    }

    public List<MetodoPagoCompradorDTO> listarPorComprador(Long compradorId) {
        return metodoPagoRepository.findByCompradorIdComprador(compradorId).stream()
                .map(this::aDTO)
                .toList();
    }

    public MetodoPagoCompradorDTO crear(MetodoPagoCompradorDTO dto) {
        Comprador comprador = compradorRepository.findById(dto.compradorId())
                .orElseThrow(() -> new RuntimeException("Comprador no encontrado"));
        TipoPago tipoPago = tipoPagoRepository.findById(dto.tipoPagoId())
                .orElseThrow(() -> new RuntimeException("Tipo de pago no encontrado"));

        MetodoPagoComprador m = new MetodoPagoComprador();
        m.setComprador(comprador);
        m.setTipoPago(tipoPago);
        m.setMarca(dto.marca());
        m.setUltimos4(dto.ultimos4());
        m.setVencimientoMes(dto.vencimientoMes());
        m.setVencimientoAnio(dto.vencimientoAnio());
        m.setEsPrincipal(Boolean.TRUE.equals(dto.esPrincipal()));

        return aDTO(metodoPagoRepository.save(m));
    }

    public void eliminar(Long id) {
        if (!metodoPagoRepository.existsById(id)) {
            throw new RuntimeException("Método de pago no encontrado");
        }
        metodoPagoRepository.deleteById(id);
    }

    private MetodoPagoCompradorDTO aDTO(MetodoPagoComprador m) {
        return new MetodoPagoCompradorDTO(
                m.getId(),
                m.getComprador().getIdComprador(),
                m.getTipoPago().getId(),
                m.getMarca(),
                m.getUltimos4(),
                m.getVencimientoMes(),
                m.getVencimientoAnio(),
                m.getEsPrincipal(),
                m.getCreadoEn()
        );
    }
}
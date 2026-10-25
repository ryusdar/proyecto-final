package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.PedidoDTO;
import com.Backend_vynta.model.Comprador;
import com.Backend_vynta.model.EstadoPedido;
import com.Backend_vynta.model.MetodoPagoComprador;
import com.Backend_vynta.model.Pedido;
import com.Backend_vynta.model.TipoPago;
import com.Backend_vynta.repository.CompradorRepository;
import com.Backend_vynta.repository.MetodoPagoCompradorRepository;
import com.Backend_vynta.repository.PedidoRepository;
import com.Backend_vynta.repository.TipoPagoRepository;

@Service
public class PedidoService {

    private final PedidoRepository pedidoRepository;
    private final CompradorRepository compradorRepository;
    private final TipoPagoRepository tipoPagoRepository;
    private final MetodoPagoCompradorRepository metodoPagoRepository;

    public PedidoService(PedidoRepository pedidoRepository,
                         CompradorRepository compradorRepository,
                         TipoPagoRepository tipoPagoRepository,
                         MetodoPagoCompradorRepository metodoPagoRepository) {
        this.pedidoRepository = pedidoRepository;
        this.compradorRepository = compradorRepository;
        this.tipoPagoRepository = tipoPagoRepository;
        this.metodoPagoRepository = metodoPagoRepository;
    }

    public List<PedidoDTO> listarPorComprador(Long compradorId) {
        return pedidoRepository.findByCompradorIdComprador(compradorId).stream()
                .map(this::aDTO)
                .toList();
    }

    public PedidoDTO buscarPorId(Long id) {
        return aDTO(buscarEntidad(id));
    }

    public PedidoDTO crear(PedidoDTO dto) {
        Comprador comprador = compradorRepository.findById(dto.compradorId())
                .orElseThrow(() -> new RuntimeException("Comprador no encontrado"));
        TipoPago tipoPago = tipoPagoRepository.findById(dto.tipoPagoId())
                .orElseThrow(() -> new RuntimeException("Tipo de pago no encontrado"));

        Pedido p = new Pedido();
        p.setComprador(comprador);
        p.setTipoPago(tipoPago);
        p.setTotal(dto.total());
        p.setEstado(EstadoPedido.PENDIENTE);

        // opcional: solo si se paga con una tarjeta guardada
        if (dto.metodoPagoCompradorId() != null) {
            MetodoPagoComprador metodo = metodoPagoRepository.findById(dto.metodoPagoCompradorId())
                    .orElseThrow(() -> new RuntimeException("Método de pago no encontrado"));
            p.setMetodoPagoComprador(metodo);
        }

        return aDTO(pedidoRepository.save(p));
    }

    public PedidoDTO cambiarEstado(Long id, EstadoPedido estado) {
        Pedido p = buscarEntidad(id);
        p.setEstado(estado);
        return aDTO(pedidoRepository.save(p));
    }

    private Pedido buscarEntidad(Long id) {
        return pedidoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));
    }

    private PedidoDTO aDTO(Pedido p) {
        Long metodoId = p.getMetodoPagoComprador() != null
                ? p.getMetodoPagoComprador().getId()
                : null;

        return new PedidoDTO(
                p.getId(),
                p.getComprador().getIdComprador(),
                p.getTipoPago().getId(),
                metodoId,
                p.getTotal(),
                p.getEstado(),
                p.getCreadoEn()
        );
    }
}
package com.Backend_vynta.dto;

import com.Backend_vynta.model.EstadoPedido;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PedidoDTO {

    private Long id;
    private Long compradorId;
    private Long tipoPagoId;
    private Long metodoPagoCompradorId;
    private BigDecimal total;
    private EstadoPedido estado;
    private LocalDateTime creadoEn;

    public PedidoDTO() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCompradorId() {
        return compradorId;
    }

    public void setCompradorId(Long compradorId) {
        this.compradorId = compradorId;
    }

    public Long getTipoPagoId() {
        return tipoPagoId;
    }

    public void setTipoPagoId(Long tipoPagoId) {
        this.tipoPagoId = tipoPagoId;
    }

    public Long getMetodoPagoCompradorId() {
        return metodoPagoCompradorId;
    }

    public void setMetodoPagoCompradorId(Long metodoPagoCompradorId) {
        this.metodoPagoCompradorId = metodoPagoCompradorId;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public EstadoPedido getEstado() {
        return estado;
    }

    public void setEstado(EstadoPedido estado) {
        this.estado = estado;
    }

    public LocalDateTime getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(LocalDateTime creadoEn) {
        this.creadoEn = creadoEn;
    }
}
package com.Backend_vynta.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.Backend_vynta.model.EstadoPedido;

import jakarta.validation.constraints.NotNull;

public record PedidoDTO(
        Long id,

        @NotNull(message = "El comprador es obligatorio")
        Long compradorId,

        @NotNull(message = "El tipo de pago es obligatorio")
        Long tipoPagoId,

        Long metodoPagoCompradorId,

        BigDecimal total,

        EstadoPedido estado,

        LocalDateTime creadoEn
) {}
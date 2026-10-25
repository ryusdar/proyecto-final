package com.Backend_vynta.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.Backend_vynta.model.EstadoPedido;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record PedidoDTO(
        Long id,

        @NotNull(message = "El comprador es obligatorio")
        Long compradorId,

        @NotNull(message = "El tipo de pago es obligatorio")
        Long tipoPagoId,

        Long metodoPagoCompradorId,

        @NotNull(message = "El total es obligatorio")
        @Positive(message = "El total debe ser mayor a 0")
        BigDecimal total,

        EstadoPedido estado,

        LocalDateTime creadoEn
) {}
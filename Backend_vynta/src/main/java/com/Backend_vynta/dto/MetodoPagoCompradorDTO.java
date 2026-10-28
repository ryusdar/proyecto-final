package com.Backend_vynta.dto;

import java.time.LocalDateTime;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public record MetodoPagoCompradorDTO(
        Long id,

        @NotNull(message = "El comprador es obligatorio")
        Long compradorId,

        @NotNull(message = "El tipo de pago es obligatorio")
        Long tipoPagoId,

        @NotBlank(message = "La marca es obligatoria")
        String marca,

        @NotBlank(message = "Los últimos 4 dígitos son obligatorios")
        @Pattern(regexp = "\\d{4}", message = "Deben ser exactamente 4 dígitos")
        String ultimos4,

        @NotNull(message = "El mes de vencimiento es obligatorio")
        @Min(value = 1, message = "Mes inválido")
        @Max(value = 12, message = "Mes inválido")
        Integer vencimientoMes,

        @NotNull(message = "El año de vencimiento es obligatorio")
        @Min(value = 2026, message = "Año inválido")
        Integer vencimientoAnio,

        Boolean esPrincipal,

        LocalDateTime creadoEn
) {}
package com.Backend_vynta.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.Backend_vynta.model.EstadoProducto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record ProductoDTO(
        Long id,

        @NotNull(message = "El vendedor es obligatorio")
        Long vendedorId,

        @NotNull(message = "La categoría es obligatoria")
        Long categoriaId,

        @NotBlank(message = "El nombre es obligatorio")
        @Size(max = 150, message = "El nombre no puede superar los 150 caracteres")
        String nombre,

        String descripcion,

        @NotNull(message = "El precio es obligatorio")
        @Positive(message = "El precio debe ser mayor a 0")
        BigDecimal precio,

        @NotNull(message = "El stock es obligatorio")
        @PositiveOrZero(message = "El stock no puede ser negativo")
        Integer stock,

        String imagenUrl,

        EstadoProducto estado,

        LocalDateTime creadoEn
) {}
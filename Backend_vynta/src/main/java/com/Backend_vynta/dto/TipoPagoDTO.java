package com.Backend_vynta.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record TipoPagoDTO(
        Long id,

        @NotBlank(message = "El código es obligatorio")
        @Size(max = 30, message = "El código no puede superar los 30 caracteres")
        String codigo,

        @NotBlank(message = "El nombre es obligatorio")
        String nombre,

        String descripcion
) {}
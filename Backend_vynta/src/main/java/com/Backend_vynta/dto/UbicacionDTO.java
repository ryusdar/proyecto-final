package com.Backend_vynta.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UbicacionDTO(
        Long idUbicacion,

        @NotNull(message = "El usuario es obligatorio")
        Long usuarioId,

        @NotBlank(message = "La calle es obligatoria")
        String calle,

        @NotBlank(message = "El número es obligatorio")
        String numero,

        String codigoPostal,

        @NotNull(message = "El departamento es obligatorio")
        Long departamentoId,

        Boolean activo
) {}
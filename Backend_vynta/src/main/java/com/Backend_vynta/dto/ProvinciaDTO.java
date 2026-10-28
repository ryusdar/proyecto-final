package com.Backend_vynta.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record ProvinciaDTO(
        Long idProvincia,

        @NotBlank(message = "El nombre es obligatorio")
        String nombre,

        @NotNull(message = "El país es obligatorio")
        Long paisId,

        Boolean activo
) {}
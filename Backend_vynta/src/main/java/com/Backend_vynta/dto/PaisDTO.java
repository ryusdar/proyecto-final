package com.Backend_vynta.dto;

import jakarta.validation.constraints.NotBlank;

public record PaisDTO(
        Long idPais,

        @NotBlank(message = "El nombre es obligatorio")
        String nombre,

        Boolean activo
) {}
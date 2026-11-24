package com.Backend_vynta.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CategoriaDTO(
        Long id,

        @NotBlank(message = "El nombre es obligatorio")
        @Size(max = 50, message = "Máximo 50 caracteres")
        String nombre
) {}
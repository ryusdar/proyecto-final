package com.Backend_vynta.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record DepartamentoDTO(
        Long idDepartamento,

        @NotBlank(message = "El nombre es obligatorio")
        String nombre,

        @NotNull(message = "La provincia es obligatoria")
        Long provinciaId,

        Boolean activo
) {}
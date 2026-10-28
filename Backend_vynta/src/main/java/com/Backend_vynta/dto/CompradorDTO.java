package com.Backend_vynta.dto;

import jakarta.validation.constraints.NotNull;

public record CompradorDTO(
        Long idComprador,

        @NotNull(message = "El usuario es obligatorio")
        Long usuarioId,

        Boolean activo
) {}
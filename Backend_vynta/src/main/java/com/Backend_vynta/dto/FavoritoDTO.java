package com.Backend_vynta.dto;

import java.time.LocalDateTime;

import jakarta.validation.constraints.NotNull;

public record FavoritoDTO(
        @NotNull(message = "El comprador es obligatorio")
        Long compradorId,

        @NotNull(message = "El producto es obligatorio")
        Long productoId,

        LocalDateTime creadoEn
) {}
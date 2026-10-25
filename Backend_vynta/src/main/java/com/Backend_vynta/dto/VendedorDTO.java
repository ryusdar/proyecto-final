package com.Backend_vynta.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record VendedorDTO(
        Long idVendedor,

        @NotNull(message = "El usuario es obligatorio")
        Long usuarioId,

        @NotBlank(message = "El nombre de la tienda es obligatorio")
        @Size(max = 100, message = "El nombre de la tienda no puede superar los 100 caracteres")
        String nombreTienda,

        String descripcion,

        Boolean activo
) {}
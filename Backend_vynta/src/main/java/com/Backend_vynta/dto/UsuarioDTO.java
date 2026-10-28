package com.Backend_vynta.dto;

import java.time.LocalDateTime;

public record UsuarioDTO(
        Long id,
        String nombre,
        String email,
        String fotoUrl,
        LocalDateTime creadoEn
) {}

package com.Backend_vynta.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record UsuarioLoginDTO(
        @NotBlank(message = "El email es obligatorio")
        @Email(message = "El email no es válido")
        String email,
        
        @NotBlank(message = "La contraseña es obligatoria")
        String password
        ) {

}

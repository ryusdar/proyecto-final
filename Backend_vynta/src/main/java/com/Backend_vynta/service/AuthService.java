package com.Backend_vynta.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.AuthResponseDTO;
import com.Backend_vynta.dto.UsuarioLoginDTO;
import com.Backend_vynta.dto.UsuarioRegistroDTO;
import com.Backend_vynta.model.Usuario;
import com.Backend_vynta.repository.UsuarioRepository;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UsuarioRepository usuarioRepository, PasswordEncoder passwordEncoder) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public AuthResponseDTO registrar(UsuarioRegistroDTO dto) {
        if (usuarioRepository.existsByEmail(dto.email())) {
            throw new RuntimeException("El email ya está registrado");
        }

        Usuario u = new Usuario();
        u.setNombre(dto.nombre());
        u.setEmail(dto.email());
        u.setPasswordHash(passwordEncoder.encode(dto.password())); // se guarda encriptada
        u.setFotoUrl(dto.fotoUrl());

        Usuario guardado = usuarioRepository.save(u);
        return new AuthResponseDTO(guardado.getId(), guardado.getNombre(), guardado.getEmail());
    }

    public AuthResponseDTO login(UsuarioLoginDTO dto) {
        Usuario u = usuarioRepository.findByEmail(dto.email())
                .orElseThrow(() -> new RuntimeException("Credenciales inválidas"));

        if (!passwordEncoder.matches(dto.password(), u.getPasswordHash())) {
            throw new RuntimeException("Credenciales inválidas");
        }

        return new AuthResponseDTO(u.getId(), u.getNombre(), u.getEmail());
    }
}
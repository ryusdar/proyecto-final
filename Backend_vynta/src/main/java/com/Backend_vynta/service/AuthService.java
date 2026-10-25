package com.Backend_vynta.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.Backend_vynta.dto.AuthResponseDTO;
import com.Backend_vynta.dto.UsuarioLoginDTO;
import com.Backend_vynta.dto.UsuarioRegistroDTO;
import com.Backend_vynta.model.Comprador;
import com.Backend_vynta.model.Usuario;
import com.Backend_vynta.repository.CompradorRepository;
import com.Backend_vynta.repository.UsuarioRepository;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final CompradorRepository compradorRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthService(UsuarioRepository usuarioRepository,
                       CompradorRepository compradorRepository,
                       PasswordEncoder passwordEncoder) {
        this.usuarioRepository = usuarioRepository;
        this.compradorRepository = compradorRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public AuthResponseDTO registrar(UsuarioRegistroDTO dto) {
        if (usuarioRepository.existsByEmail(dto.email())) {
            throw new RuntimeException("El email ya está registrado");
        }

        Usuario u = new Usuario();
        u.setNombre(dto.nombre());
        u.setEmail(dto.email());
        u.setPasswordHash(passwordEncoder.encode(dto.password()));
        u.setFotoUrl(dto.fotoUrl());
        Usuario guardado = usuarioRepository.save(u);

        // todo usuario nuevo es también comprador
        Comprador c = new Comprador();
        c.setUsuario(guardado);
        c.setActivo(true);
        compradorRepository.save(c);

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
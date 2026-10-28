package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.UsuarioDTO;
import com.Backend_vynta.model.Usuario;
import com.Backend_vynta.repository.UsuarioRepository;

@Service
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;

    public UsuarioService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    public List<UsuarioDTO> listar() {
        return usuarioRepository.findAll().stream()
                .map(this::aDTO)
                .toList();
    }

    public UsuarioDTO buscarPorId(Long id) {
        return aDTO(buscarEntidad(id));
    }

    // edita solo nombre y foto (el email y la contraseña no se tocan acá)
    public UsuarioDTO actualizar(Long id, UsuarioDTO dto) {
        Usuario u = buscarEntidad(id);
        u.setNombre(dto.nombre());
        u.setFotoUrl(dto.fotoUrl());
        return aDTO(usuarioRepository.save(u));
    }

    private Usuario buscarEntidad(Long id) {
        return usuarioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
    }

    private UsuarioDTO aDTO(Usuario u) {
        return new UsuarioDTO(
                u.getId(),
                u.getNombre(),
                u.getEmail(),
                u.getFotoUrl(),
                u.getCreadoEn()
        );
    }
}
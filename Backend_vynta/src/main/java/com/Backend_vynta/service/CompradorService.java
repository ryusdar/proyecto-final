package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.CompradorDTO;
import com.Backend_vynta.model.Comprador;
import com.Backend_vynta.model.Usuario;
import com.Backend_vynta.repository.CompradorRepository;
import com.Backend_vynta.repository.UsuarioRepository;

@Service
public class CompradorService {

    private final CompradorRepository compradorRepository;
    private final UsuarioRepository usuarioRepository;

    public CompradorService(CompradorRepository compradorRepository,
            UsuarioRepository usuarioRepository) {
        this.compradorRepository = compradorRepository;
        this.usuarioRepository = usuarioRepository;
    }

    public List<CompradorDTO> listar() {
        return compradorRepository.findAll().stream().map(this::aDTO).toList();
    }

    public CompradorDTO buscarPorId(Long id) {
        Comprador c = compradorRepository.findById(id).orElseThrow(() -> new RuntimeException("Comprador no encontrado"));

        return aDTO(c);
    }

    public CompradorDTO buscarPorUsuario(Long usuarioId) {
        Comprador c = compradorRepository.findByUsuarioId(usuarioId).orElseThrow(() -> new RuntimeException("El usuario no es comprador"));
        return aDTO(c);
    }

    // convierte un usuario en comprador
    public CompradorDTO crear(CompradorDTO dto) {
        if (compradorRepository.existsByUsuarioId(dto.usuarioId())) {
            throw new RuntimeException("El usuario ya es comprador");
        }

        Usuario usuario = usuarioRepository.findById(dto.usuarioId()).orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Comprador comprador = new Comprador();
        comprador.setUsuario(usuario);
        comprador.setActivo(true);

        return aDTO(compradorRepository.save(comprador));
    }

    // activar / desactivar
    public CompradorDTO cambiarEstado(Long id, boolean activo) {
        Comprador c = compradorRepository.findById(id).orElseThrow(() -> new RuntimeException("Comprador no encontrado"));
        c.setActivo(activo);
        return aDTO(compradorRepository.save(c));
    }

    private CompradorDTO aDTO(Comprador c) {
        return new CompradorDTO(c.getIdComprador(), c.getUsuario().getId(), c.getActivo());
    }
}

package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.UbicacionDTO;
import com.Backend_vynta.model.Departamento;
import com.Backend_vynta.model.Ubicacion;
import com.Backend_vynta.model.Usuario;
import com.Backend_vynta.repository.DepartamentoRepository;
import com.Backend_vynta.repository.UbicacionRepository;
import com.Backend_vynta.repository.UsuarioRepository;

@Service
public class UbicacionService {

    private final UbicacionRepository ubicacionRepository;
    private final UsuarioRepository usuarioRepository;
    private final DepartamentoRepository departamentoRepository;

    public UbicacionService(UbicacionRepository ubicacionRepository,
                            UsuarioRepository usuarioRepository,
                            DepartamentoRepository departamentoRepository) {
        this.ubicacionRepository = ubicacionRepository;
        this.usuarioRepository = usuarioRepository;
        this.departamentoRepository = departamentoRepository;
    }

    public List<UbicacionDTO> listarPorUsuario(Long usuarioId) {
        return ubicacionRepository.findByUsuarioId(usuarioId).stream()
                .filter(u -> Boolean.TRUE.equals(u.getActivo()))
                .map(this::aDTO)
                .toList();
    }

    public UbicacionDTO buscarPorId(Long id) {
        return aDTO(buscarEntidad(id));
    }

    public UbicacionDTO crear(UbicacionDTO dto) {
        Usuario usuario = usuarioRepository.findById(dto.usuarioId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));
        Departamento departamento = departamentoRepository.findById(dto.departamentoId())
                .orElseThrow(() -> new RuntimeException("Departamento no encontrado"));

        Ubicacion u = new Ubicacion();
        u.setUsuario(usuario);
        u.setDepartamento(departamento);
        copiarCampos(u, dto);
        u.setActivo(true);

        return aDTO(ubicacionRepository.save(u));
    }

    public UbicacionDTO actualizar(Long id, UbicacionDTO dto) {
        Ubicacion u = buscarEntidad(id);
        Departamento departamento = departamentoRepository.findById(dto.departamentoId())
                .orElseThrow(() -> new RuntimeException("Departamento no encontrado"));

        u.setDepartamento(departamento);
        copiarCampos(u, dto);
        if (dto.activo() != null) {
            u.setActivo(dto.activo());
        }

        return aDTO(ubicacionRepository.save(u));
    }

    // borrado lógico
    public void eliminar(Long id) {
        Ubicacion u = buscarEntidad(id);
        u.setActivo(false);
        ubicacionRepository.save(u);
    }

    private void copiarCampos(Ubicacion u, UbicacionDTO dto) {
        u.setCalle(dto.calle());
        u.setNumero(dto.numero());
        u.setCodigoPostal(dto.codigoPostal());
    }

    private Ubicacion buscarEntidad(Long id) {
        return ubicacionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ubicación no encontrada"));
    }

    private UbicacionDTO aDTO(Ubicacion u) {
        return new UbicacionDTO(
                u.getIdUbicacion(),
                u.getUsuario().getId(),
                u.getCalle(),
                u.getNumero(),
                u.getCodigoPostal(),
                u.getDepartamento().getIdDepartamento(),
                u.getActivo()
        );
    }
}
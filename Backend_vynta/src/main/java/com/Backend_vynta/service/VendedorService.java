package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.VendedorDTO;
import com.Backend_vynta.model.Usuario;
import com.Backend_vynta.model.Vendedor;
import com.Backend_vynta.repository.UsuarioRepository;
import com.Backend_vynta.repository.VendedorRepository;

@Service
public class VendedorService {

    private final VendedorRepository vendedorRepository;
    private final UsuarioRepository usuarioRepository;

    public VendedorService(VendedorRepository vendedorRepository,
                           UsuarioRepository usuarioRepository) {
        this.vendedorRepository = vendedorRepository;
        this.usuarioRepository = usuarioRepository;
    }

    public List<VendedorDTO> listar() {
        return vendedorRepository.findAll().stream()
                .map(this::aDTO)
                .toList();
    }

    public VendedorDTO buscarPorId(Long id) {
        return aDTO(buscarEntidad(id));
    }

    // convierte un usuario en vendedor
    public VendedorDTO crear(VendedorDTO dto) {
        if (vendedorRepository.existsById(dto.usuarioId())) {
            throw new RuntimeException("El usuario ya es vendedor");
        }

        Usuario usuario = usuarioRepository.findById(dto.usuarioId())
                .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        Vendedor v = new Vendedor();
        v.setUsuario(usuario);          // NO usar setIdVendedor: lo copia @MapsId
        v.setNombreTienda(dto.nombreTienda());
        v.setDescripcion(dto.descripcion());
        v.setActivo(true);

        return aDTO(vendedorRepository.save(v));
    }

    public VendedorDTO actualizar(Long id, VendedorDTO dto) {
        Vendedor v = buscarEntidad(id);
        v.setNombreTienda(dto.nombreTienda());
        v.setDescripcion(dto.descripcion());
        if (dto.activo() != null) {
            v.setActivo(dto.activo());
        }
        return aDTO(vendedorRepository.save(v));
    }

    private Vendedor buscarEntidad(Long id) {
        return vendedorRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Vendedor no encontrado"));
    }

    private VendedorDTO aDTO(Vendedor v) {
        return new VendedorDTO(
                v.getIdVendedor(),
                v.getUsuario().getId(),
                v.getNombreTienda(),
                v.getDescripcion(),
                v.getActivo()
        );
    }
}
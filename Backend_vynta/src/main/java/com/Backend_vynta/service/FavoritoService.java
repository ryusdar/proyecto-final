package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.FavoritoDTO;
import com.Backend_vynta.model.Comprador;
import com.Backend_vynta.model.Favorito;
import com.Backend_vynta.model.FavoritoId;
import com.Backend_vynta.model.Producto;
import com.Backend_vynta.repository.CompradorRepository;
import com.Backend_vynta.repository.FavoritoRepository;
import com.Backend_vynta.repository.ProductoRepository;

@Service
public class FavoritoService {

    private final FavoritoRepository favoritoRepository;
    private final CompradorRepository compradorRepository;
    private final ProductoRepository productoRepository;

    public FavoritoService(FavoritoRepository favoritoRepository,CompradorRepository compradorRepository,ProductoRepository productoRepository) {
        this.favoritoRepository = favoritoRepository;
        this.compradorRepository = compradorRepository;
        this.productoRepository = productoRepository;
    }

    public List<FavoritoDTO> listarPorComprador(Long compradorId) {
        return favoritoRepository.findByIdCompradorId(compradorId).stream()
                .map(this::aDTO)
                .toList();
    }

    public boolean esFavorito(Long compradorId, Long productoId) {
        return favoritoRepository.existsById(new FavoritoId(compradorId, productoId));
    }

    public FavoritoDTO agregar(FavoritoDTO dto) {
        FavoritoId id = new FavoritoId(dto.compradorId(), dto.productoId());

        if (favoritoRepository.existsById(id)) {
            throw new RuntimeException("El producto ya está en favoritos");
        }

        Comprador comprador = compradorRepository.findById(dto.compradorId())
                .orElseThrow(() -> new RuntimeException("Comprador no encontrado"));
        Producto producto = productoRepository.findById(dto.productoId())
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

        Favorito f = new Favorito();
        f.setId(id);
        f.setComprador(comprador);
        f.setProducto(producto);

        return aDTO(favoritoRepository.save(f));
    }

    public void quitar(Long compradorId, Long productoId) {
        FavoritoId id = new FavoritoId(compradorId, productoId);

        if (!favoritoRepository.existsById(id)) {
            throw new RuntimeException("El favorito no existe");
        }
        favoritoRepository.deleteById(id);
    }

    private FavoritoDTO aDTO(Favorito f) {
        return new FavoritoDTO(
                f.getId().getCompradorId(),
                f.getId().getProductoId(),
                f.getCreadoEn()
        );
    }
}
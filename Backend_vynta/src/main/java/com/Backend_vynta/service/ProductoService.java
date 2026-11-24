package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.ProductoDTO;
import com.Backend_vynta.model.Categoria;
import com.Backend_vynta.model.EstadoProducto;
import com.Backend_vynta.model.Producto;
import com.Backend_vynta.model.Vendedor;
import com.Backend_vynta.repository.CategoriaRepository;
import com.Backend_vynta.repository.ProductoRepository;
import com.Backend_vynta.repository.VendedorRepository;

@Service
public class ProductoService {

    private final ProductoRepository productoRepository;
    private final VendedorRepository vendedorRepository;
    private final CategoriaRepository categoriaRepository;

    public ProductoService(ProductoRepository productoRepository,
                           VendedorRepository vendedorRepository,
                           CategoriaRepository categoriaRepository) {
        this.productoRepository = productoRepository;
        this.vendedorRepository = vendedorRepository;
        this.categoriaRepository = categoriaRepository;
    }

    // listados públicos: solo productos activos
    public List<ProductoDTO> listar() {
        return productoRepository.findByEstado(EstadoProducto.activo).stream()
                .map(this::aDTO).toList();
    }

    public List<ProductoDTO> listarPorCategoria(Long categoriaId) {
        return productoRepository.findByCategoriaIdAndEstado(categoriaId, EstadoProducto.activo).stream()
                .map(this::aDTO).toList();
    }

    public List<ProductoDTO> buscarPorNombre(String nombre) {
        return productoRepository.findByNombreContainingIgnoreCaseAndEstado(nombre, EstadoProducto.activo).stream()
                .map(this::aDTO).toList();
    }

    // el vendedor ve todas sus publicaciones (activas y pausadas)
    public List<ProductoDTO> listarPorVendedor(Long vendedorId) {
        return productoRepository.findByVendedorIdVendedor(vendedorId).stream()
                .filter(p -> p.getEstado() != EstadoProducto.eliminado)
                .map(this::aDTO).toList();
    }

    // devuelve el producto aunque esté pausado o eliminado (sirve para el historial de pedidos)
    public ProductoDTO buscarPorId(Long id) {
        return aDTO(buscarEntidad(id));
    }

    public ProductoDTO crear(ProductoDTO dto) {
        Vendedor vendedor = vendedorRepository.findById(dto.vendedorId())
                .orElseThrow(() -> new RuntimeException("Vendedor no encontrado"));
        Categoria categoria = categoriaRepository.findById(dto.categoriaId())
                .orElseThrow(() -> new RuntimeException("Categoría no encontrada"));

        Producto p = new Producto();
        p.setVendedor(vendedor);
        p.setCategoria(categoria);
        copiarCampos(p, dto);
        p.setEstado(EstadoProducto.activo);

        return aDTO(productoRepository.save(p));
    }

    public ProductoDTO actualizar(Long id, ProductoDTO dto) {
        Producto p = buscarEntidad(id);
        Categoria categoria = categoriaRepository.findById(dto.categoriaId())
                .orElseThrow(() -> new RuntimeException("Categoría no encontrada"));

        p.setCategoria(categoria);
        copiarCampos(p, dto);
        if (dto.estado() != null) {
            p.setEstado(dto.estado());   // activo / pausado / eliminado
        }

        return aDTO(productoRepository.save(p));
    }

    // borrado lógico: no se borra la fila, solo cambia el estado
    public void eliminar(Long id) {
        Producto p = buscarEntidad(id);
        p.setEstado(EstadoProducto.eliminado);
        productoRepository.save(p);
    }

    private void copiarCampos(Producto p, ProductoDTO dto) {
        p.setNombre(dto.nombre());
        p.setDescripcion(dto.descripcion());
        p.setPrecio(dto.precio());
        p.setStock(dto.stock());
        p.setImagenUrl(dto.imagenUrl());
    }

    private Producto buscarEntidad(Long id) {
        return productoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));
    }

    private ProductoDTO aDTO(Producto p) {
        return new ProductoDTO(
                p.getId(),
                p.getVendedor().getIdVendedor(),
                p.getCategoria().getId(),
                p.getNombre(),
                p.getDescripcion(),
                p.getPrecio(),
                p.getStock(),
                p.getImagenUrl(),
                p.getEstado(),
                p.getCreadoEn()
        );
    }
}
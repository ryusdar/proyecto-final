package com.Backend_vynta.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.EstadoProducto;
import com.Backend_vynta.model.Producto;

public interface ProductoRepository extends JpaRepository<Producto, Long> {

    List<Producto> findByEstado(EstadoProducto estado);

    List<Producto> findByCategoriaIdAndEstado(Long categoriaId, EstadoProducto estado);

    List<Producto> findByNombreContainingIgnoreCaseAndEstado(String nombre, EstadoProducto estado);

    List<Producto> findByVendedorIdVendedor(Long idVendedor);
}
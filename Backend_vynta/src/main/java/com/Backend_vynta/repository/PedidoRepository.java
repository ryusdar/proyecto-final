package com.Backend_vynta.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Pedido;

public interface PedidoRepository extends JpaRepository<Pedido, Long> {

    // todos los pedidos de un comprador
    List<Pedido> findByCompradorIdComprador(Long idComprador);
}
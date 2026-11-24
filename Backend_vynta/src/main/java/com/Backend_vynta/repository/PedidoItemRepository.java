package com.Backend_vynta.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.PedidoItem;

public interface PedidoItemRepository extends JpaRepository<PedidoItem, Long> {

    // todos los items de un pedido
    List<PedidoItem> findByPedidoId(Long pedidoId);
}
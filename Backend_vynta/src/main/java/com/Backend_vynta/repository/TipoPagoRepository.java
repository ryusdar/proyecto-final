package com.Backend_vynta.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.TipoPago;

public interface TipoPagoRepository extends JpaRepository<TipoPago, Long> {

    Optional<TipoPago> findByCodigo(String codigo);

    boolean existsByCodigo(String codigo);
}
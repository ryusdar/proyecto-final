package com.Backend_vynta.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Comprador;

public interface CompradorRepository extends JpaRepository<Comprador, Long> {

    // ¿ya existe un comprador para este usuario?
    boolean existsByUsuarioId(Long usuarioId);

    // buscar el comprador de un usuario
    Optional<Comprador> findByUsuarioId(Long usuarioId);
}
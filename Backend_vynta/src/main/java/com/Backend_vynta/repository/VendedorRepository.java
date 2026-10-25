package com.Backend_vynta.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Vendedor;

public interface VendedorRepository extends JpaRepository<Vendedor, Long> {

    // ¿este usuario ya es vendedor?
    boolean existsByUsuarioId(Long usuarioId);

    // buscar el perfil de vendedor de un usuario
    Optional<Vendedor> findByUsuarioId(Long usuarioId);
}
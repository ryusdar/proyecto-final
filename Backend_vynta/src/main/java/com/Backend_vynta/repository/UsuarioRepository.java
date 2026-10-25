package com.Backend_vynta.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Usuario;

public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    // para el login: buscar al usuario por su email
    Optional<Usuario> findByEmail(String email);

    // para el registro: evitar emails repetidos
    boolean existsByEmail(String email);
}
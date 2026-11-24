package com.Backend_vynta.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Pais;

public interface PaisRepository extends JpaRepository<Pais, Long> {

    boolean existsByNombre(String nombre);
}
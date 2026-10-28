package com.Backend_vynta.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Vendedor;

public interface VendedorRepository extends JpaRepository<Vendedor, Long> {
}
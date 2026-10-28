package com.Backend_vynta.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Provincia;

public interface ProvinciaRepository extends JpaRepository<Provincia, Long> {

    List<Provincia> findByPaisIdPais(Long idPais);
}
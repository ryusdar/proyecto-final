package com.Backend_vynta.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Departamento;

public interface DepartamentoRepository extends JpaRepository<Departamento, Long> {

    List<Departamento> findByProvinciaIdProvincia(Long idProvincia);
}
package com.Backend_vynta.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.MetodoPagoComprador;

public interface MetodoPagoCompradorRepository extends JpaRepository<MetodoPagoComprador, Long> {

    List<MetodoPagoComprador> findByCompradorIdComprador(Long idComprador);
}
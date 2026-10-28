package com.Backend_vynta.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Ubicacion;

public interface UbicacionRepository extends JpaRepository<Ubicacion, Long> {

    // direcciones de un usuario
    List<Ubicacion> findByUsuarioId(Long usuarioId);
}
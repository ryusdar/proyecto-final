package com.Backend_vynta.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Backend_vynta.model.Favorito;
import com.Backend_vynta.model.FavoritoId;

public interface FavoritoRepository extends JpaRepository<Favorito, FavoritoId> {

    // todos los favoritos de un comprador (busca dentro de la clave compuesta)
    List<Favorito> findByIdCompradorId(Long compradorId);
}
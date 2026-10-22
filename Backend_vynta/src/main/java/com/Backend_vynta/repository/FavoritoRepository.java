package com.Backend_vynta.repository;

import com.Backend_vynta.model.Favorito;
import com.Backend_vynta.model.FavoritoId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FavoritoRepository extends JpaRepository<Favorito, FavoritoId> {
}

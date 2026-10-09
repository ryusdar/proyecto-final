package com.Backend_vynta.repository;

import com.Backend_vynta.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoriaRepository  extends JpaRepository<Categoria, Long> {
}

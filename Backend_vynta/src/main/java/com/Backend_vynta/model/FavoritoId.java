package com.Backend_vynta.model;

import jakarta.persistence.Embeddable;
import java.io.Serializable;

@Embeddable
public class FavoritoId implements Serializable {

    private Long compradorId;

    private Long productoId;

    public FavoritoId() {
    }

    public FavoritoId(Long compradorId, Long productoId) {
        this.compradorId = compradorId;
        this.productoId = productoId;
    }

    public Long getCompradorId() {
        return compradorId;
    }

    public void setCompradorId(Long compradorId) {
        this.compradorId = compradorId;
    }

    public Long getProductoId() {
        return productoId;
    }

    public void setProductoId(Long productoId) {
        this.productoId = productoId;
    }

    @Override
    public boolean equals(Object o) {

        if (this == o) {
            return true;
        }

        if (!(o instanceof FavoritoId)) {
            return false;
        }

        FavoritoId otro = (FavoritoId) o;

        return compradorId.equals(otro.compradorId) && productoId.equals(otro.productoId);
    }

    @Override
    public int hashCode() {
        return compradorId.hashCode() + productoId.hashCode();
    }
}

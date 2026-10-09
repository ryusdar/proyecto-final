package com.Backend_vynta.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "favoritos")
public class Favorito {

    @EmbeddedId
    private FavoritoId id;

    @ManyToOne
    @MapsId("compradorId")
    @JoinColumn(name = "comprador_id", nullable = false)
    private Comprador comprador;

    @ManyToOne
    @MapsId("productoId")
    @JoinColumn(name = "producto_id", nullable = false)
    private Producto producto;

    @Column(name = "creado_en", nullable = false)
    private LocalDateTime creadoEn;

    public Favorito() {
    }

    public Favorito(Comprador comprador, Producto producto, LocalDateTime creadoEn) {
        this.comprador = comprador;
        this.producto = producto;
        this.creadoEn = creadoEn;
    }

    @PrePersist
    protected void antesDeGuardar() {
        if (creadoEn == null) {
            creadoEn = LocalDateTime.now();
        }
    }

    public FavoritoId getId() {
        return id;
    }

    public void setId(FavoritoId id) {
        this.id = id;
    }

    public Comprador getComprador() {
        return comprador;
    }

    public void setComprador(Comprador comprador) {
        this.comprador = comprador;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public LocalDateTime getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(LocalDateTime creadoEn) {
        this.creadoEn = creadoEn;
    }
}

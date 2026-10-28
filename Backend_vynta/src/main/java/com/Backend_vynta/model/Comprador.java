package com.Backend_vynta.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "compradores")
public class Comprador {

    @Id
    @Column(name = "id_comprador")
    private Long idComprador;

    @OneToOne
    @MapsId
    @JoinColumn(name = "id_comprador")
    private Usuario usuario;

    private Boolean activo = true;

    @OneToMany(mappedBy = "comprador")
    private List<Favorito> favoritos = new ArrayList<>();

    @OneToMany(mappedBy = "comprador")
    private List<MetodoPagoComprador> metodosPago = new ArrayList<>();

    @OneToMany(mappedBy = "comprador")
    private List<Pedido> pedidos = new ArrayList<>();

    public Comprador() {
    }

    public Comprador(Usuario usuario, Boolean activo, List<Favorito> favoritos, List<MetodoPagoComprador> metodosPago, List<Pedido> pedidos) {
        this.usuario = usuario;
        this.activo = activo;
        this.favoritos = favoritos;
        this.metodosPago = metodosPago;
        this.pedidos = pedidos;
    }

    public Long getIdComprador() {
        return idComprador;
    }

    public void setIdComprador(Long idComprador) {
        this.idComprador = idComprador;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    public List<Favorito> getFavoritos() {
        return favoritos;
    }

    public void setFavoritos(List<Favorito> favoritos) {
        this.favoritos = favoritos;
    }

    public List<MetodoPagoComprador> getMetodosPago() {
        return metodosPago;
    }

    public void setMetodosPago(List<MetodoPagoComprador> metodosPago) {
        this.metodosPago = metodosPago;
    }

    public List<Pedido> getPedidos() {
        return pedidos;
    }

    public void setPedidos(List<Pedido> pedidos) {
        this.pedidos = pedidos;
    }
}
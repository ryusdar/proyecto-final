package com.Backend_vynta.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "vendedores")
public class Vendedor {

    @Id
    @Column(name = "id_vendedor")
    private Long idVendedor;

    @OneToOne
    @MapsId
    @JoinColumn(name = "id_vendedor")
    private Usuario usuario;

    @Column(name = "nombre_tienda")
    private String nombreTienda;

    private String descripcion;

    private Boolean activo = true;

    @OneToMany(mappedBy = "vendedor")
    private List<Producto> productos = new ArrayList<>();

    public Vendedor() {
    }

    public Vendedor(Usuario usuario, String nombreTienda, String descripcion, Boolean activo, List<Producto> productos) {
        this.usuario = usuario;
        this.nombreTienda = nombreTienda;
        this.descripcion = descripcion;
        this.activo = activo;
        this.productos = productos;
    }

    public Long getIdVendedor() {
        return idVendedor;
    }

    public void setIdVendedor(Long idVendedor) {
        this.idVendedor = idVendedor;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public String getNombreTienda() {
        return nombreTienda;
    }

    public void setNombreTienda(String nombreTienda) {
        this.nombreTienda = nombreTienda;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    public List<Producto> getProductos() {
        return productos;
    }

    public void setProductos(List<Producto> productos) {
        this.productos = productos;
    }
}

package com.Backend_vynta.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "tipos_pago")

public class TipoPago {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "codigo", nullable = false)
    private String codigo;

    @Column(name = "nombre", nullable = false)
    private String nombre;

    @Column(name = "descripcion")
    private String descripcion;

    @OneToMany(mappedBy = "tipoPago")
    private List<MetodoPagoComprador> metodosPago = new ArrayList<>();

    @OneToMany(mappedBy = "tipoPago")
    private List<Pedido> pedidos = new ArrayList<>();

    public TipoPago() {
    }

    public TipoPago(String codigo, String nombre, String descripcion, List<MetodoPagoComprador> metodosPago, List<Pedido> pedidos) {
        this.codigo = codigo;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.metodosPago = metodosPago;
        this.pedidos = pedidos;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
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

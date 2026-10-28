package com.Backend_vynta.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "usuarios")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nombre;

    private String email;

    @Column(name = "password_hash")
    private String passwordHash;

    @Column(name = "foto_url")
    private String fotoUrl;

    @Column(name = "creado_en")
    private LocalDateTime creadoEn;

    @OneToOne(mappedBy = "usuario")
    private Vendedor vendedor;

    @OneToOne(mappedBy = "usuario")
    private Comprador comprador;

    @OneToMany(mappedBy = "usuario")
    private List<Ubicacion> ubicaciones = new ArrayList<>();

    public Usuario() {
    }

    public Usuario(String nombre, String email, String passwordHash, String fotoUrl, LocalDateTime creadoEn, Vendedor vendedor, Comprador comprador, List<Ubicacion> ubicaciones) {
        this.nombre = nombre;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fotoUrl = fotoUrl;
        this.creadoEn = creadoEn;
        this.vendedor = vendedor;
        this.comprador = comprador;
        this.ubicaciones = ubicaciones;
    }

    @PrePersist
    protected void antesDeGuardar() {
        if (creadoEn == null) {
            creadoEn = LocalDateTime.now();
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getFotoUrl() {
        return fotoUrl;
    }

    public void setFotoUrl(String fotoUrl) {
        this.fotoUrl = fotoUrl;
    }

    public LocalDateTime getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(LocalDateTime creadoEn) {
        this.creadoEn = creadoEn;
    }

    public Vendedor getVendedor() {
        return vendedor;
    }

    public void setVendedor(Vendedor vendedor) {
        this.vendedor = vendedor;
    }

    public Comprador getComprador() {
        return comprador;
    }

    public void setComprador(Comprador comprador) {
        this.comprador = comprador;
    }

    public List<Ubicacion> getUbicaciones() {
        return ubicaciones;
    }

    public void setUbicaciones(List<Ubicacion> ubicaciones) {
        this.ubicaciones = ubicaciones;
    }
}

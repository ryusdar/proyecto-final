package com.Backend_vynta.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "metodos_pago_comprador")
public class MetodoPagoComprador {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "comprador_id", nullable = false)
    private Comprador comprador;

    @ManyToOne
    @JoinColumn(name = "tipo_pago_id", nullable = false)
    private TipoPago tipoPago;

    @Column(name = "marca")
    private String marca;

    @Column(name = "ultimos4")
    private String ultimos4;

    @Column(name = "vencimiento_mes")
    private Integer vencimientoMes;

    @Column(name = "vencimiento_anio")
    private Integer vencimientoAnio;

    @Column(name = "token_pasarela")
    private String tokenPasarela;

    @Column(name = "es_principal", nullable = false)
    private Boolean esPrincipal = false;

    @Column(name = "creado_en", nullable = false)
    private LocalDateTime creadoEn;

    public MetodoPagoComprador() {
    }

    public MetodoPagoComprador(Comprador comprador, TipoPago tipoPago, String marca, String ultimos4, Integer vencimientoMes, Integer vencimientoAnio, String tokenPasarela, Boolean esPrincipal, LocalDateTime creadoEn) {
        this.comprador = comprador;
        this.tipoPago = tipoPago;
        this.marca = marca;
        this.ultimos4 = ultimos4;
        this.vencimientoMes = vencimientoMes;
        this.vencimientoAnio = vencimientoAnio;
        this.tokenPasarela = tokenPasarela;
        this.esPrincipal = esPrincipal;
        this.creadoEn = creadoEn;
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

    public Comprador getComprador() {
        return comprador;
    }

    public void setComprador(Comprador comprador) {
        this.comprador = comprador;
    }

    public TipoPago getTipoPago() {
        return tipoPago;
    }

    public void setTipoPago(TipoPago tipoPago) {
        this.tipoPago = tipoPago;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getUltimos4() {
        return ultimos4;
    }

    public void setUltimos4(String ultimos4) {
        this.ultimos4 = ultimos4;
    }

    public Integer getVencimientoMes() {
        return vencimientoMes;
    }

    public void setVencimientoMes(Integer vencimientoMes) {
        this.vencimientoMes = vencimientoMes;
    }

    public Integer getVencimientoAnio() {
        return vencimientoAnio;
    }

    public void setVencimientoAnio(Integer vencimientoAnio) {
        this.vencimientoAnio = vencimientoAnio;
    }

    public String getTokenPasarela() {
        return tokenPasarela;
    }

    public void setTokenPasarela(String tokenPasarela) {
        this.tokenPasarela = tokenPasarela;
    }

    public Boolean getEsPrincipal() {
        return esPrincipal;
    }

    public void setEsPrincipal(Boolean esPrincipal) {
        this.esPrincipal = esPrincipal;
    }

    public LocalDateTime getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(LocalDateTime creadoEn) {
        this.creadoEn = creadoEn;
    }
}

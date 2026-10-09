package com.Backend_vynta.dto;

import java.time.LocalDateTime;

public class MetodoPagoCompradorDTO {

    private Long id;
    private Long compradorId;
    private Long tipoPagoId;
    private String marca;
    private String ultimos4;
    private Integer vencimientoMes;
    private Integer vencimientoAnio;
    private Boolean esPrincipal;
    private LocalDateTime creadoEn;

    public MetodoPagoCompradorDTO() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCompradorId() {
        return compradorId;
    }

    public void setCompradorId(Long compradorId) {
        this.compradorId = compradorId;
    }

    public Long getTipoPagoId() {
        return tipoPagoId;
    }

    public void setTipoPagoId(Long tipoPagoId) {
        this.tipoPagoId = tipoPagoId;
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

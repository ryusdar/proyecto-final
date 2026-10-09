package com.Backend_vynta.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "pedidos")
public class Pedido {

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

    @ManyToOne
    @JoinColumn(name = "metodo_pago_comprador_id")
    private MetodoPagoComprador metodoPagoComprador;

    @Column(name = "total", nullable = false)
    private BigDecimal total;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false)
    private EstadoPedido estado = EstadoPedido.pendiente;

    @Column(name = "creado_en", nullable = false)
    private LocalDateTime creadoEn;

    @OneToMany(mappedBy = "pedido")
    private List<PedidoItem> items = new ArrayList<>();

    public Pedido() {
    }

    public Pedido(Comprador comprador, TipoPago tipoPago, MetodoPagoComprador metodoPagoComprador, BigDecimal total, EstadoPedido estado, LocalDateTime creadoEn, List<PedidoItem> items) {
        this.comprador = comprador;
        this.tipoPago = tipoPago;
        this.metodoPagoComprador = metodoPagoComprador;
        this.total = total;
        this.estado = estado;
        this.creadoEn = creadoEn;
        this.items = items;
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

    public MetodoPagoComprador getMetodoPagoComprador() {
        return metodoPagoComprador;
    }

    public void setMetodoPagoComprador(MetodoPagoComprador metodoPagoComprador) {
        this.metodoPagoComprador = metodoPagoComprador;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }

    public EstadoPedido getEstado() {
        return estado;
    }

    public void setEstado(EstadoPedido estado) {
        this.estado = estado;
    }

    public LocalDateTime getCreadoEn() {
        return creadoEn;
    }

    public void setCreadoEn(LocalDateTime creadoEn) {
        this.creadoEn = creadoEn;
    }

    public List<PedidoItem> getItems() {
        return items;
    }

    public void setItems(List<PedidoItem> items) {
        this.items = items;
    }
}

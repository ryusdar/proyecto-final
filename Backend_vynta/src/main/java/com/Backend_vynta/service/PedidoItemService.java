package com.Backend_vynta.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.PedidoItemDTO;
import com.Backend_vynta.model.Pedido;
import com.Backend_vynta.model.PedidoItem;
import com.Backend_vynta.model.Producto;
import com.Backend_vynta.repository.PedidoItemRepository;
import com.Backend_vynta.repository.PedidoRepository;
import com.Backend_vynta.repository.ProductoRepository;

@Service
public class PedidoItemService {

    private final PedidoItemRepository itemRepository;
    private final PedidoRepository pedidoRepository;
    private final ProductoRepository productoRepository;

    public PedidoItemService(PedidoItemRepository itemRepository,
                             PedidoRepository pedidoRepository,
                             ProductoRepository productoRepository) {
        this.itemRepository = itemRepository;
        this.pedidoRepository = pedidoRepository;
        this.productoRepository = productoRepository;
    }

    public List<PedidoItemDTO> listarPorPedido(Long pedidoId) {
        return itemRepository.findByPedidoId(pedidoId).stream()
                .map(this::aDTO)
                .toList();
    }

    public PedidoItemDTO agregar(Long pedidoId, PedidoItemDTO dto) {
        Pedido pedido = pedidoRepository.findById(pedidoId)
                .orElseThrow(() -> new RuntimeException("Pedido no encontrado"));
        Producto producto = productoRepository.findById(dto.productoId())
                .orElseThrow(() -> new RuntimeException("Producto no encontrado"));

        PedidoItem item = new PedidoItem();
        item.setPedido(pedido);
        item.setProducto(producto);
        item.setCantidad(dto.cantidad());
        item.setPrecioUnitario(producto.getPrecio()); // precio copiado del producto

        PedidoItemDTO guardado = aDTO(itemRepository.save(item));
        recalcularTotal(pedido);
        return guardado;
    }

    public void eliminar(Long id) {
        PedidoItem item = itemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Item no encontrado"));
        Pedido pedido = item.getPedido();
        itemRepository.delete(item);
        recalcularTotal(pedido);
    }

    // total = suma de cantidad * precioUnitario de todos los items
    private void recalcularTotal(Pedido pedido) {
        BigDecimal total = itemRepository.findByPedidoId(pedido.getId()).stream()
                .map(i -> i.getPrecioUnitario().multiply(BigDecimal.valueOf(i.getCantidad())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        pedido.setTotal(total);
        pedidoRepository.save(pedido);
    }

    private PedidoItemDTO aDTO(PedidoItem i) {
        return new PedidoItemDTO(
                i.getId(),
                i.getPedido().getId(),
                i.getProducto().getId(),
                i.getCantidad(),
                i.getPrecioUnitario()
        );
    }
}
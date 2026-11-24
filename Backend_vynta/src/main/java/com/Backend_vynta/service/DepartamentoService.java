package com.Backend_vynta.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.Backend_vynta.dto.DepartamentoDTO;
import com.Backend_vynta.model.Departamento;
import com.Backend_vynta.model.Provincia;
import com.Backend_vynta.repository.DepartamentoRepository;
import com.Backend_vynta.repository.ProvinciaRepository;

@Service
public class DepartamentoService {

    private final DepartamentoRepository departamentoRepository;
    private final ProvinciaRepository provinciaRepository;

    public DepartamentoService(DepartamentoRepository departamentoRepository,
                               ProvinciaRepository provinciaRepository) {
        this.departamentoRepository = departamentoRepository;
        this.provinciaRepository = provinciaRepository;
    }

    public List<DepartamentoDTO> listar() {
        return departamentoRepository.findAll().stream()
                .map(this::aDTO)
                .toList();
    }

    public List<DepartamentoDTO> listarPorProvincia(Long provinciaId) {
        return departamentoRepository.findByProvinciaIdProvincia(provinciaId).stream()
                .map(this::aDTO)
                .toList();
    }

    public DepartamentoDTO buscarPorId(Long id) {
        Departamento d = departamentoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Departamento no encontrado"));
        return aDTO(d);
    }

    public DepartamentoDTO crear(DepartamentoDTO dto) {
        Provincia provincia = provinciaRepository.findById(dto.provinciaId())
                .orElseThrow(() -> new RuntimeException("Provincia no encontrada"));

        Departamento d = new Departamento();
        d.setNombre(dto.nombre());
        d.setProvincia(provincia);
        d.setActivo(true);

        return aDTO(departamentoRepository.save(d));
    }

    public DepartamentoDTO actualizar(Long id, DepartamentoDTO dto) {
        Departamento d = departamentoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Departamento no encontrado"));

        Provincia provincia = provinciaRepository.findById(dto.provinciaId())
                .orElseThrow(() -> new RuntimeException("Provincia no encontrada"));

        d.setNombre(dto.nombre());
        d.setProvincia(provincia);
        if (dto.activo() != null) {
            d.setActivo(dto.activo());
        }

        return aDTO(departamentoRepository.save(d));
    }

    public void eliminar(Long id) {
        if (!departamentoRepository.existsById(id)) {
            throw new RuntimeException("Departamento no encontrado");
        }
        departamentoRepository.deleteById(id);
    }

    private DepartamentoDTO aDTO(Departamento d) {
        return new DepartamentoDTO(
                d.getIdDepartamento(),
                d.getNombre(),
                d.getProvincia().getIdProvincia(),
                d.getActivo()
        );
    }
}
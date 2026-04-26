package com.soft.io.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.soft.io.model.PacienteDTO;
import com.soft.io.repository.PacienteRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PacienteService {

	private final PacienteRepository pacienteRepository;

	@Transactional(readOnly = true)
	public List<PacienteDTO> listarPaciente(String nombre) {
		return pacienteRepository.listarFiltrado(nombre);
	}

	@Transactional
	public void guardarPaciente(PacienteDTO medico) {
		pacienteRepository.insertar(medico);
	}

	@Transactional
	public void actualizarPaciente(PacienteDTO medico) {
		pacienteRepository.actualizar(medico);
	}

	@Transactional
	public void borrarPaciente(String id) {
		pacienteRepository.eliminar(id);
	}

}
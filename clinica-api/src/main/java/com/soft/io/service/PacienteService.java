package com.soft.io.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.soft.io.model.PacienteDTO;
import com.soft.io.repository.PacienteRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PacienteService {

	private final PacienteRepository pacienteRepository;

	public List<PacienteDTO> listarPaciente(String nombre) {
		return pacienteRepository.listarFiltrado(nombre);
	}

	public void guardarPaciente(PacienteDTO medico) {
		pacienteRepository.insertar(medico);
	}

	public void actualizarPaciente(PacienteDTO medico) {
		pacienteRepository.actualizar(medico);
	}

	public void borrarPaciente(String id) {
		pacienteRepository.eliminar(id);
	}

}
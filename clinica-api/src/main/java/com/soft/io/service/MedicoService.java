package com.soft.io.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.soft.io.model.MedicoDTO;
import com.soft.io.repository.MedicoRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MedicoService {

	private final MedicoRepository medicoRepository;

	public List<MedicoDTO> listarMedico(String nombre) {
		return medicoRepository.listarFiltrado(nombre);
	}

	public void guardarMedico(MedicoDTO medico) {
		// Aquí podrías validar que la colegiatura sea única antes de llamar al SP
		medicoRepository.insertar(medico);
	}

	public void actualizarMedico(MedicoDTO medico) {
		medicoRepository.actualizar(medico);
	}

	public void borrarMedico(Long id) {
		medicoRepository.eliminar(id);
	}

}
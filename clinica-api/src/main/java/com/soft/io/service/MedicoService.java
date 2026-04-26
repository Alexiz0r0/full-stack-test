package com.soft.io.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.soft.io.model.MedicoDTO;
import com.soft.io.repository.MedicoRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MedicoService {

	private final MedicoRepository medicoRepository;
	
	@Transactional(readOnly = true)
	public List<MedicoDTO> listarMedico(String nombre) {
		return medicoRepository.listarFiltrado(nombre);
	}

	@Transactional
	public void guardarMedico(MedicoDTO medico) {
		// Aquí podrías validar que la colegiatura sea única antes de llamar al SP
		medicoRepository.insertar(medico);
	}

	@Transactional
	public void actualizarMedico(MedicoDTO medico) {
		medicoRepository.actualizar(medico);
	}

	@Transactional
	public void borrarMedico(String id) {
		medicoRepository.eliminar(id);
	}

}
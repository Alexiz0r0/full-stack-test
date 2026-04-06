package com.soft.io.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.soft.io.model.ApiCustomResponse;
import com.soft.io.model.MedicoDTO;
import com.soft.io.service.MedicoService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/medicos")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class MedicoController {

	private final MedicoService medicoService;

	@GetMapping("/buscar")
	public List<MedicoDTO> buscarMedicos(@RequestParam(required = false) String nombre) {
		return medicoService.listarMedico(nombre);
	}

	@PostMapping
	public ResponseEntity<ApiCustomResponse> crear(@RequestBody MedicoDTO medico) {
		medicoService.guardarMedico(medico);
		return new ResponseEntity<>(
				ApiCustomResponse.builder().message("Médico registrado con éxito").success(true).build(),
				HttpStatus.CREATED);
	}

	@PutMapping("/{id}")
	public ResponseEntity<ApiCustomResponse> actualizar(@PathVariable Long id, @RequestBody MedicoDTO medico) {
		medico.setIdMedico(id);
		medicoService.actualizarMedico(medico);
		return ResponseEntity
				.ok(ApiCustomResponse.builder().message("Médico actualizado correctamente").success(true).build());
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<ApiCustomResponse> eliminar(@PathVariable Long id) {
		medicoService.borrarMedico(id);
		return ResponseEntity
				.ok(ApiCustomResponse.builder().message("Médico eliminado correctamente").success(true).build());
	}

}

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
import com.soft.io.model.PacienteDTO;
import com.soft.io.service.PacienteService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/pacientes")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class PacienteController {

	private final PacienteService pacienteService;

	@GetMapping("/buscar")
	public List<PacienteDTO> buscarMedicos(@RequestParam(required = false) String nombre) {
		return pacienteService.listarPaciente(nombre);
	}

	@PostMapping
	public ResponseEntity<ApiCustomResponse> crear(@RequestBody PacienteDTO medico) {
		pacienteService.guardarPaciente(medico);
		return new ResponseEntity<>(
				ApiCustomResponse.builder().message("Paciente registrado con éxito").success(true).build(),
				HttpStatus.CREATED);
	}

	@PutMapping("/{id}")
	public ResponseEntity<ApiCustomResponse> actualizar(@PathVariable String id, @RequestBody PacienteDTO medico) {
		medico.setIdPaciente(id);
		pacienteService.actualizarPaciente(medico);
		return ResponseEntity
				.ok(ApiCustomResponse.builder().message("Paciente actualizado correctamente").success(true).build());
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<ApiCustomResponse> eliminar(@PathVariable String id) {
		pacienteService.borrarPaciente(id);
		return ResponseEntity
				.ok(ApiCustomResponse.builder().message("Paciente eliminado correctamente").success(true).build());
	}

}

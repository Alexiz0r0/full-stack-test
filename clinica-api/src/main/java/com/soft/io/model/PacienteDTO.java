package com.soft.io.model;

import java.time.LocalDate;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PacienteDTO {

	private String idPaciente;
	private String nombre;
	private LocalDate fechaNacimiento;
	private String sexo;
	private LocalDate fechaApertura;
	private String observaciones;

}

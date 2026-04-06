package com.soft.io.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MedicoDTO {
	
	private Long idMedico;
    private String nombre;
    private String especialidad;
    private String numColegiatura;

}

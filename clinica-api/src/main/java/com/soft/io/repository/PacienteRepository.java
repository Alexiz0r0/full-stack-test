package com.soft.io.repository;

import java.sql.Clob;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.soft.io.model.PacienteDTO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;

@Repository
public class PacienteRepository {

	@PersistenceContext
	private EntityManager entityManager;

	@SuppressWarnings("unchecked")
	public List<PacienteDTO> listarFiltrado(String nombre) {
		StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pkg_paciente.sp_listar_completo");

		query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_resultados", void.class, ParameterMode.REF_CURSOR);

		query.setParameter("p_nombre", nombre);

		query.execute();

		List<Object[]> results = query.getResultList();

		return results.stream().map(row -> new PacienteDTO(
				// ID_PACIENTE
				(String) row[0],
				// NOMBRE
				(String) row[1],
				// FECHA DE NACIMIENTO
				convertToLocalDate(row[2]),
				// SEXO
				row[3] != null ? String.valueOf(row[3]) : null,
				// FECHA DE APERTURA
				convertToLocalDate(row[4]),
				// OBSERVACIONES (CLOB)
				convertClobToString(row[5]))).collect(Collectors.toList());
	}

	/**
	 * Inserta un paciente usando el procedimiento del paquete.
	 */
	@Transactional
	public void insertar(PacienteDTO dto) {
		StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pkg_paciente.sp_registrar_completo");

		query.registerStoredProcedureParameter("p_id_paciente", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_fecha_nacimiento", LocalDate.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_sexo", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_observaciones", String.class, ParameterMode.IN);

		query.setParameter("p_id_paciente", dto.getIdPaciente());
		query.setParameter("p_nombre", dto.getNombre());
		query.setParameter("p_fecha_nacimiento", dto.getFechaNacimiento());
		query.setParameter("p_sexo", dto.getSexo());
		query.setParameter("p_observaciones", dto.getObservaciones());
		
		query.execute();
	}

	/**
	 * Actualiza un paciente existente.
	 */
	@Transactional
	public void actualizar(PacienteDTO dto) {
		StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pkg_paciente.sp_actualizar");

		query.registerStoredProcedureParameter("p_id_paciente", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_fecha_nacimiento", LocalDate.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_sexo", String.class, ParameterMode.IN);
        query.registerStoredProcedureParameter("p_observaciones", String.class, ParameterMode.IN);

        query.setParameter("p_id_paciente", dto.getIdPaciente());
        query.setParameter("p_nombre", dto.getNombre());
        query.setParameter("p_fecha_nacimiento", dto.getFechaNacimiento());
        query.setParameter("p_sexo", dto.getSexo());
        query.setParameter("p_observaciones", dto.getObservaciones());

        query.execute();
	}

	/**
	 * Elimina un paciente por su ID.
	 */
	@Transactional
	public void eliminar(String id) {
		StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pkg_paciente.sp_eliminar");
        query.registerStoredProcedureParameter("p_id_paciente", String.class, ParameterMode.IN);
        query.setParameter("p_id_paciente", id);
        query.execute();
	}

	// Método auxiliar para evitar el error de Timestamp vs Date
	private LocalDate convertToLocalDate(Object obj) {
		if (obj == null)
			return null;
		if (obj instanceof java.sql.Timestamp) {
			return ((java.sql.Timestamp) obj).toLocalDateTime().toLocalDate();
		} else if (obj instanceof java.sql.Date) {
			return ((java.sql.Date) obj).toLocalDate();
		}
		return null;
	}

	private String convertClobToString(Object obj) {
		if (obj == null)
			return null;

		// Si ya es String (a veces el driver lo convierte solo según la versión)
		if (obj instanceof String)
			return (String) obj;

		// Si es un Clob (o un Proxy de Clob)
		if (obj instanceof Clob) {
			Clob clob = (Clob) obj;
			try {
				// Leemos el contenido completo del CLOB
				return clob.getSubString(1, (int) clob.length());
			} catch (SQLException e) {
				return "Error al leer observaciones";
			}
		}

		// Si el driver devuelve el Proxy raro de jdk.proxy
		return obj.toString();
	}

}

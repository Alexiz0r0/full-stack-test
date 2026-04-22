package com.soft.io.repository;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.soft.io.model.MedicoDTO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;

@Repository
public class MedicoRepository {

	@PersistenceContext
	private EntityManager entityManager;

	@SuppressWarnings("unchecked")
	public List<MedicoDTO> listarFiltrado(String nombre) {
		// Nombre del paquete + nombre del procedure
		StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pkg_medico.sp_listar_filtrado");

		// Registrar parámetros (IN y el OUT que es el cursor)
		query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_resultados", void.class, ParameterMode.REF_CURSOR);

		// Setear valores
		query.setParameter("p_nombre", nombre);

		// Ejecutar
		query.execute();

		// Mapear el resultado del cursor
		List<Object[]> results = query.getResultList();

		return results.stream().map(
				row -> new MedicoDTO(((String) row[0]), (String) row[1], (String) row[2], (String) row[3]))
				.toList();
	}

	/**
	 * Inserta un médico usando el procedimiento del paquete.
	 */
	@Transactional
	public void insertar(MedicoDTO medico) {
		StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pkg_medico.sp_insertar");

		query.registerStoredProcedureParameter("p_id_medico", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_especialidad", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_num_colegiatura", String.class, ParameterMode.IN);

		query.setParameter("p_id_medico", medico.getIdMedico());
		query.setParameter("p_nombre", medico.getNombre());
		query.setParameter("p_especialidad", medico.getEspecialidad());
		query.setParameter("p_num_colegiatura", medico.getNumColegiatura());

		query.execute();
	}

	/**
	 * Actualiza un médico existente.
	 */
	@Transactional
	public void actualizar(MedicoDTO medico) {
		StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pkg_medico.sp_actualizar");

		query.registerStoredProcedureParameter("p_id_medico", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_nombre", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_especialidad", String.class, ParameterMode.IN);
		query.registerStoredProcedureParameter("p_num_colegiatura", String.class, ParameterMode.IN);

		query.setParameter("p_id_medico", medico.getIdMedico());
		query.setParameter("p_nombre", medico.getNombre());
		query.setParameter("p_especialidad", medico.getEspecialidad());
		query.setParameter("p_num_colegiatura", medico.getNumColegiatura());

		query.execute();
	}

	/**
	 * Elimina un médico por su ID.
	 */
	@Transactional
	public void eliminar(String id) {
		StoredProcedureQuery query = entityManager.createStoredProcedureQuery("pkg_medico.sp_eliminar");

		query.registerStoredProcedureParameter("p_id_medico", String.class, ParameterMode.IN);
		query.setParameter("p_id_medico", id);

		query.execute();
	}

}

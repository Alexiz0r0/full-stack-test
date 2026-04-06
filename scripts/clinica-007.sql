CREATE OR REPLACE PACKAGE pkg_cita AS
    -- Registrar una nueva cita
    PROCEDURE sp_registrar(
        p_id_cita     IN NUMBER,
        p_fecha_hora  IN TIMESTAMP,
        p_motivo      IN VARCHAR2,
        p_id_paciente IN NUMBER,
        p_id_medico   IN NUMBER
    );

    -- Actualizar datos de una cita (ej. cambio de fecha o motivo)
    PROCEDURE sp_actualizar(
        p_id_cita     IN NUMBER,
        p_fecha_hora  IN TIMESTAMP,
        p_motivo      IN VARCHAR2
    );

    -- Cancelar/Eliminar cita
    PROCEDURE sp_eliminar(p_id_cita IN NUMBER);

    -- Buscar detalle de cita por ID (incluye nombres de médico y paciente)
    PROCEDURE sp_buscar_id(
        p_id_cita   IN NUMBER,
        p_registro  OUT SYS_REFCURSOR
    );
END pkg_cita;
/
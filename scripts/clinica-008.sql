CREATE OR REPLACE PACKAGE BODY pkg_cita AS

    -- INSERT con validación de llaves foráneas manual (opcional pero recomendado)
    PROCEDURE sp_registrar(
        p_id_cita     IN NUMBER,
        p_fecha_hora  IN TIMESTAMP,
        p_motivo      IN VARCHAR2,
        p_id_paciente IN NUMBER,
        p_id_medico   IN NUMBER
    ) AS
    BEGIN
        INSERT INTO cita (id_cita, fecha_hora, motivo, id_paciente, id_medico)
        VALUES (p_id_cita, p_fecha_hora, p_motivo, p_id_paciente, p_id_medico);
        
        COMMIT;
    EXCEPTION
        -- Captura específica de error de llave foránea (ORA-02291)
        WHEN OTHERS THEN
            ROLLBACK;
            IF SQLCODE = -2291 THEN
                RAISE_APPLICATION_ERROR(-20020, 'Error: El Paciente o el Médico no existen.');
            ELSE
                RAISE_APPLICATION_ERROR(-20021, 'Error al registrar cita: ' || SQLERRM);
            END IF;
    END sp_registrar;

    -- UPDATE
    PROCEDURE sp_actualizar(
        p_id_cita     IN NUMBER,
        p_fecha_hora  IN TIMESTAMP,
        p_motivo      IN VARCHAR2
    ) AS
    BEGIN
        UPDATE cita
        SET fecha_hora = p_fecha_hora,
            motivo = p_motivo
        WHERE id_cita = p_id_cita;

        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20022, 'Cita no encontrada para actualizar.');
        END IF;
        COMMIT;
    END sp_actualizar;

    -- DELETE
    PROCEDURE sp_eliminar(p_id_cita IN NUMBER) AS
    BEGIN
        DELETE FROM cita WHERE id_cita = p_id_cita;
        
        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20023, 'Cita no encontrada para eliminar.');
        END IF;
        COMMIT;
    END sp_eliminar;

    -- FIND BY ID con Información Relacionada
    PROCEDURE sp_buscar_id(
        p_id_cita   IN NUMBER,
        p_registro  OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_registro FOR
            SELECT 
                c.id_cita,
                c.fecha_hora,
                c.motivo,
                p.nombre AS paciente_nombre,
                m.nombre AS medico_nombre,
                m.especialidad
            FROM cita c
            JOIN paciente p ON c.id_paciente = p.id_paciente
            JOIN medico m ON c.id_medico = m.id_medico
            WHERE c.id_cita = p_id_cita;
    END sp_buscar_id;

END pkg_cita;
/
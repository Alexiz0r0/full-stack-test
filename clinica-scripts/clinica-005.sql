CREATE OR REPLACE PACKAGE BODY pkg_medico AS

    -- INSERT
    PROCEDURE sp_insertar(
        p_id_medico       IN VARCHAR2,
        p_nombre          IN VARCHAR2,
        p_especialidad    IN VARCHAR2,
        p_num_colegiatura IN VARCHAR2
    ) AS
    BEGIN
        INSERT INTO medico (id_medico, nombre, especialidad, num_colegiatura)
        VALUES (p_id_medico, p_nombre, p_especialidad, p_num_colegiatura);
        
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error al insertar médico: ' || SQLERRM);

    END sp_insertar;

    -- UPDATE
    PROCEDURE sp_actualizar(
        p_id_medico       IN VARCHAR2,
        p_nombre          IN VARCHAR2,
        p_especialidad    IN VARCHAR2,
        p_num_colegiatura IN VARCHAR2
    ) AS
    BEGIN
        UPDATE medico
        SET nombre = p_nombre,
            especialidad = p_especialidad,
            num_colegiatura = p_num_colegiatura
        WHERE id_medico = p_id_medico;
        
        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Médico no encontrado para actualizar.');
        END IF;
        
    END sp_actualizar;

    -- DELETE
    PROCEDURE sp_eliminar(p_id_medico IN VARCHAR2) AS
    BEGIN
        DELETE FROM medico WHERE id_medico = p_id_medico;
        
        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Médico no encontrado para eliminar.');
        END IF;
        
    END sp_eliminar;

    -- FIND BY ID
    PROCEDURE sp_buscar_id(
        p_id_medico IN VARCHAR2,
        p_registro  OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_registro FOR
            SELECT * FROM medico WHERE id_medico = p_id_medico;
    END sp_buscar_id;
    
    -- Listar con filtros opcionales
    PROCEDURE sp_listar_filtrado(
        p_nombre       IN VARCHAR2,
        p_resultados   OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_resultados FOR
            SELECT id_medico, nombre, especialidad, num_colegiatura
            FROM medico
            WHERE (UPPER(nombre) LIKE '%' || UPPER(p_nombre) || '%' OR p_nombre IS NULL)
            ORDER BY nombre;
    END sp_listar_filtrado;

END pkg_medico;
/
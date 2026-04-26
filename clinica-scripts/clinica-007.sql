create or replace NONEDITIONABLE PACKAGE BODY pkg_paciente AS

    -- INSERT
    PROCEDURE sp_registrar_completo(
        p_id_paciente      IN VARCHAR2,
        p_nombre           IN VARCHAR2,
        p_fecha_nacimiento IN DATE,
        p_sexo             IN CHAR,
        p_observaciones    IN CLOB
    ) AS
        v_nuevo_id VARCHAR2(36);
    BEGIN
        -- 1. Insertar el Paciente
        INSERT INTO paciente (id_paciente, nombre, fecha_nacimiento, sexo)
        VALUES (p_id_paciente, p_nombre, p_fecha_nacimiento, p_sexo)
        RETURNING id_paciente INTO v_nuevo_id;

        -- 2. Insertar la Historia Clínica vinculada (Regla 1:1)
        INSERT INTO historia_clinica (id_paciente, fecha_apertura, observaciones)
        VALUES (v_nuevo_id, SYSDATE, p_observaciones);

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20010, 'Error en registro integral: ' || SQLERRM);

    END sp_registrar_completo;

    -- UPDATE
    PROCEDURE sp_actualizar(
        p_id_paciente      IN VARCHAR2,
        p_nombre           IN VARCHAR2,
        p_fecha_nacimiento IN DATE,
        p_sexo             IN CHAR,
        p_observaciones    IN CLOB
    ) AS
    BEGIN
        -- 1. Actualizar datos del paciente
        UPDATE paciente
        SET nombre = p_nombre,
            fecha_nacimiento = p_fecha_nacimiento,
            sexo = p_sexo
        WHERE id_paciente = p_id_paciente;

        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20011, 'Paciente no encontrado.');
        END IF;
        
        -- 2. Actualizar las observaciones en la historia clínica
        UPDATE historia_clinica
        SET observaciones = p_observaciones
        WHERE id_paciente = p_id_paciente;
        
        EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20013, 'Error al actualizar paciente e historia: ' || SQLERRM);
    END sp_actualizar;

    -- DELETE
    PROCEDURE sp_eliminar(p_id_paciente IN VARCHAR2) AS
    BEGIN
        -- 1. Borrar datos del paciente
        DELETE FROM paciente WHERE id_paciente = p_id_paciente;

        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20012, 'No se pudo eliminar: ID inexistente.');
        END IF;
        
    END sp_eliminar;

    -- FIND BY ID
    PROCEDURE sp_buscar_id(
        p_id_paciente IN VARCHAR2,
        p_registro    OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_registro FOR
            SELECT p.*, h.fecha_apertura, h.observaciones
            FROM paciente p
            JOIN historia_clinica h ON p.id_paciente = h.id_paciente
            WHERE p.id_paciente = p_id_paciente;
    END sp_buscar_id;
    
    -- LISTAR CON FILTROS OPCIONALES
    PROCEDURE sp_listar_completo(
        p_nombre     IN VARCHAR2,
        p_resultados OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN p_resultados FOR
            SELECT 
                p.id_paciente,
                p.nombre,
                p.fecha_nacimiento,
                p.sexo,
                h.fecha_apertura,
                h.observaciones
            FROM paciente p
            INNER JOIN historia_clinica h ON p.id_paciente = h.id_paciente
            WHERE (UPPER(p.nombre) LIKE '%' || UPPER(p_nombre) || '%' OR p_nombre IS NULL)
            ORDER BY p.nombre;
    END sp_listar_completo;

END pkg_paciente;
/
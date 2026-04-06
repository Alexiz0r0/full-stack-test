CREATE OR REPLACE PACKAGE pkg_medico AS
    -- Insertar
    PROCEDURE sp_insertar(
        p_id_medico       IN NUMBER,
        p_nombre          IN VARCHAR2,
        p_especialidad    IN VARCHAR2,
        p_num_colegiatura IN VARCHAR2
    );

    -- Actualizar
    PROCEDURE sp_actualizar(
        p_id_medico       IN NUMBER,
        p_nombre          IN VARCHAR2,
        p_especialidad    IN VARCHAR2,
        p_num_colegiatura IN VARCHAR2
    );

    -- Eliminar
    PROCEDURE sp_eliminar(p_id_medico IN NUMBER);

    -- Buscar por ID (Retorna un Cursor para facilidad del desarrollador)
    PROCEDURE sp_buscar_id(
        p_id_medico IN NUMBER,
        p_registro  OUT SYS_REFCURSOR
    );
    
    -- Listar con filtros opcionales
    PROCEDURE sp_listar_filtrado(
        p_nombre       IN VARCHAR2,
        p_resultados   OUT SYS_REFCURSOR
    );
END pkg_medico;
/
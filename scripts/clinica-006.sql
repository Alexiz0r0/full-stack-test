CREATE OR REPLACE PACKAGE pkg_paciente AS
    -- Inserta Paciente y su Historia Clínica en un solo paso (Integridad 1:1)
    PROCEDURE sp_registrar_completo(
        p_id_paciente      IN NUMBER,
        p_nombre           IN VARCHAR2,
        p_fecha_nacimiento IN DATE,
        p_sexo             IN CHAR,
        p_observaciones    IN CLOB
    );

    PROCEDURE sp_actualizar(
        p_id_paciente      IN NUMBER,
        p_nombre           IN VARCHAR2,
        p_fecha_nacimiento IN DATE,
        p_sexo             IN CHAR
    );

    PROCEDURE sp_eliminar(p_id_paciente IN NUMBER);

    PROCEDURE sp_buscar_id(
        p_id_paciente IN NUMBER,
        p_registro    OUT SYS_REFCURSOR
    );
END pkg_paciente;
/
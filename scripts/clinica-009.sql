DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_cita NUMBER;
    -- Variables para leer el cursor
    v_f_hora TIMESTAMP;
    v_mot    VARCHAR2(200);
    v_p_nom  VARCHAR2(100);
    v_m_nom  VARCHAR2(100);
    v_esp    VARCHAR2(100);
BEGIN
    -- 1. Insertar usando el paquete (Asumiendo que existen Paciente 101 y Médico 1)
    pkg_cita.sp_registrar(
        p_id_cita     => 505,
        p_fecha_hora  => TO_TIMESTAMP('2026-05-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_motivo      => 'Chequeo General Post-Pandemia',
        p_id_paciente => 101,
        p_id_medico   => 1
    );
END;
/

DECLARE
    v_cursor SYS_REFCURSOR;
    v_id_cita NUMBER;
    -- Variables para leer el cursor
    v_f_hora TIMESTAMP;
    v_mot    VARCHAR2(200);
    v_p_nom  VARCHAR2(100);
    v_m_nom  VARCHAR2(100);
    v_esp    VARCHAR2(100);
BEGIN
    -- 2. Buscar la cita (suponiendo que sabemos el ID o usamos una consulta previa)
    -- Aquí solo para demostrar el uso del cursor:
    pkg_cita.sp_buscar_id(505, v_cursor); -- ID de la data dummy anterior
    
    LOOP
        FETCH v_cursor INTO v_id_cita, v_f_hora, v_mot, v_p_nom, v_m_nom, v_esp;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Cita: ' || v_p_nom || ' con ' || v_m_nom || ' (' || v_esp || ')');
    END LOOP;
    CLOSE v_cursor;
END;
/
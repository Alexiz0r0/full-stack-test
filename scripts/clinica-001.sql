-- Limpieza
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE CITA CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE HISTORIA_CLINICA CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE MEDICO CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE PACIENTE CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN NULL; -- Ignora errores si las tablas no existen aún
END;
/

-- 1. Tabla PACIENTE
CREATE TABLE paciente (
    id_paciente       VARCHAR2(36),
    nombre            VARCHAR2(100)        NOT NULL,
    fecha_nacimiento  DATE                 NOT NULL,
    sexo              CHAR(1),
    CONSTRAINT pk_paciente PRIMARY KEY (id_paciente),
    CONSTRAINT chk_sexo CHECK (sexo IN ('M', 'F'))
);

-- 2. Tabla HISTORIA_CLINICA (Relación 1:1)
CREATE TABLE historia_clinica (
    id_paciente        VARCHAR2(36),
    fecha_apertura     DATE                 NOT NULL,
    observaciones      CLOB,
    CONSTRAINT pk_historia_clinica PRIMARY KEY (id_paciente),
    CONSTRAINT fk_historia_paciente FOREIGN KEY (id_paciente) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE
);

-- 3. Tabla MEDICO
CREATE TABLE medico (
    id_medico          VARCHAR2(36),
    nombre             VARCHAR2(100)        NOT NULL,
    especialidad       VARCHAR2(100)        NOT NULL,
    num_colegiatura    VARCHAR2(20),
    CONSTRAINT pk_medico PRIMARY KEY (id_medico),
    CONSTRAINT uq_num_colegiatura UNIQUE (num_colegiatura)
);

-- 4. Tabla CITA (Relación 1:N con Paciente y Médico)
CREATE TABLE cita (
    id_cita            VARCHAR2(36),
    fecha_hora         TIMESTAMP            NOT NULL,
    motivo             VARCHAR2(200),
    id_paciente        VARCHAR2(36)               NOT NULL,
    id_medico          VARCHAR2(36)               NOT NULL,
    CONSTRAINT pk_cita PRIMARY KEY (id_cita),
    -- Al borrar el paciente, se borran sus citas
    CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    -- Al borrar el médico, se borran sus citas
    CONSTRAINT fk_cita_medico FOREIGN KEY (id_medico) 
        REFERENCES medico(id_medico) ON DELETE CASCADE
);


-- 1. Eliminar las restricciones actuales
ALTER TABLE cita DROP CONSTRAINT fk_cita_paciente;
ALTER TABLE cita DROP CONSTRAINT fk_cita_medico;

-- 2. Volver a crearlas con ON DELETE CASCADE
ALTER TABLE cita ADD CONSTRAINT fk_cita_paciente 
    FOREIGN KEY (id_paciente) REFERENCES paciente(id_paciente) ON DELETE CASCADE;

ALTER TABLE cita ADD CONSTRAINT fk_cita_medico 
    FOREIGN KEY (id_medico) REFERENCES medico(id_medico) ON DELETE CASCADE;
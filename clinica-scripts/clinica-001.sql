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

-- Tabla PACIENTE
CREATE TABLE paciente (
    id_paciente       VARCHAR2(36),
    nombre             VARCHAR2(100)        NOT NULL,
    fecha_nacimiento   DATE                 NOT NULL,
    sexo               CHAR(1),
    -- Completar PK
    

);

-- Tabla HISTORIA_CLINICA
CREATE TABLE historia_clinica (
    id_paciente        VARCHAR2(36),
    fecha_apertura     DATE                 NOT NULL,
    observaciones      CLOB,
    -- Completar PK y FK
    

);

-- Tabla MEDICO
CREATE TABLE medico (
    id_medico          VARCHAR2(36),
    nombre             VARCHAR2(100)        NOT NULL,
    especialidad       VARCHAR2(100)        NOT NULL,
    num_colegiatura    VARCHAR2(20),
    -- Completar PK y restricción UNIQUE en num_colegiatura
    

);

-- Tabla CITA
CREATE TABLE cita (
    id_cita            VARCHAR2(36),
    fecha_hora         TIMESTAMP            NOT NULL,
    motivo             VARCHAR2(200),
    id_paciente        VARCHAR2(36)               NOT NULL,
    id_medico          VARCHAR2(36)               NOT NULL,
    -- Completar PK y FKs
    
);

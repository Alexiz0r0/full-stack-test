-- 1. Insertar Médicos
INSERT INTO medico (id_medico, nombre, especialidad, num_colegiatura) 
VALUES ('1', 'Dr. Gregory House', 'Diagnóstico Clínico', 'COL-12345');
INSERT INTO medico (id_medico, nombre, especialidad, num_colegiatura) 
VALUES ('2', 'Dra. Meredith Grey', 'Cirugía General', 'COL-67890');
INSERT INTO medico (id_medico, nombre, especialidad, num_colegiatura) 
VALUES ('3', 'Dr. Shaun Murphy', 'Cirugía Pediátrica', 'COL-55443');

-- 2. Insertar Pacientes
INSERT INTO paciente (id_paciente, nombre, fecha_nacimiento, sexo) 
VALUES ('101', 'Juan Pérez', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 'M');
INSERT INTO paciente (id_paciente, nombre, fecha_nacimiento, sexo) 
VALUES ('102', 'Maria Garcia', TO_DATE('1992-08-22', 'YYYY-MM-DD'), 'F');
INSERT INTO paciente (id_paciente, nombre, fecha_nacimiento, sexo) 
VALUES ('103', 'Carlos Ruiz', TO_DATE('1970-01-10', 'YYYY-MM-DD'), 'M');

-- 3. Insertar Historias Clínicas (Relación 1:1 con Paciente)
-- Nota: id_paciente debe coincidir con los insertados arriba
INSERT INTO historia_clinica (id_paciente, fecha_apertura, observaciones) 
VALUES ('101', SYSDATE, 'Paciente con antecedentes de hipertensión.');
INSERT INTO historia_clinica (id_paciente, fecha_apertura, observaciones) 
VALUES ('102', SYSDATE, 'Alergia conocida a la penicilina.');
INSERT INTO historia_clinica (id_paciente, fecha_apertura, observaciones) 
VALUES ('103', SYSDATE, 'Control anual de rutina. Sin hallazgos críticos.');

-- 4. Insertar Citas (Relación 1:N)
INSERT INTO cita (id_cita, fecha_hora, motivo, id_paciente, id_medico) 
VALUES ('501', TO_TIMESTAMP('2026-04-10 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dolor lumbar persistente', '101', '1');
INSERT INTO cita (id_cita, fecha_hora, motivo, id_paciente, id_medico) 
VALUES ('502', TO_TIMESTAMP('2026-04-10 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Consulta post-operatoria', '102', '2');
INSERT INTO cita (id_cita, fecha_hora, motivo, id_paciente, id_medico) 
VALUES ('503', TO_TIMESTAMP('2026-04-11 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Chequeo pediátrico preventivo', '103', '3');
INSERT INTO cita (id_cita, fecha_hora, motivo, id_paciente, id_medico) 
VALUES ('504', TO_TIMESTAMP('2026-04-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Migrañas frecuentes', '101', '1');

COMMIT;
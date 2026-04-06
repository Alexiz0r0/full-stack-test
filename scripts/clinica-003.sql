SELECT 
    c.fecha_hora, 
    p.nombre AS nombre_paciente, 
    m.nombre AS nombre_medico, 
    c.motivo
FROM cita c
JOIN paciente p ON c.id_paciente = p.id_paciente
JOIN medico m ON c.id_medico = m.id_medico
ORDER BY c.fecha_hora;

SELECT 
    p.nombre, 
    hc.fecha_apertura, 
    hc.observaciones
FROM paciente p
INNER JOIN historia_clinica hc ON p.id_paciente = hc.id_paciente
WHERE hc.observaciones IS NOT NULL;


SELECT * from medico;
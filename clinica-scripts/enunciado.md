# Test técnico – Oracle Database 19c

Se requiere modelar e implementar un esquema de base de datos para un sistema de gestión de una clínica.
El sistema debe contemplar las siguientes entidades:

- PACIENTE
- HISTORIA_CLINICA
- MEDICO
- CITA

## Reglas de negocio

- Cada Paciente tiene una y solo una Historia Clínica.
- Una Historia Clínica pertenece a un solo Paciente y no puede existir sin él.
- Un Paciente puede tener una o muchas Citas.
- Un Médico puede atender una o muchas Citas.
- Cada Cita corresponde a un solo Paciente y un solo Médico.

## Requerimientos técnicos

Implementar el modelo usando Oracle Database 19c.

## Definir correctamente:

- Claves primarias
- Claves foráneas
- Restricciones NOT NULL, UNIQUE y las necesarias para cumplir las reglas de negocio.
- Implementar correctamente las relaciones 1:1 y 1:N.

## Entregables

- Script DDL completo de creación de tablas.

- Al menos 2 consultas SQL que utilicen JOIN.

Importante: no se debe modificar ni agregar nuevas entidades.
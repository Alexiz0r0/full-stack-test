import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { APIResponse } from '../interfaces/api-response';
import { Paciente } from '../interfaces/paciente.interface';

const API_URL = 'http://localhost:8082/api';

@Injectable({
  providedIn: 'root',
})
export class PacienteService {
  private http = inject(HttpClient);

  private readonly API_URL = `${API_URL}/pacientes`;

  // GET: Buscar pacientes por nombre
  buscarPaciente(query: string) {
    const params = query ? `?nombre=${query.toLowerCase()}` : '';
    return this.http.get<Paciente[]>(`${this.API_URL}/buscar${params}`);
  }

  // POST: Crear un nuevo paciente
  crear(medico: Paciente) {
    return this.http.post<APIResponse>(this.API_URL, medico);
  }

  // PUT: Actualizar paciente existente
  actualizar(id: string, medico: Paciente) {
    return this.http.put<APIResponse>(`${this.API_URL}/${id}`, medico);
  }

  // DELETE: Eliminar paciente
  eliminar(id: string) {
    return this.http.delete<APIResponse>(`${this.API_URL}/${id}`);
  }
}

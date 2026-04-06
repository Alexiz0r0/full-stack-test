import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { APIResponse } from '../interfaces/api-response';
import { Medico } from '../interfaces/medico.interface';

const API_URL = 'http://localhost:8082/api';

@Injectable({
  providedIn: 'root',
})
export class MedicoService {
  private http = inject(HttpClient);

  buscarMedico(query: string) {
    query = query.toLowerCase();
    return this.http.get<Medico[]>(`${API_URL}/medicos/buscar?nombre=${query}`);
  }

  eliminar(medico: Medico) {
    return this.http.delete<APIResponse>(`${API_URL}/medicos/${medico.idMedico}`);
  }
}

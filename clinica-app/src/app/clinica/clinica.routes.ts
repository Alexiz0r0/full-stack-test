import { Routes } from '@angular/router';
import { ClinicaLayoutComponent } from './layouts/clinica-layout/clinica-layout';
import { CitaPageComponent } from './pages/cita-page/cita-page';
import { MedicoPageComponent } from './pages/medico-page/medico-page';
import { PacientePageComponent } from './pages/paciente-page/paciente-page';

export const clinicaRoutes: Routes = [
  {
    path: '',
    component: ClinicaLayoutComponent,
    children: [
      {
        path: 'medico',
        component: MedicoPageComponent,
      },
      {
        path: 'paciente',
        component: PacientePageComponent,
      },
      {
        path: 'cita',
        component: CitaPageComponent,
      },
      {
        path: '**',
        redirectTo: 'medico',
      },
    ],
  },
];

export default clinicaRoutes;

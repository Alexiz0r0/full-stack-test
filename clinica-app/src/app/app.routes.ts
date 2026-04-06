import { Routes } from '@angular/router';
import { HomePageComponent } from './shared/pages/home-page/home-page';

export const routes: Routes = [
  {
    path: '',
    component: HomePageComponent,
  },
  {
    path: 'clinica',
    loadChildren: () => import('./clinica/clinica.routes'),
  },
  {
    path: '**',
    redirectTo: '',
  },
];

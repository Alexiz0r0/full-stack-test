import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'app-paciente-page',
  standalone: true,
  imports: [],
  templateUrl: './paciente-page.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PacientePageComponent { }

import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { TopMenuComponent } from '../../components/top-menu/top-menu';

@Component({
  selector: 'app-clinica-layout',
  standalone: true,
  imports: [RouterOutlet, TopMenuComponent],
  templateUrl: './clinica-layout.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ClinicaLayoutComponent {}

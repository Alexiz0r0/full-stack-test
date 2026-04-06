import {
  ChangeDetectionStrategy,
  Component,
  inject,
  signal,
  viewChild,
} from '@angular/core';
import { MedicoListComponent } from '../../components/medico-list/medico-list';
import { SearchInputComponent } from '../../components/search-input/search-input';
import { ToastComponent } from '../../components/toast/toast';
import { Medico } from '../../interfaces/medico.interface';
import { MedicoService } from '../../service/medico-service';

@Component({
  selector: 'app-medico-page',
  standalone: true,
  imports: [SearchInputComponent, MedicoListComponent, ToastComponent],
  templateUrl: './medico-page.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MedicoPageComponent {
  medicoService = inject(MedicoService);

  isLoading = signal(false);
  isError = signal<null | string>(null);
  medicos = signal<Medico[]>([]);

  // Referencia al componente Toast
  toast = viewChild(ToastComponent);

  // Signals para el contenido del toast
  toastMessage = signal('');
  toastType = signal<'alert-success' | 'alert-error'>('alert-success');

  onSearch(value: string) {
    console.log({ value });
    this.isLoading.set(true);
    this.isError.set(null);
    this.medicoService.buscarMedico(value).subscribe({
      next: (medicos) => {
        this.isLoading.set(false);
        this.medicos.set(medicos);
      },
      error: () => {
        this.isLoading.set(false);
        this.medicos.set([]);
        this.isError.set('Ocurrió un error');
      },
    });
  }

  confirmarEliminacion(medico: Medico) {
    this.isLoading.set(true);
    this.isError.set(null);
    this.medicoService.eliminar(medico).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        // 1. ACTUALIZAR EL SIGNAL DE MEDICOS (Inmutabilidad)
        // Filtramos el médico eliminado para que desaparezca de la vista de inmediato
        this.medicos.update((listado) =>
          listado.filter((m) => m.idMedico !== medico.idMedico),
        );
        // 2. Configurar y mostrar Toast
        this.toastMessage.set(response.message); // El mensaje que viene del Back
        this.toastType.set('alert-success');
        this.toast()?.show();
      },
      error: () => {
        this.isLoading.set(false);
        this.isError.set('Ocurrió un error');
        this.toastMessage.set('Error al eliminar el registro');
        this.toastType.set('alert-error');
        this.toast()?.show();
      },
    });
  }
}

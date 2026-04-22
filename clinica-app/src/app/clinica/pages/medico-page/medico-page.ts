import {
  ChangeDetectionStrategy,
  Component,
  inject,
  OnInit,
  signal,
  viewChild,
} from '@angular/core';
import { MedicoFormComponent } from '../../components/medico-form/medico-form';
import { MedicoListComponent } from '../../components/medico-list/medico-list';
import { SearchInputComponent } from '../../components/search-input/search-input';
import { ToastComponent } from '../../components/toast/toast';
import { Medico } from '../../interfaces/medico.interface';
import { MedicoService } from '../../service/medico-service';

@Component({
  selector: 'app-medico-page',
  standalone: true,
  imports: [
    SearchInputComponent,
    MedicoListComponent,
    ToastComponent,
    MedicoFormComponent,
  ],
  templateUrl: './medico-page.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MedicoPageComponent implements OnInit {
  medicoService = inject(MedicoService);

  isLoading = signal(false);
  isError = signal<null | string>(null);
  medicos = signal<Medico[]>([]);

  // Referencia al componente Toast
  toast = viewChild(ToastComponent);

  // Signals para el contenido del toast
  toastMessage = signal('');
  toastType = signal<'alert-success' | 'alert-error'>('alert-success');

  showTable = signal(true);

  medicoSeleccionado = signal<Medico | null>(null);

  // Guardamos el último término de búsqueda para refrescar con el filtro aplicado
  searchTerm = signal('');

  ngOnInit(): void {
    this.onSearch('');
  }

  onSearch(value: string) {
    this.searchTerm.set(value); // Guardamos lo que el usuario escribió
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
    this.medicoService.eliminar(medico.idMedico).subscribe({
      next: (response) => {
        this.isLoading.set(false);
        // 1. Refrescamos la lista desde el servidor para asegurar sincronía
        this.onSearch(this.searchTerm());
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

  cargarEdicion(medico: Medico) {
    this.medicoSeleccionado.set(medico);
    this.showTable.set(false);
  }

  guardar(datos: any) {
    const operacion = this.medicoSeleccionado()
      ? this.medicoService.actualizar(
          this.medicoSeleccionado()!.idMedico,
          datos,
        )
      : this.medicoService.crear(datos);

    operacion.subscribe({
      next: (res) => {
        this.toastMessage.set(res.message);
        this.toastType.set('alert-success');
        this.toast()?.show();

        this.limpiar();
        this.showTable.set(true);

        // REFRESCAR LISTA
        this.onSearch(this.searchTerm());
      },
      error: (err) => {
        this.toastMessage.set('Error en la operación');
        this.toastType.set('alert-error');
        this.toast()?.show();
      },
    });

    this.limpiar();
  }

  limpiar() {
    this.medicoSeleccionado.set(null);
  }

  cancelar(value: boolean) {
    this.limpiar();
    this.showTable.set(value);
  }

  crearBtn() {
    this.showTable.set(false);
  }
}

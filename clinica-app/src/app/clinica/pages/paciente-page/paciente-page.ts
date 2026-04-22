import {
  ChangeDetectionStrategy,
  Component,
  inject,
  signal,
  viewChild,
} from '@angular/core';
import { PacienteFormComponent } from '../../components/paciente-form/paciente-form';
import { PacienteListComponent } from '../../components/paciente-list/paciente-list';
import { SearchInputComponent } from '../../components/search-input/search-input';
import { ToastComponent } from '../../components/toast/toast';
import { Paciente } from '../../interfaces/paciente.interface';
import { PacienteService } from '../../service/paciente-service';

@Component({
  selector: 'app-paciente-page',
  standalone: true,
  imports: [
    SearchInputComponent,
    PacienteListComponent,
    ToastComponent,
    PacienteFormComponent,
  ],
  templateUrl: './paciente-page.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PacientePageComponent {
  pacienteService = inject(PacienteService);

  isLoading = signal(false);
  isError = signal<null | string>(null);
  medicos = signal<Paciente[]>([]);

  // Referencia al componente Toast
  toast = viewChild(ToastComponent);

  // Signals para el contenido del toast
  toastMessage = signal('');
  toastType = signal<'alert-success' | 'alert-error'>('alert-success');

  showTable = signal(true);

  pacienteSeleccionado = signal<Paciente | null>(null);

  // Guardamos el último término de búsqueda para refrescar con el filtro aplicado
  searchTerm = signal('');

  ngOnInit(): void {
    this.onSearch('');
  }

  onSearch(value: string) {
    this.searchTerm.set(value); // Guardamos lo que el usuario escribió
    this.isLoading.set(true);
    this.isError.set(null);
    this.pacienteService.buscarPaciente(value).subscribe({
      next: (lista) => {
        this.isLoading.set(false);
        this.medicos.set(lista);
      },
      error: () => {
        this.isLoading.set(false);
        this.medicos.set([]);
        this.isError.set('Ocurrió un error');
      },
    });
  }

  confirmarEliminacion(medico: Paciente) {
    this.isLoading.set(true);
    this.isError.set(null);
    this.pacienteService.eliminar(medico.idPaciente).subscribe({
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

  cargarEdicion(paciente: Paciente) {
    this.pacienteSeleccionado.set(paciente);
    this.showTable.set(false);
  }

  guardar(datos: any) {
    const operacion = this.pacienteSeleccionado()
      ? this.pacienteService.actualizar(
          this.pacienteSeleccionado()!.idPaciente,
          datos,
        )
      : this.pacienteService.crear(datos);

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
    this.pacienteSeleccionado.set(null);
  }

  cancelar(value: boolean) {
    this.limpiar();
    this.showTable.set(value);
  }

  crearBtn() {
    this.showTable.set(false);
  }
}

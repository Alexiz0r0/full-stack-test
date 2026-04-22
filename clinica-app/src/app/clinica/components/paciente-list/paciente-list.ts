import {
  ChangeDetectionStrategy,
  Component,
  input,
  output,
  signal,
  viewChild,
} from '@angular/core';
import { Paciente } from '../../interfaces/paciente.interface';
import { ConfirmModalComponent } from '../confirm-modal/confirm-modal';

@Component({
  selector: 'paciente-list',
  standalone: true,
  imports: [ConfirmModalComponent],
  templateUrl: './paciente-list.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PacienteListComponent {
  medicos = input.required<Paciente[]>();

  errorMessage = input<null | string>(null);
  isLoading = input<boolean>(false);
  isEmpty = input<boolean>(false);

  // Obtenemos la referencia del modal como un Signal
  // #modalBorrar es la referencia que pondremos en el HTML
  modalBorrar = viewChild<ConfirmModalComponent>('modalEliminar');

  medico = signal<Paciente | null>(null);
  confirmarEliminacion = output<Paciente>();

  medicoSeleccionado = output<Paciente>();

  abrirModal(medico: Paciente) {
    this.medico.set(medico);
    // LLAMADA AL MODAL:
    // Al ser un Signal, usamos () para obtener el valor y luego llamamos al método
    this.modalBorrar()?.open();
  }

  ejecutarEliminacion() {
    const medico = this.medico();
    if (medico) {
      this.confirmarEliminacion.emit(medico);
    }
    this.medico.set(null);
  }

  cargarEdicion(medico: Paciente) {
    this.medicoSeleccionado.emit(medico);
  }
}

import {
  ChangeDetectionStrategy,
  Component,
  input,
  output,
  signal,
  viewChild,
} from '@angular/core';
import { Medico } from '../../interfaces/medico.interface';
import { ConfirmModalComponent } from '../confirm-modal/confirm-modal';

@Component({
  selector: 'medico-list',
  standalone: true,
  imports: [ConfirmModalComponent],
  templateUrl: './medico-list.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MedicoListComponent {
  medicos = input.required<Medico[]>();

  errorMessage = input<null | string>(null);
  isLoading = input<boolean>(false);
  isEmpty = input<boolean>(false);

  // Obtenemos la referencia del modal como un Signal
  // #modalBorrar es la referencia que pondremos en el HTML
  modalBorrar = viewChild<ConfirmModalComponent>('modalEliminar');

  medico = signal<Medico | null>(null);
  confirmarEliminacion = output<Medico>();

  abrirModal(medico: Medico) {
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
}

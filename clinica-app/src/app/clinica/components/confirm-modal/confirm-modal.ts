import { CommonModule } from '@angular/common';
import {
  ChangeDetectionStrategy,
  Component,
  ElementRef,
  input,
  output,
  viewChild,
} from '@angular/core';

@Component({
  selector: 'app-confirm-modal',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './confirm-modal.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ConfirmModalComponent {
  title = input<string>('Confirmar');
  message = input<string>('¿Estás seguro?');
  btnText = input<string>('Aceptar');
  // Para cambiar a btn-info, btn-success, etc).
  btnColor = input<string>('btn-error');

  onConfirm = output<void>();

  // La nueva forma de obtener la referencia del DOM con Signals
  // Esto devuelve un Signal que contiene la ElementRef
  modalElement = viewChild<ElementRef<HTMLDialogElement>>('modalElement');

  // Métodos públicos
  open() {
    // Al ser un signal, accedemos con () y luego al nativeElement
    this.modalElement()?.nativeElement.showModal();
  }

  close() {
    this.modalElement()?.nativeElement.close();
  }

  confirmar() {
    this.onConfirm.emit();
    this.close();
  }
}

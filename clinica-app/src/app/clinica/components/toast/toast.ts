import { CommonModule } from '@angular/common';
import {
  ChangeDetectionStrategy,
  Component,
  input,
  output,
  signal,
} from '@angular/core';

@Component({
  selector: 'app-toast',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './toast.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ToastComponent {
  message = input<string>('');
  type = input<'alert-success' | 'alert-error' | 'alert-info'>('alert-info');

  // Signal interno para controlar la visibilidad
  isVisible = signal(false);
  onClose = output<void>();

  show() {
    this.isVisible.set(true);

    // Auto-ocultar después de 5 segundos
    setTimeout(() => {
      this.close();
    }, 5000);
  }

  close() {
    this.isVisible.set(false);
    this.onClose.emit();
  }
}

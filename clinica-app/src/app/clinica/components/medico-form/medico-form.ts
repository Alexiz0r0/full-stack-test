import {
  ChangeDetectionStrategy,
  Component,
  effect,
  inject,
  input,
  output,
} from '@angular/core';
import {
  FormBuilder,
  FormGroup,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';

import { v4 as uuidv4 } from 'uuid';

@Component({
  selector: 'app-medico-form',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './medico-form.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class MedicoFormComponent {
  onCancelar = output<boolean>();

  private fb = inject(FormBuilder);

  // Recibimos la data como un Signal input
  // Si viene con datos, estamos en modo edición; si no, en creación.
  data = input<any>(null);

  onGuardar = output<any>();

  form: FormGroup = this.fb.group({
    idMedico: ['', Validators.required],
    nombre: ['', Validators.required],
    especialidad: ['', Validators.required],
    numColegiatura: ['', Validators.required],
  });

  constructor() {
    // Reaccionamos cuando el input 'data' cambie
    effect(() => {
      const medico = this.data();
      if (medico) {
        // patchValue llena el formulario con los campos que coincidan
        this.form.patchValue(medico);
      } else {
        this.form.reset();
        this.form.get('idMedico')?.setValue(uuidv4());
      }
      this.form.get('idMedico')?.disable();
    });
  }

  enviar(): void {
    if (this.form.valid) {
      // Usamos getRawValue() por si deshabilitamos el campo ID (para que lo incluya)
      this.onGuardar.emit(this.form.getRawValue());
      this.cancelar();
    } else {
      this.form.markAllAsTouched();
    }
  }

  cancelar() {
    this.onCancelar.emit(true);
  }

  isInvalid(fieldName: string): boolean {
    const control = this.form.get(fieldName);
    return !!(control && control.invalid && (control.dirty || control.touched));
  }
}

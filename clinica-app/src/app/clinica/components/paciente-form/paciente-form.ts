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
  selector: 'paciente-form',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './paciente-form.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class PacienteFormComponent {
  onCancelar = output<boolean>();

  private fb = inject(FormBuilder);

  // Recibimos la data como un Signal input
  // Si viene con datos, estamos en modo edición; si no, en creación.
  data = input<any>(null);

  onGuardar = output<any>();

  form: FormGroup = this.fb.group({
    idPaciente: ['', Validators.required],
    nombre: ['', Validators.required],
    fechaNacimiento: ['', Validators.required],
    sexo: ['', Validators.required],
    observaciones: ['', Validators.required],
  });

  constructor() {
    // Reaccionamos cuando el input 'data' cambie
    effect(() => {
      const paciente = this.data();
      if (paciente) {
        // patchValue llena el formulario con los campos que coincidan
        this.form.patchValue(paciente);
      } else {
        this.form.reset();
        this.form.get('idPaciente')?.setValue(uuidv4());
      }
      this.form.get('idPaciente')?.disable();
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

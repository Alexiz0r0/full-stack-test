import {
  ChangeDetectionStrategy,
  Component,
  input,
  model,
  output,
} from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-search-input',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './search-input.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SearchInputComponent {
  placeholder = input('Buscar');

  // model() permite sincronizar el valor con el padre automáticamente
  query = model('');

  value = output<string>();

  buscar() {
    this.value.emit(this.query());
  }
}

package com.soft.io.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.soft.io.model.ApiCustomResponse;
import com.soft.io.model.ErrorResponse;

@ControllerAdvice
public class GlobalExceptionHandler {

	@ExceptionHandler(Exception.class)
	public ResponseEntity<ApiCustomResponse> handleAllExceptions(Exception ex) {
		String errorMessage = ex.getMessage();
		HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;
		String userMessage = "Error interno en el servidor";

		// Capturar errores personalizados de Oracle (ORA-20001 al 20999)
		if (errorMessage.contains("ORA-20")) {
			// Extraer el mensaje limpio: "Médico no encontrado para eliminar"
			userMessage = extraerMensajeOracle(errorMessage);

			// Si el error es de "No encontrado", devolvemos 404, si no 400
			if (errorMessage.contains("ORA-20002") || errorMessage.contains("ORA-20003")) {
				status = HttpStatus.NOT_FOUND;
			} else {
				status = HttpStatus.BAD_REQUEST;
			}
		}

		if (errorMessage.contains("ORA-02292")) {
			status = HttpStatus.CONFLICT;
			userMessage = "No se puede eliminar el registro porque tiene información asociada (Citas/Historias).";
		}

		ErrorResponse error = new ErrorResponse(status.value(), userMessage, ex.getClass().getSimpleName(),
				System.currentTimeMillis());

		ApiCustomResponse response = ApiCustomResponse.builder().message(errorMessage).success(false).data(error)
				.build();

		return new ResponseEntity<>(response, status);
	}

	private String extraerMensajeOracle(String msg) {
		try {
			// Formato típico: ORA-20002: Mensaje... ORA-06512...
			return msg.split("\n")[0].split(":")[1].trim();
		} catch (Exception e) {
			return "Error en base de datos: " + msg;
		}
	}

}

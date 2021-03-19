package dominio

import java.time.LocalDateTime
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter

@Accessors
abstract class Pregunta extends Entity {

	String descripcion
	Usuario autor
	String respuestaCorrecta
	@JsonIgnore LocalDateTime fechaHoraCreacion
	Set<String> opciones = new HashSet<String>
	// static String DATE_PATTERN = "dd-MM-yyyy h:mm a"
	static String DATE_PATTERN = "yyyy-MM-dd h:mm a"

	@JsonProperty("fechaHoraCreacion")
	def setFecha(String fecha) {
		this.fechaHoraCreacion = LocalDateTime.parse(fecha, formatter)
	}

	@JsonProperty("fechaHoraCreacion")
	def getFechaAsString() {
		formatter.format(this.fechaHoraCreacion)
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}

	def estaActiva() {
		fechaHoraCreacion.plusMinutes(5).isBefore(LocalDateTime.now())
	}

	def void gestionarRespuesta(String opcionElegida, Usuario usuario)

	def sumarPuntosSiEsCorrecta(String opcionElegida, Usuario usuario, int puntos) {
		if (this.esCorrecta(opcionElegida)) {
			usuario.sumarPuntaje(puntos)
		}
	}

	def boolean esCorrecta(String opcionElegida) {
		this.respuestaCorrecta.equals(opcionElegida)
	}

	override cumpleCondicionDeBusqueda(String valorBusqueda) {
		descripcion.contains(valorBusqueda)
	}

	def agregarOpcion(String opcion) {
		opciones.add(opcion)
	}
}

class Simple extends Pregunta {

	val puntos = 10

	override gestionarRespuesta(String opcionElegida, Usuario usuario) {
		this.sumarPuntosSiEsCorrecta(opcionElegida, usuario, puntos)
	}
}

class DeRiesgo extends Pregunta {

	val puntos = 100
	val puntosRestados = 50

	override gestionarRespuesta(String opcionElegida, Usuario usuario) {
		this.sumarPuntosSiEsCorrecta(opcionElegida, usuario, puntos)
		if (respondioAntesDeUnMinuto && this.esCorrecta(opcionElegida)) {
			autor.restarPuntaje(puntosRestados)
		}
	}

	def respondioAntesDeUnMinuto() {
		fechaHoraCreacion.plusMinutes(1).isBefore(LocalDateTime.now)
	}
}

class Solidaria extends Pregunta {
	@Accessors
	int puntosDonados

	override gestionarRespuesta(String opcionElegida, Usuario usuario){
		this.sumarPuntosSiEsCorrecta(opcionElegida, usuario, puntosDonados)
	}
}

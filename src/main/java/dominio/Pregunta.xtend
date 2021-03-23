package dominio

import java.time.LocalDateTime	
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonTypeName
import java.time.LocalDate

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY)
@JsonSubTypes(
    @JsonSubTypes.Type(value = Simple, name = "simple"),
    @JsonSubTypes.Type(value = DeRiesgo, name = "deRiesgo"),
    @JsonSubTypes.Type(value = Solidaria, name = "solidaria")
)
@Accessors
abstract class Pregunta extends Entity {
	
	int puntos
	String descripcion
	Usuario autor
	String respuestaCorrecta
	@JsonIgnore LocalDateTime fechaHoraCreacion
	Set<String> opciones = new HashSet<String>
	static String DATE_PATTERN = "yyyy-MM-dd HH:mm:ss"

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
		fechaHoraCreacion.plusMinutes(5).isAfter(LocalDateTime.now())
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

@JsonTypeName("simple")
class Simple extends Pregunta {
	
	new() {
		this.puntos = 10
	}

	override gestionarRespuesta(String opcionElegida, Usuario usuario) {
		this.sumarPuntosSiEsCorrecta(opcionElegida, usuario, puntos)
	}
}

@JsonTypeName("deRiesgo")
class DeRiesgo extends Pregunta {

	new() {
		this.puntos = 100
	}
	
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

@JsonTypeName("solidaria")
class Solidaria extends Pregunta {

	new(int puntos) {
		this.puntos = puntos
	}

	override gestionarRespuesta(String opcionElegida, Usuario usuario) {
		this.sumarPuntosSiEsCorrecta(opcionElegida, usuario, this.puntos)
	}
}

@Accessors
class Respuesta {
	@JsonIgnore LocalDate fechaRespuesta
	int puntos
	String pregunta 
	static String DATE_PATTERN = "yyyy-MM-dd"
	
	@JsonProperty("fechaRespuesta")
	def setFecha(String fecha) {
		this.fechaRespuesta = LocalDate.parse(fecha, formatter)
	}

	@JsonProperty("fechaRespuesta")
	def getFechaAsString() {
		formatter.format(this.fechaRespuesta)
	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
}

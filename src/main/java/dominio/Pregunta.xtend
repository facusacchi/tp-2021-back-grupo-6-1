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
import java.time.LocalDate

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
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
	
	override cumpleCondicionDeBusqueda(String valorBusqueda) {
		descripcion.toLowerCase.contains(valorBusqueda.toLowerCase)
	}	

	def boolean esCorrecta(String opcionElegida) {
		this.respuestaCorrecta.toLowerCase == opcionElegida.toLowerCase 
	}
	
	def agregarOpcion(String opcion) {
		opciones.add(opcion)
	}
	
	def void gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		user.sumarPuntaje(puntos)
		respuesta.puntos = puntos
	}
}

//@JsonTypeName("simple")
class Simple extends Pregunta {
	new() {
		this.puntos = 10
	}
}

//@JsonTypeName("deRiesgo")
class DeRiesgo extends Pregunta {
	int puntosRestados
	
	new() {
		this.puntos = 100
		this.puntosRestados = 50
	}
	
	
	override gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		super.gestionarRespuestaDe(user, respuesta)
		if(user.respondioAntesDeUnMinuto(this)) {
			this.autor.restarPuntaje(puntosRestados)
		}
	}
}

//@JsonTypeName("solidaria")
class Solidaria extends Pregunta {
	new(int puntos) {
		this.puntos = puntos
	}
	
	override gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		super.gestionarRespuestaDe(user, respuesta)
		this.autor.restarPuntaje(puntos)
	}
}

<<<<<<< HEAD
@Accessors
class Respuesta {
	
	@JsonIgnore LocalDate fechaRespuesta
	@JsonIgnore int puntos
	String pregunta
	String opcionElegida 
	static String DATE_PATTERN = "yyyy-MM-dd"
	
//	@JsonProperty("fechaRespuesta")
//	def setFecha(String fecha) {
//		this.fechaRespuesta = LocalDate.parse(fecha, formatter)
//	}
//
//	@JsonProperty("fechaRespuesta")
//	def getFechaAsString() {
//		formatter.format(this.fechaRespuesta)
//	}
=======
>>>>>>> 8c52bc21af31b2d4b53db33d9c3ca2a55fb2ca9c


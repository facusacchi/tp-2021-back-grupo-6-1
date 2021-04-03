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
import com.fasterxml.jackson.annotation.JsonView
import serializer.View
import exceptions.NullFieldException
import exceptions.NullCollectionException
import exceptions.BusinessException

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes(
    @JsonSubTypes.Type(value = Simple, name = "simple"),
    @JsonSubTypes.Type(value = DeRiesgo, name = "deRiesgo"),
    @JsonSubTypes.Type(value = Solidaria, name = "solidaria")
)
@Accessors
abstract class Pregunta extends Entity {
	
	@JsonView(View.Pregunta.Table)
	int puntos
	@JsonView(View.Pregunta.Busqueda, View.Pregunta.Table)
	String descripcion
	@JsonView(View.Pregunta.Table, View.Pregunta.Busqueda)
	Usuario autor
	@JsonView(View.Pregunta.Table)
	String respuestaCorrecta
	@JsonIgnore
	LocalDateTime fechaHoraCreacion
	@JsonView(View.Pregunta.Table)
	Set<String> opciones = new HashSet<String>
	static String DATE_PATTERN = "yyyy-MM-dd HH:mm:ss"
	@JsonView(View.Pregunta.Table)
	Boolean activa

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
	
	def validar() {
		if(descripcion === null || respuestaCorrecta === null) {
			throw new NullFieldException("Error al dejar campos nulos en la pregunta")
		}
		if(opciones.isEmpty) {
			throw new NullCollectionException("Error al dejar colecciones vacias en la pregunta")
		}
	}
}

class Simple extends Pregunta {
	new() {
		this.puntos = 10
	}
}

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

class Solidaria extends Pregunta {
	new() {
		this.puntos = puntos
	}
	
	override gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		super.gestionarRespuestaDe(user, respuesta)
		this.autor.restarPuntaje(puntos)
	}
	
	def validar(Usuario autor) {
		if(puntos > autor.puntaje) {
			throw new BusinessException("El puntaje asignado a la pregunta debe ser menor al puntaje actual del autor")
		}
	}
}


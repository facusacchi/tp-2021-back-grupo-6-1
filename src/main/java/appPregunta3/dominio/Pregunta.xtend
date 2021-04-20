package appPregunta3.dominio

import com.fasterxml.jackson.annotation.JsonIgnore	
import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeInfo
import com.fasterxml.jackson.annotation.JsonView
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.HashSet
import java.util.Set
import javax.persistence.Column
import javax.persistence.DiscriminatorColumn
import javax.persistence.DiscriminatorType
import javax.persistence.ElementCollection
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.Inheritance
import javax.persistence.InheritanceType
import javax.persistence.ManyToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import appPregunta3.serializer.View
import appPregunta3.dominio.Respuesta

@Entity
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes(#[
    @JsonSubTypes.Type(value = Simple, name = "simple"),
    @JsonSubTypes.Type(value = DeRiesgo, name = "deRiesgo"),
    @JsonSubTypes.Type(value = Solidaria, name = "solidaria")
])
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name="tipo_pregunta",    
                     discriminatorType=DiscriminatorType.STRING)
@Accessors
abstract class Pregunta {
	
	@Id @GeneratedValue
	@JsonView(#[View.Pregunta.Busqueda, View.Pregunta.Table])
	Long id
	
	@JsonView(View.Pregunta.Table)
	Integer puntos
	
	@JsonView(#[View.Pregunta.Busqueda, View.Pregunta.Table])
	@Column(length=150)
	String descripcion
	
	@ManyToOne(fetch=FetchType.LAZY)
	@JsonView(#[View.Pregunta.Table, View.Pregunta.Busqueda])
	Usuario autor
	
	@JsonView(View.Pregunta.Table)
	@Column(length=150)
	String respuestaCorrecta
	
	@JsonIgnore
	LocalDateTime fechaHoraCreacion
	
	@ElementCollection
	@JsonView(View.Pregunta.Table)
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
	
	def cumpleCondicionDeBusqueda(String valorBusqueda) {
		descripcion.toLowerCase.contains(valorBusqueda.toLowerCase)
	}	
	
	def agregarOpcion(String opcion) {
		opciones.add(opcion)
	}
	
	def void gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		user.sumarPuntaje(puntos)
		respuesta.puntos = puntos
	}
	
}

@Entity
class Simple extends Pregunta {
	new() {
		this.puntos = 10
	}
}

@Entity
class DeRiesgo extends Pregunta {
	
	@Transient
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

@Entity
class Solidaria extends Pregunta {
	new() {
		this.puntos = puntos
	}
	
	override gestionarRespuestaDe(Usuario user, Respuesta respuesta) {
		super.gestionarRespuestaDe(user, respuesta)
		this.autor.restarPuntaje(puntos)
	}
	
}


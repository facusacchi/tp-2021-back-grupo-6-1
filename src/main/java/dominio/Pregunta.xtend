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

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY)
@JsonSubTypes(
    @JsonSubTypes.Type(value = Simple, name = "simple"),
    @JsonSubTypes.Type(value = DeRiesgo, name = "deRiesgo"),
    @JsonSubTypes.Type(value = Solidaria, name = "solidaria")
)
@Accessors
abstract class Pregunta extends Entity{
	
	String descripcion
	Usuario autor
	String respuestaCorrecta
	@JsonIgnore LocalDateTime fechaHoraCreacion
	Set<String> opciones = new HashSet<String>
	//static String DATE_PATTERN = "dd-MM-yyyy h:mm a"
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
	
	override cumpleCondicionDeBusqueda(String valorBusqueda) {
		descripcion.contains(valorBusqueda)
	}
	
	def agregarOpcion(String opcion) {
		opciones.add(opcion)
	}
}

@JsonTypeName("simple")
class Simple extends Pregunta {

	override gestionarRespuesta(String opcionElegida, Usuario usuario) {
		if (this.respuestaCorrecta.equals(opcionElegida)) {
			usuario.sumarPuntaje(10)
		}
	}
}

@JsonTypeName("deRiesgo")
class DeRiesgo extends Pregunta {

	override gestionarRespuesta(String opcionElegida, Usuario usuario) {
		if (this.respuestaCorrecta.equals(opcionElegida)){
			usuario.sumarPuntaje(100)
			if (respondioAntesDeUnMinuto) {
				autor.restarPuntaje(50)
			}
		}
	}

	def respondioAntesDeUnMinuto() {
		fechaHoraCreacion.plusMinutes(1).isBefore(LocalDateTime.now)
	}
}

@JsonTypeName("solidaria")
class Solidaria extends Pregunta {
	@Accessors
	int donacion

	override gestionarRespuesta(String opcionElegida, Usuario usuario) {
		if (this.respuestaCorrecta.equals(opcionElegida)) {
			usuario.sumarPuntaje(donacion)
		}
	}
}

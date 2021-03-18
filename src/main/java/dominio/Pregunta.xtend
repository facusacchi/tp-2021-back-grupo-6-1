package dominio

import java.time.LocalDateTime
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter

@Accessors
abstract class Pregunta extends Entity{
	
	String descripcion
	Usuario autor
	@JsonIgnore LocalDateTime fechaHoraCreacion
	Set<Opcion> respuestas = new HashSet<Opcion>
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
		fechaHoraCreacion.plusMinutes(5) > LocalDateTime.now()
	}

	def void gestionarRespuesta(Opcion opcion, Usuario usuario)
	
	override cumpleCondicionDeBusqueda(String valorBusqueda) {
		descripcion.contains(valorBusqueda)
	}
	
	def agregarRespuesta(Opcion respuesta) {
		respuestas.add(respuesta)
	}

}

class Simple extends Pregunta {

	override gestionarRespuesta(Opcion opcion, Usuario usuario) {
		if (opcion.esCorrecta) {
			usuario.sumarPuntaje(10)
		}
	}
}

class DeRiesgo extends Pregunta {

	override gestionarRespuesta(Opcion opcion, Usuario usuario) {
		if (opcion.esCorrecta) {
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

class Solidaria extends Pregunta {
	@Accessors
	int donacion

	override gestionarRespuesta(Opcion opcion, Usuario usuario) {
		if (opcion.esCorrecta) {
			usuario.sumarPuntaje(donacion)
		}
	}
}

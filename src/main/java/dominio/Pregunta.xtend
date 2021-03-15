package dominio

import java.time.LocalDateTime
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Pregunta {

	String pregunta
	Usuario autor
	LocalDateTime fechaHoraCreacion
	Set<Opcion> opciones = new HashSet<Opcion>

	def estaActiva() {
		fechaHoraCreacion.plusMinutes(5) > LocalDateTime.now()
	}

	def void gestionarRespuesta(Opcion opcion, Usuario usuario)

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
	
	int donacion

	override gestionarRespuesta(Opcion opcion, Usuario usuario) {
		if (opcion.esCorrecta) {
			usuario.sumarPuntaje(donacion)
		}
	}
}

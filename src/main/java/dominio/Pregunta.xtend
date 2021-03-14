package dominio

import java.time.LocalDateTime
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Pregunta {

	String pregunta
	Usuario autor
	LocalDateTime fechaHoraCreacion
	Set<Opcion> opciones = new HashSet<Opcion>

	def estaActiva() {
		fechaHoraCreacion.plusMinutes(5) > LocalDateTime.now()
	}

}

class Simple extends Pregunta {
	
	
}

class DeRiesgo extends Pregunta {
}

class Solidaria extends Pregunta {
}

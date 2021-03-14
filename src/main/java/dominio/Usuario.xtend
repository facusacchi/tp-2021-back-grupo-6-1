package dominio

import java.util.HashSet
import java.util.Set
import java.time.LocalDate
import java.time.LocalDateTime

class Usuario {
	
	String nombre
	String apellido
	LocalDate fechaDeNacimiento
	String userName
	String password
	Set<Usuario> amigos = new HashSet<Usuario>
	Double puntaje
	
	def Pregunta crearPregunta(String _pregunta , Set<Opcion> _opciones) {
		new Pregunta => [
			pregunta = _pregunta
			autor = this
			fechaHoraCreacion = LocalDateTime.now()
			opciones = _opciones
		]
	}
}
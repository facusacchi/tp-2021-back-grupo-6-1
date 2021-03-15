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
	int puntaje
	
	def sumarPuntaje(int puntos) {
		puntaje += puntos
	}
	
	def restarPuntaje(int puntos) {
		puntaje -= puntos
	}
	
}
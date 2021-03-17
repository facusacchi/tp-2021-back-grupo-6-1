package dominio

import java.util.HashSet
import java.util.Set
import java.time.LocalDate
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Usuario extends Entity {
	
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
	
	override cumpleCondicionDeBusqueda(String valorBusqueda) {
		nombre.toLowerCase.contains(valorBusqueda.toLowerCase) || apellido.toLowerCase.equals(valorBusqueda.toLowerCase)
	}
	
}
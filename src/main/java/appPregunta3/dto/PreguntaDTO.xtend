package appPregunta3.dto

import java.util.Set
import java.util.HashSet
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors(PUBLIC_GETTER)
class PreguntaDTO {
	
	Long id
	Integer puntos
	String descripcion
	String autor
	Set<String> opciones = new HashSet<String>
	Boolean activa
	
	new(Long id, Integer puntos, String descripcion, String autor, Set<String> opciones, Boolean activa) {
		this.id = id
		this.puntos = puntos
		this.descripcion = descripcion
		this.autor = autor
		this.opciones = opciones
		this.activa = activa
	}
}

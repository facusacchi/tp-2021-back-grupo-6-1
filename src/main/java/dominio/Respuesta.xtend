package dominio

import org.eclipse.xtend.lib.annotations.Accessors	
import com.fasterxml.jackson.annotation.JsonIgnore
import java.time.LocalDate
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter
import com.fasterxml.jackson.annotation.JsonView
import serializer.View

@Accessors
class Respuesta {
	
	@JsonIgnore LocalDate fechaRespuesta
	@JsonView(View.Usuario.Perfil)
	int puntos
	@JsonView(View.Usuario.Perfil)
	String pregunta 
	String opcionElegida
	static String DATE_PATTERN = "yyyy-MM-dd"
	
	@JsonView(View.Usuario.Perfil)
	@JsonProperty("fechaRespuesta")
	def getFechaAsString() {
		formatter.format(this.fechaRespuesta)
	}
// esto se setea automaticamente cuando el usuario responde
//	@JsonProperty("fechaRespuesta")
//	def setFecha(String fecha) {
//		this.fechaRespuesta = LocalDate.parse(fecha, formatter)
//	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
}
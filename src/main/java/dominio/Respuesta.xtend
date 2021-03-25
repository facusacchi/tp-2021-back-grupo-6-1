package dominio

import org.eclipse.xtend.lib.annotations.Accessors	
import com.fasterxml.jackson.annotation.JsonIgnore
import java.time.LocalDate
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.format.DateTimeFormatter

@Accessors
class Respuesta {
	
	@JsonIgnore LocalDate fechaRespuesta
	int puntos
	String pregunta 
	String opcionElegida
	static String DATE_PATTERN = "yyyy-MM-dd"
	
//	@JsonProperty("fechaRespuesta")
//	def setFecha(String fecha) {
//		this.fechaRespuesta = LocalDate.parse(fecha, formatter)
//	}
//
//	@JsonProperty("fechaRespuesta")
//	def getFechaAsString() {
//		formatter.format(this.fechaRespuesta)
//	}

	def formatter() {
		DateTimeFormatter.ofPattern(DATE_PATTERN)
	}
}
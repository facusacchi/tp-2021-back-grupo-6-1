package dominio

import org.eclipse.xtend.lib.annotations.Accessors
import serializer.View
import com.fasterxml.jackson.annotation.JsonView

@Accessors
abstract class Entity {
	@JsonView(View.Pregunta.Busqueda, View.Pregunta.Table, View.Usuario.Login)
	int id

	def boolean cumpleCondicionDeBusqueda(String valorBusqueda)
}

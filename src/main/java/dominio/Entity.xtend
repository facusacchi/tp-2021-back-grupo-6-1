package dominio

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Entity {
	int id

	def boolean cumpleCondicionDeBusqueda(String valorBusqueda)
}

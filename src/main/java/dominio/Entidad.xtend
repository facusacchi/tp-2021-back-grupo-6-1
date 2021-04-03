package dominio

interface Entidad {
//	@JsonView(View.Pregunta.Busqueda, View.Pregunta.Table)
//	int id

	def boolean cumpleCondicionDeBusqueda(String valorBusqueda)
}

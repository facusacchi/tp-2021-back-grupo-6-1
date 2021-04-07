//package repos
//
//import dominio.Entity
//import java.util.HashSet
//import java.util.List
//import java.util.Set
//import org.eclipse.xtend.lib.annotations.Accessors
//
//@Accessors
//class Repositorio<T extends Entity> {
//
//	Set<T> objects = new HashSet<T>
//	int id = 1
//
//	def create(T object) {
//		object.id = id
//		objects.add(object)
//		id++
//	}
//
//	def delete(T object) {
//		objects.remove(object)
//	}
//
//	def update(T object) {
//		val elementoDelRepo = this.getById(object.id.toString)
//		if (elementoDelRepo === null) {
//			throw new Exception("No existe elemento con el id " + object.id)
//		}
//		delete(elementoDelRepo)
//		objects.add(object)
//	}
//
//	def getById(String id) {
//		val idInt = Integer.parseInt(id)
//		objects.findFirst[object|object.id == idInt]
//	}
//
//	def List<T> search(String value) {
//		objects.filter[object|object.cumpleCondicionDeBusqueda(value)].toList
//	}
//
//	def Set<T> allInstances() {
//		return this.objects;
//	}
//
//}

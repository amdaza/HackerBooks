# Respuestas a las preguntas

## Procesado JSON
* Ten en cuenta que el método *NSJSONSerialization* devuelve un parámetro *AnyObject* que puede contener tanto un *Array* de *Dictionary* como un *Dictionary*. Mira en la ayuda el método *isKindOfClass:* y cómo usarlo para saber qué te ha devuelto exactamente. ¿En qué otros modos podemos trabajar? ¿is, as?

Dicho método serviría para comprobar si un objeto es casteable a una clase en concreto. En la práctica he utilizado la misma forma que usamos en las clases:

		if let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data,
        	options: NSJSONReadingOptions.MutableContainers) as? JSONArray, ...

Así, sólo se gestiona el JSON si el "data" es casteable a un *JSONArray*. Si no, se lanza un error

## Persistencia de datos
* ¿Dónde guardarías los datos de portada y los pdfs?

Al tratarse de datos que ocupan espacio, y que pueden ser eliminados si el dispositivo necesita dicho espacio, se guardan en la carpeta Cache de la Sandbox.

* La propiedad booleana de *AGTBook* *isFavorite* se debe guardar y recuperar de alguna forma. ¿Se te ocurre más de una? Explica la decisión de diseño que hayas tomado

Para guardar los libros favoritos, he usado *NSUserDefaults*. Más concretamente, un array con el index de cada libro seleccionado como favorito. Guardo sólo el index para que ocupe lo menos posible.
Se podrían también guardar estos datos en un fichero, ya sea un json o con algún otro formato.
También se podría usar Core Data para guardar estos datos.

## Eventos

* Cuando cambia el valor de la propiedad isFavourite de un *AGTBook*, la tabla deberá reflejar ese hecho. ¿Cómo enviarías información de un *AGTBook* a un *AGTLibraryTableViewController*? ¿Se te ocurre más de una forma de hacerlo? ¿Cuál te parece mejor? Explica tu elección.

Para este caso, he usado notificaciones, puesto que tanto la tabla como la librería (*AGTLibrary*) necesitan saber de este cambio para actualizarse. Me pareció más fácil que hacer un delegado y también una notificación, si la notificación iba a ser necesaria.

* ¿El uso de *reloadData* es una aberración desde el punto de rendimiento? ¿Hay alguna forma alternativa?

Como reloadData sólo carga las celdas visibles, no supone tanto problema de rendimiento. Quizá se podría hacer cada cambio por programación, pero al ser tantos detalles, no creo que merezca la pena ir a cada celda cada vez que camiba un detalle, con sus respectivas comprobaciones.

* Cuando el usuario cambia en la tabla el libro seleccionado, el *AGTSimplePDFViewController* debe actualizarse. ¿Cómo lo harías?

Aprovechando la notificación *BookDidChangeNotification* ya creada para el *BookViewController*. Dicha notificación avisa cuando un elemento en la tabla ha sido seleccionado. Basta con suscribir el *PDFViewController* a la misma notificación, y actualizarlo.

## Comentarios

### Versiones

La práctica se ha realizado usando XCode 7.2.1. Como la versión de swift cambia, puede que haya algún código deprecado. Lo único que noté distinto durante las clases fue la sintaxis del selector al añadir observador, por ejemplo:

		// Versión del profesor
		nc.addObserver(self, selector: @selector(characterDidChange),
			name: CharacterDidChangeNotification, object: nil)

		// Mi versión
		nc.addObserver(self, selector: "characterDidChange:",
		 	name: CharacterDidChangeNotification, object: nil)
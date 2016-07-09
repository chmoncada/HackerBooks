#Practica Fundamentos iOS KeepCoding - HackerBooks

Un lector de libros en PDF para iPhone y iPad. Los libros se reciben en un JSON que se descarga de una URL.  Los PDFs se descargan de un enlace ofrecido. 

Se ha creado la clase AGTBook, que contiene los datos del libro. Después se ha creado una clase AGTLibrary que contiene los libros.

## isKindOfClass 

Indica si un objeto hereda de una clase. Podriamos hacer un cast (**as**), el cast permite cambiar de un AnyObject a un objeto más especifico. Después podemos emplear una conversión forzada, para ello empleamos el comando **is**

Para procesar el JSON he empleado una convesion a opcional (**as?**) empleando si da un formato incorrecto ***nil***.

## Grabación de datos

Se han guardado los datos en el Sandbox de la app.  Para eso se ha implementado funciones que hacer un chequeo si el archivo ya existe y si no existe, lo descarga y lo guarda en el sandbox.

Por el tamaño de los archivos se uso la sandbox, podriamos haber usado para el JSON el NSUsersDefaults, pero se opto por el Sandbox


## Favoritos

Para implementar la funcionalidad de favoritos se creo un Array, que se guardaba en NSUserDefauls, con los titulos de los libros que fueron seleccionados como favoritos.

Otras formas de hacerlo:

* Hacer que favorito sea un "nuevo tag" y añadirlo a la propiedad tags de cada libro
* Guardar los AGTBook escogidos


Este Array se carga en la creacion del AGTLibrary y modifica en el caso de ser favorito una propiedad dentro del AGTBook.

Para la tabla de libros, se opto por hacer que Favoritos sea una "sección", modificando las funciones del data source para considerar esa "nueva" seccion y los libros que la componen.

La vista de detalle del libro enviaba una Notificacion de cambio que era recibida por la Tableview.  Podria haberse hecho implementando un delegado.  Se opto por la notificacion ya que no significaba mucho cambio en los metodos

## Actualización de datos en la tabla

Se ha empleado la actualización de reloadData(). El método reloadData recarga unicamente las celdas que se ven en pantalla por lo que no lo veo tan aberrante.  Tambien sirve para refrescar la seccion de favoritos que sino se recarga el data source solo se refrescaria cuando se inicie de nuevo la app

Formas alternativas:

* Podriamos haber hecho notificaciones que la capture la TableViewCellController, un filtro respecto a que modelo usa y que libro ha cambiado y que modifique el valor de isFavorite y recargar

Podria valer la pena cuando no cambia los componentes de la tabla y solo alguna propiedad como el color de una estrella

## Controlador de PDF

La actualizacion de vista del pdf se hizo mediante una notificacion de la Tableview a la vista del PDF

## Extras

### Funcionalidades Extras
1. Colocar una barra de progreso de descarga del PDF, ya que puede tomar bastante tiempo y ver el activityIndicator tanto tiempo no da mucha info
2. Poder descargar el pdf desde el mismo tableviewcell con un indicador
3. Mejorar el visor de pdf con anotaciones, bookmarks y demas
4. Poder crear tus propias categorias
5. Poder añadir tus propios libros y poder borrar los que no queremos

### Otras versiones

1. Un recetario, coctelario
2. Una tienda de compra de PDFs, videojuegos, etc
3. Un bloc de anotaciones agrupadas por categorias definidas por el usuario
4. Una guia de restaurantes agrupados por tipo, distancia, busqueda por nombre y en el detail view la ficha del restaurante y una vista de mapa de ubicacion





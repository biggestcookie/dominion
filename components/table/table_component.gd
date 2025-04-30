class_name TableComponent
extends VBoxContainer

@onready var header: TableRow = $TableHeader
@onready var scroll_container: ScrollContainer = $ScrollContainer

var table_headers: Array[String] = []
var table_data: Array[Array] = []


func _ready() -> void:
	# Initialize the table with headers and data
	header.data = table_headers

	for row_data in table_data:
		var row: TableRow = preload("res://components/table/table_row.tscn").instantiate()
		row.data = row_data
		scroll_container.add_child(row)

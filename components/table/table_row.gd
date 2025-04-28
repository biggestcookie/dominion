class_name TableRow
extends HBoxContainer

@export var is_header: bool = false
var row_data: Array[String] = []:
	set(data):
		update_table_row(data)


func update_table_row(data: Array[String]) -> void:
	row_data = data # Set the row_data to the provided data
	# Delete all children
	for child in get_children():
		remove_child(child)
		child.queue_free()

	for index in range(row_data.size()):
		var title := row_data[index]
		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_right", 60)
		
		var label := Label.new()
		label.text = title
		label.clip_text = true
		if index == 0:
			margin.add_theme_constant_override("margin_bottom", 10)
			label.size_flags_horizontal = SIZE_EXPAND_FILL
			label.add_theme_constant_override("outline_width", 1)

		margin.add_child(label)
		add_child(margin)

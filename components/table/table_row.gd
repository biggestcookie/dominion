class_name TableRow
extends HBoxContainer

@export var is_header: bool = false

var data: Array[String] = []:
	set(value):
		data = value
		_update_table_row()


func _update_table_row() -> void:
	# Remove extra children if there are more than needed
	while get_child_count() > data.size():
		remove_child(get_child(get_child_count() - 1))

	# Use existing MarginContainers, duplicate last if needed
	for index in range(data.size()):
		var margin_container: MarginContainer
		var child_count := get_child_count()
		if index >= child_count:
			var last_margin := get_child(child_count - 1) as MarginContainer
			margin_container = last_margin.duplicate()
			add_child(margin_container)
		else:
			margin_container = get_child(index) as MarginContainer
		_update_margin_container(margin_container, index)


func _update_margin_container(margin_container: MarginContainer, index: int) -> void:
	var label: Label = margin_container.get_child(0)
	label.text = data[index]
	label.clip_text = true

	if is_header and index == data.size() - 1:
		margin_container.add_theme_constant_override("margin_right", 68)
	else:
		margin_container.add_theme_constant_override("margin_right", 60)

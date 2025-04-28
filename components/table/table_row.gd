class_name TableRow
extends HBoxContainer

var header_titles: Array[String] = []

func _ready() -> void:
	for index in header_titles.size():
		var title := header_titles[index]
		var margin := MarginContainer.new()
		margin.add_theme_constant_override("margin_right", 60)
		
		var label := Label.new()
		label.text = title
		label.clip_text = true 
		if index == 0:
			label.size_flags_horizontal = SIZE_EXPAND_FILL

		# Set label settings
		# If header, add 1px outline

		margin.add_child(label)
		add_child(margin)

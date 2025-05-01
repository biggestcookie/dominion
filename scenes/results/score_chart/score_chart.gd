class_name ScoreChart
extends Panel

@onready var chart_scn: PackedScene = load("res://addons/easy_charts/control_charts/chart.tscn")
var chart: Chart


func plot_new_chart(score: Score) -> void:
	if chart != null:
		chart.queue_free()
	chart = chart_scn.instantiate()
	var plots := calculate_plots(score)
	# var cp := set_chart_properties()


func set_chart_properties(plots: Dictionary) -> ChartProperties:
	var cp := ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.title = "Press velocity over time"
	cp.x_label = "Time (seconds)"
	cp.y_label = "Presses per second"
	cp.x_scale = 10
	cp.y_scale = plots.y.max() + 1
	cp.interactive = false
	return cp


func calculate_plots(score: Score) -> Dictionary:
	pass

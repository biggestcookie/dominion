class_name ScoreChart
extends Panel

@onready var chart_scn: PackedScene = load("res://addons/easy_charts/control_charts/chart.tscn")

var chart: Chart


func plot_new_chart(score: Score) -> void:
	if chart != null:
		chart.queue_free()
	chart = chart_scn.instantiate()
	add_child(chart)
	var plots := calculate_plots(score)
	var cp := _set_chart_properties(plots)
	var function := Function.new(
		plots.x, plots.y, "Presses per second",
		{
			color = Color("#36a2eb"),
			marker = Function.Marker.CIRCLE,
			type = Function.Type.LINE,
			interpolation = Function.Interpolation.SPLINE
		}
	)
	chart.set_x_domain(0, ceil(score.total_msec / 1000.0))
	chart.set_y_domain(0, plots.y.max() + 1)
	chart.plot([function], cp)
	set_process(false)


func calculate_plots(score: Score) -> Dictionary:
	var x_points: Array[float] = []
	var y_points: Array[float] = []
	var second := 1
	var press_count := 0

	# TODO: Make intervals larger than 1 second
	for tick in score.press_ticks:
		var tick_sec := (tick - score.start_msec) / 1000.0
		if tick_sec < second:
			press_count += 1
		else:
			x_points.append(second)
			y_points.append(press_count)
			second += 1
			press_count = 1
	x_points.append(second)
	y_points.append(press_count)
	return {"x": x_points, "y": y_points}


func _set_chart_properties(plots: Dictionary) -> ChartProperties:
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
	cp.x_scale = plots.x.max()
	cp.y_scale = plots.y.max() + 1
	cp.interactive = false
	return cp

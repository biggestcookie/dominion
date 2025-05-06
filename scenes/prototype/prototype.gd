extends Control

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

@onready var results: VBoxContainer = $Results
@onready var results_timer: Timer = $ResultsTimer
@onready var chart: Chart = $Results/Chart
@onready var presses_label: Label = $Results/PressesLabel
@onready var results_label: Label = $Results/ResultsLabel

var is_active := false
var is_displaying_results := false
var presses := 0
var timing_index := 0
var press_timing := Array()
var function: Function


func _ready() -> void:
	timer.timeout.connect(show_results)
	results_timer.timeout.connect(func() -> void:
		print("Results timer ended")
		is_displaying_results = false
		results_label.text = "Start mashing to try again"
	)
	label.show()
	results.hide()


func _physics_process(_delta: float) -> void:
	if !is_active and !is_displaying_results:
		if Input.is_action_just_released("mash"):
			start_mashing()
		return
	elif is_displaying_results:
		# Update results timer
		results_label.text = str(int(results_timer.time_left + 1))
		return
	label.text = str(int(timer.time_left + 1))
	if Input.is_action_just_released("mash"):
		presses += 1
		press_timing[timing_index] = true
	timing_index += 1


func start_mashing() -> void:
	print("Timer started")
	is_active = true
	label.show()
	results.hide()
	timer.start()
	presses = 0
	timing_index = 0
	press_timing.clear()
	press_timing.resize(600)
	press_timing.fill(false)


func show_results() -> void:
	print("Timer ended")
	is_active = false
	is_displaying_results = true
	results.show()
	label.hide()
	results_timer.start()
	presses_label.text = "Presses: %s" % [str(presses)]
	plot()


func plot() -> void:
	var plots := calculate_velocity(press_timing)
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
	function = Function.new(
		plots.x, plots.y, "Presses per second",
		{
			color = Color("#36a2eb"),
			marker = Function.Marker.CIRCLE,
			type = Function.Type.LINE,
			interpolation = Function.Interpolation.SPLINE
		}
	)
	chart.set_x_domain(0, 10)
	chart.set_y_domain(0, plots.y.max() + 1)
	chart.plot([function], cp)
	set_process(false)


func calculate_velocity(data: Array) -> Dictionary:
	var num_segments := 30 # 3 segments per second
	var segment_length := int(float(data.size()) / num_segments)
	var segment_time := (1.0 / 60.0) * segment_length
	var x_points: Array[float] = []
	var y_points: Array[float] = []
	
	for index in range(num_segments):
		var start := index * segment_length
		var end := start + segment_length
		var button_presses := 0
		for j in range(start, end):
			if data[j]:
				button_presses += 1
		x_points.append((1.0 / 60.0) * end)
		y_points.append(float(button_presses / segment_time))

	return {"x": x_points, "y": y_points}

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
	timer.timeout.connect(func() -> void:
		print("Timer ended")
		is_active = false
		is_displaying_results = true
		results.show()
		label.hide()
		results_timer.start()
	)
	results_timer.timeout.connect(func() -> void:
		print("Results timer ended")
		is_displaying_results = false
		results_label.text = "Start mashing to try again"
	)

	# Change this back
	label.hide()
	results.show()
	plot()


func _physics_process(_delta: float) -> void:
	if !is_active and !is_displaying_results:
		if Input.is_action_just_released("mash"):
			# Start mashing
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
		return
	elif is_displaying_results:
		# Wait for results
		presses_label.text = "Presses: %s" % [str(presses)]
		results_label.text = str(int(results_timer.time_left + 1))
		plot()
		return

	label.text = str(int(timer.time_left + 1))
	if Input.is_action_just_released("mash"):
		presses += 1
		press_timing[timing_index] = true
	timing_index += 1

func plot() -> void:
	var data := Array()
	data.resize(600)
	for i in range(data.size()):
		data[i] = randi() % 2 == 0
	var plots = calculate_velocity(data)
	# var x := ArrayOperations.multiply_float(range(-10, 11, 1), 0.5)
	# var y := ArrayOperations.multiply_int(ArrayOperations.cos(x), 20)
	var x := [
		0,
		1,
		2
	]

	var y := [
		0,
		1,
		1
	]
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.title = "Press speed"
	cp.x_label = "Time (seconds)"
	cp.y_label = "Presses"
	cp.x_scale = 10
	cp.y_scale = 5
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	# Let's add values to our functions
	function = Function.new(
		plots.x, plots.y, "Number of presses",
		{
			color = Color("#36a2eb"),
			marker = Function.Marker.CIRCLE,
			type = Function.Type.LINE,
			interpolation = Function.Interpolation.SPLINE
		}
	)
	
	# Now let's plot our data
	chart.plot([function], cp)
	
	# Uncommenting this line will show how real time data plotting works
	set_process(false)


func calculate_velocity(data: Array) -> Dictionary:
	var num_segments := 20
	var segment_length := data.size() / (num_segments)
	var x_points := [0]
	var y_points := [0]
	
	for index in range(segment_length, num_segments):
		var start := index
		var end := start + segment_length
		var button_presses := 0

		for j in range(start, end):
			if data[j]:
				button_presses += 1
		x_points.append(start)
		y_points.append(button_presses)

		# # Calculate the start and end of the current segment
		# var start := i * segment_length
		# var end := start + segment_length
		
		# # Count the number of 'true' elements in this segment
		# var button_presses := 0
		# for j in range(start, end):
		# 	if data[j]:
		# 		button_presses += 1
		
		# # X is the midpoint of the segment (in seconds)
		# var midpoint := (i + 5) * (10.0 / num_segments) # 10 seconds divided by 20 segments
		# x_points.append(midpoint)
		
		# # Y is the velocity, calculated as the count of button presses
		# y_points.append(button_presses)
	print(x_points)
	print(y_points)
	return {"x": x_points, "y": y_points}

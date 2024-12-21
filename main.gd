extends Control

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

@onready var results_timer: Timer = $ResultsTimer
@onready var results: VBoxContainer = $Results
@onready var presses_label: Label = $Results/PressesLabel
@onready var results_label: Label = $Results/ResultsLabel


var is_active := false
var is_displaying_results := false
var presses := 0

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
	label.show()
	results.hide()

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
		return
	elif is_displaying_results:
		# Wait for results
		presses_label.text = "Presses: %s" % [str(presses)]
		results_label.text = str(int(results_timer.time_left + 1))
		return

	label.text = str(int(timer.time_left + 1))
	if Input.is_action_just_released("mash"):
		presses += 1

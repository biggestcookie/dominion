class_name Gameplay
extends Node2D

@onready var countdown_timer: Timer = $Timers/Countdown
@onready var countdown_label: Label = $UI/Countdown
@onready var elapsed_label: Label = $UI/Elapsed
@onready var presses_label: Label = $UI/Presses

var is_active := false
var result: Result = null
var frame_time := 0.0

const frame_delta := 1.0 / 60.0


func _ready() -> void:
	Events.game_state_changed.connect(on_game_state_changed)
	countdown_timer.timeout.connect(start_mashing)

	# Delete this when not testing
	# start_countdown()


func _process(_delta: float) -> void:
	if not is_active:
		# Update countdown timer if game has not started yet
		countdown_label.text = str(int(
			countdown_timer.time_left + 1
		))
	else:
		# Update elapsed timer
		elapsed_label.text = get_elapsed_time(
			Time.get_ticks_msec(),
			result.start_msec
		)

func _physics_process(delta: float) -> void:
	if not is_active:
		# Update countdown timer, game has not started yet
		countdown_label.text = str(int(
			countdown_timer.time_left + 1
		))
		return

	if delta != frame_delta:
		print("ERROR: Running slower than 60 FPS")
		# Throw error to user?

	if Input.is_action_just_released("mash"):
		result.frame_presses.append(frame_time)
		presses_label.text = str(len(result.frame_presses))
		if len(result.frame_presses) >= 65:
			finish_game()
	# Increment frame time since game start
	frame_time += delta


func on_game_state_changed(new_state: Main.GameState, _result: Result) -> void:
	if new_state != Main.GameState.GAMEPLAY:
		return
	reset_game()
	start_countdown()
	
	
func reset_game() -> void:
	result = null
	frame_time = 0.0


func start_countdown() -> void:
	countdown_label.show()
	countdown_timer.start()


func start_mashing() -> void:
	countdown_label.hide()
	is_active = true
	result = Result.new(Time.get_ticks_msec())


func finish_game() -> void:
	is_active = false
	Events.game_state_changed.emit(Main.GameState.RESULTS, result)

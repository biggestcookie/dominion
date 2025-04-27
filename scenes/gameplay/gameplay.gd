class_name Gameplay
extends Node2D

@onready var countdown_timer: Timer = $Timers/Countdown
@onready var countdown_label: Label = $UI/Countdown
@onready var elapsed_label: Label = $UI/Elapsed
@onready var presses_label: Label = $UI/Presses

var is_active := false
var result: Result = null

const frame_delta := 1.0 / 60.0


func _ready() -> void:
	Events.game_state_changed.connect(on_game_state_changed)
	countdown_timer.timeout.connect(start_mashing)

	# If testing current scene
	if get_tree().current_scene == self:
		start_countdown()


func _process(_delta: float) -> void:
	if not is_active:
		# Update countdown timer if game has not started yet
		countdown_label.text = str(int(
			countdown_timer.time_left + 1
		))
		
	else:
		# Update elapsed timer
		elapsed_label.text = result.get_elapsed_time()

func _physics_process(delta: float) -> void:
	if delta != frame_delta:
		print("ERROR: Running slower than 60 FPS")
		# Throw error to user?

	if Input.is_action_just_released("mash"):
		result.press()
		presses_label.text = str(result.press_count)
		if result.press_count >= 65:
			finish_game()


func on_game_state_changed(new_state: Main.GameState, _result: Result) -> void:
	if new_state != Main.GameState.GAMEPLAY:
		return
	start_countdown()


func start_countdown() -> void:
	countdown_label.show()
	countdown_timer.start()


func start_mashing() -> void:
	countdown_label.hide()
	is_active = true
	result = Result.new()


func finish_game() -> void:
	is_active = false
	Events.game_state_changed.emit(Main.GameState.RESULTS, result)

class_name Gameplay
extends Node2D

@onready var countdown_timer: Timer = $Timers/Countdown
@onready var countdown_label: Label = $UI/Countdown
@onready var elapsed_label: Label = $UI/Elapsed
@onready var limit_timer: Timer = $Timers/Limit

var is_active := false
var start_time := 0
var frame_index := 0
var press_frames := []

const frame_delta := 1 / 60

# Set max time for 60 seconds

func _ready() -> void:
	Events.game_state_changed.connect(on_game_state_changed)
	countdown_timer.timeout.connect(start_mashing)


func _process(_delta: float) -> void:
	if not is_active:
		return
	countdown_label.text = get_elapsed_time(Time.get_ticks_msec())


func _physics_process(delta: float) -> void:
	if not is_active:
		return
	if delta != frame_delta:
		print("ERROR: Running slower than 60 FPS")
		# Throw error to user
		return
	if Input.is_action_just_released("mash"):
		press_frames.append(frame_index)
	frame_index += 1
	
	

func reset_game() -> void:
	press_frames.clear()


func on_game_state_changed(new_state: Main.GameState) -> void:
	if new_state != Main.GameState.GAMEPLAY:
		return
	start_gameplay()


func start_gameplay() -> void:
	countdown_label.show()
	countdown_timer.start()


func start_mashing() -> void:
	start_time = Time.get_ticks_msec()


func get_elapsed_time(ms: int) -> String:
	var total_seconds := (ms - start_time) / 1000.0
	var minutes := int(total_seconds / 60.0)
	var seconds := int(total_seconds) % 60
	var milliseconds := int(ms % 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]

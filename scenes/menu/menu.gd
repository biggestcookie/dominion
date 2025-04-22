class_name Menu
extends Control

@export var play_button: Button
@export var leaderboard_button: Button
@export var settings_button: Button


func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	leaderboard_button.pressed.connect(on_leaderboard_button_pressed)
	settings_button.pressed.connect(on_settings_button_pressed)


func on_play_button_pressed() -> void:
	Events.game_state_changed.emit(Main.GameState.GAMEPLAY)


func on_leaderboard_button_pressed() -> void:
	# Events.game_state_changed.emit(Main.GameState.RESULTS)
	pass


func on_settings_button_pressed() -> void:
	# Events.game_state_changed.emit(Main.GameState.SETTINGS)
	pass

class_name Gameplay
extends Node2D


@onready var countdown_label: Label = $UI/Label

# Set max time for 60 seconds

func _ready() -> void:
	Events.game_state_changed.connect(on_game_state_changed)


func on_game_state_changed(new_state: Main.GameState) -> void:
	if new_state != Main.GameState.GAMEPLAY:
		return
	start_gameplay()


func start_gameplay() -> void:
	countdown_label

class_name Main
extends Node

enum GameState {
	MENU,
	GAMEPLAY,
	RESULTS,
	SETTINGS,
}

@onready var menu: Menu = $Menu
@onready var gameplay: Gameplay = $Gameplay
@onready var results: Results = $Results
@onready var settings: Settings = $Settings

var game_state := GameState.MENU


func _ready() -> void:
	Events.game_state_changed.connect(on_game_state_changed)


func on_game_state_changed(new_state: GameState) -> void:
	match new_state:
		GameState.MENU:
			menu.visible = true
			gameplay.visible = false
			results.visible = false
			settings.visible = false
		GameState.GAMEPLAY:
			menu.visible = false
			gameplay.visible = true
			results.visible = false
			settings.visible = false
		GameState.RESULTS:
			menu.visible = false
			gameplay.visible = false
			results.visible = true
			settings.visible = false
		GameState.SETTINGS:
			menu.visible = false
			gameplay.visible = false
			results.visible = false
			settings.visible = true
	game_state = new_state

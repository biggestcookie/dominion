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
	on_game_state_changed(GameState.MENU, null)
	Events.game_state_changed.connect(on_game_state_changed)


func on_game_state_changed(new_state: GameState, _result: Score) -> void:
	menu.visible = new_state == GameState.MENU
	gameplay.visible = new_state == GameState.GAMEPLAY
	results.visible = new_state == GameState.RESULTS
	settings.visible = new_state == GameState.SETTINGS

	game_state = new_state

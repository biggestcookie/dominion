class_name Results
extends Control

@onready var tab_container: TabContainer = $UI/TabContainer

var show_results := false
var current_result: Score


func _ready() -> void:
	Events.game_state_changed.connect(on_game_state_changed)


func on_game_state_changed(new_state: Main.GameState, result: Score) -> void:
	if new_state != Main.GameState.RESULTS:
		return
	current_result = result
	show_window()


func show_window() -> void:
	if current_result == null:
		tab_container.tabs_visible = false
		tab_container.current_tab = 0
	else:
		tab_container.tabs_visible = show_results
		tab_container.current_tab = 2
		plot()
	# tween container into view
	pass


func plot() -> void:
	pass

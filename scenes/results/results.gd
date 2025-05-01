class_name Results
extends Control

@onready var leaderboard_score_chart: ScoreChart = $ScoreChart
@onready var tab_container: TabContainer = $TabContainer
@onready var results_chart: ScoreChart = $TabContainer/ResultsChart

var show_results := false
var current_result: Score


func _ready() -> void:
	Events.game_state_changed.connect(on_game_state_changed)
	tab_container.tab_changed.connect(on_tab_changed)
	hide_window()


func on_game_state_changed(new_state: Main.GameState, result: Score) -> void:
	if new_state != Main.GameState.RESULTS:
		hide_window()
		return
	current_result = result
	show_window()


func on_tab_changed(tab_index: int) -> void:
	if tab_index == 1:
		# Plot new chart
		results_chart.plot_new_chart(current_result)


func show_window() -> void:
	if current_result == null:
		tab_container.tabs_visible = false
		tab_container.current_tab = 0
	else:
		tab_container.tabs_visible = true
		tab_container.current_tab = 1
	# tween container into view
	tab_container.visible = true


func hide_window() -> void:
	# tween container out of view
	tab_container.visible = false

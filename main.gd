extends Node2D

# 3 phases
# Menu, Mash, and Results
# Menu: Select options, press play
# Mash: Countdown, then mash
# Results: Display results (if just played), leaderboard, mash to restart or quit to menu

enum GameState {
	MENU,
	GAMEPLAY,
	RESULTS
}

var game_state := GameState.MENU

extends Node

@onready var background_music = $background_music  # Reference to the background music player

func _ready():
	# Start the music if it's not already playing
	if !background_music.playing:
		background_music.play()

func _on_start_game_button_pressed():
	# Stop the music when the player starts the game
	background_music.stop()
	# Change to the game scene
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_quit_button_pressed():
	# Quit the game when the quit button is pressed
	get_tree().quit()

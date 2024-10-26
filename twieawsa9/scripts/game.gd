extends Node2D

@onready var night_music = $night_music


func play_music(music_player):
	# Stop all music players before playing the new one
	night_music.stop()
	music_player.play()

func _on_NightArea_body_entered(body):
	if body.name == "Player":
		play_music(night_music)

# Detect when the player enters the area to transition to the main menu
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		transition_to_main_menu()

# Start the transition to the main menu
func transition_to_main_menu():
	# Defer the scene change until after the physics step
	call_deferred("load_main_menu")

# Load the main menu
func load_main_menu():
	print("Loading main menu...")  # Debugging print to verify the function is called
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

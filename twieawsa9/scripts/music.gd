extends Node2D

@onready var home_music = $home_music
@onready var day_music = $day_music
@onready var pause_menu = $Player/Camera2D/pause_menu
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause_menu"):
		toggle_pause()

func toggle_pause():
	paused = !paused
	if paused:
		print("Pausing the game")
		pause_menu.show()
		Engine.time_scale = 0
	else:
		print("Resuming the game")
		pause_menu.hide()
		Engine.time_scale = 1

# Function to play a specific track and stop others
func play_music(music_player):

	home_music.stop()
	day_music.stop()
	music_player.play()

# Called when player enters the Home area
func _on_HomeArea_body_entered(body):
	if body.name == "Player":
		play_music(home_music)

func _on_HomeArea_body_exited(body):
	if body.name == "Player":
		home_music.stop()
		
# Called when player enters the Day area
func _on_DayArea_body_entered(body):
	if body.name == "Player":
		play_music(day_music)

func _on_DayArea_body_exited(body):
	if body.name == "Player":
		day_music.stop()

# Function to handle the player entering the level transition Area2D
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		transition_to_next_level()

# Function to start transitioning to the next level
func transition_to_next_level():
	call_deferred("load_next_level")

# Load the next level
func load_next_level():
	print("Loading next level...") 
	get_tree().change_scene_to_file("res://scenes/game2.tscn")

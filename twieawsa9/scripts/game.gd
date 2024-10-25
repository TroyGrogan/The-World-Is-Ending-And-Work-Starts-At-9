extends Node2D

@onready var pause_menu = $Player/Camera2D/pause_menu

var paused = false

func _process(delta):
	if Input.is_action_just_pressed("pause_menu"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0

	paused = !paused

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		transition_to_next_level()

func transition_to_next_level():
	# Defer the scene change until after the physics step
	call_deferred("load_next_level")

func load_next_level():
	# Change to the next level
	get_tree().change_scene_to_file("res://scenes/game2.tscn")

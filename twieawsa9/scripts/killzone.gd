#extends Area2D
#@onready var timer = $Timer
#
#func _on_body_entered(body):
	#timer.start()
#
#func _on_timer_timeout():
	#get_tree().reload_current_scene()

# New modified code to fix infinite respawn loop.
extends Area2D

@onready var timer = $Timer
var is_active = true  # To control if the kill zone is active

func _on_body_entered(body):
	if body.is_in_group("Player") and is_active:
		body.die()  # Calls the 'die' function in the player script
		is_active = false  # Deactivate the kill zone
		timer.start()

func _on_timer_timeout():
	# Here you might want to re-enable the kill zone
	# or perform other actions
	is_active = true

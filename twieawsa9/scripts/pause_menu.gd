extends Control

func _on_resume_pressed():
	print("Resume button pressed")  # Debugging print
	get_node("/root/Game").toggle_pause()

func _on_quit_pressed():
	print("Quit button pressed")  # Debugging print
	get_tree().quit()

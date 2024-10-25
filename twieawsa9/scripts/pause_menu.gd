extends Control

func _on_resume_pressed():
	get_node("/root/Game").pauseMenu()

func _on_quit_pressed():
	get_tree().quit()

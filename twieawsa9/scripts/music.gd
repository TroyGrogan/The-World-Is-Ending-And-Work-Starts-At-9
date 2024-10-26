extends Node2D

@onready var home_music = $home_music
@onready var day_music = $day_music

# Function to play a specific track and stop others
func play_music(music_player):
	# Stop all music players before playing the new one
	home_music.stop()
	day_music.stop()
	music_player.play()

# Called when player enters the Forest area
func _on_HomeArea_body_entered(body):
	if body.name == "Player":
		play_music(home_music)

func _on_HomeArea_body_exited(body):
	if body.name == "Player":
		home_music.stop()
		
func _on_DayArea_body_entered(body):
	if body.name == "Player":
		play_music(day_music)

func _on_DayArea_body_exited(body):
	if body.name == "Player":
		day_music.stop()

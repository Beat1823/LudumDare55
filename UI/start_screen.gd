extends Control

func _ready():
	SoundManager.playSound2D(load("res://sound/vox/vox_blooddrive.ogg"), -8, 1, 0, 0)
	SoundManager.playSound2D(load("res://sound/introscreen.ogg"), 0, 1, 0, 0)

func _on_play_button_up():
	SoundManager.playSound2D(load("res://sound/hitplay.ogg"))
	get_tree().change_scene_to_file("res://Scenes/main_screen.tscn")

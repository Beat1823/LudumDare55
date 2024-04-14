extends Control

@export var winSounds:Array[AudioStreamOggVorbis]
@export var loseSounds:Array[AudioStreamOggVorbis]

@onready var anim_player = get_node("AnimationPlayer")

func showEndGameScreen(won:bool = false):
	if won:
		anim_player.play("fade")
		await anim_player.animation_finished	
		$EndGameCanvas/EndGameScreen.visible = true
		$EndGameCanvas/EndGameScreen/Header.text = "[center]You bloody did it!"
		$EndGameCanvas/EndGameScreen/Body.text = "[center]The demon hath been summoned"
		SoundManager.playRandomSound2D(winSounds, -8, 1, 0, 0)
	else:		
		$EndGameCanvas/EndGameScreen.visible = true
		$EndGameCanvas/EndGameScreen/Header.text = "[center]You lost!"
		$EndGameCanvas/EndGameScreen/Body.text = "[center]You got caught with no blood"
		SoundManager.playRandomSound2D(loseSounds, -8, 1, 0, 0)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/start_screen.tscn")

func _on_pentagram_progress_update(progress):
	$BloodCanvas/PentagramPaintedText.text = "[center]Pentagram painted:\n[b]" + str(roundi(clampf(progress, 0, 1) * 100)) + "%"

extends Control

func showEndGameScreen(won:bool = false):
	$CanvasLayer/EndGameScreen.visible = true
	if won:
		$CanvasLayer/EndGameScreen/Header.text = "[center]You bloody did it!"
		$CanvasLayer/EndGameScreen/Body.text = "[center]The demon hath been summoned"
	else:
		$CanvasLayer/EndGameScreen/Header.text = "[center]You lost!"
		$CanvasLayer/EndGameScreen/Body.text = "[center]You got caught with no blood"

func _on_button_pressed():
	get_tree().change_scene_to_file("res://UI/start_screen.tscn")


func _on_pentagram_progress_update(progress):
	$CanvasLayer/PentagramPaintedText.text = "[center]Pentagram painted:\n[b]" + str(roundi(progress * 100)) + "%"

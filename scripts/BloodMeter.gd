extends Panel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$FillRect.scale = Vector2(1, -inverse_lerp(0, 1, PlayerData.currentBloodLevel / PlayerData.maxBloodLevel))

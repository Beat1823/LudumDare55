extends Node2D

func playSound2D(sound:AudioStream, vol = 0, pitch = 1, randVol = 3, randPitch = 0.1):
	var player = AudioStreamPlayer2D.new()
	player.stream = sound
	player.volume_db = vol - randf_range(0, randVol)
	player.pitch_scale = pitch + randf_range(-randPitch, randPitch)
	add_child(player)
	player.play()

func playSound3D(sound:AudioStream, pos, vol = 0, pitch = 1, randVol = 3, randPitch = 0.1):
	var player = AudioStreamPlayer2D.new()
	player.stream = sound
	player.volume_db = vol - randf_range(0, randVol)
	player.pitch_scale = pitch + randf_range(-randPitch, randPitch)
	add_child(player)
	player.position = pos
	player.play()

func playRandomSound3D(sounds:Array[AudioStreamOggVorbis], pos, vol = 0, pitch = 1, randVol = 3, randPitch = 0.1):
	playSound3D(sounds.pick_random(), pos, vol, pitch, randVol, randPitch)

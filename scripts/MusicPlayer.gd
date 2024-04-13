extends Node

@export var MusicFiles: Array[AudioStreamOggVorbis]
@export var MusicPlayer: AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicPlayer.stream = MusicFiles.pick_random()
	MusicPlayer.play()

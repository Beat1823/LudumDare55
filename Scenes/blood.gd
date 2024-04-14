extends Area2D

class_name Blood

@export var radius: float = 0
@export var placedSounds:Array[AudioStreamOggVorbis]

func _ready():
	var collisionShape: CollisionShape2D = get_node("CollisionShape2D")
	radius = collisionShape.shape.radius

func onPlaced():
		name = "Blood"
		PlayerData.currentBloodLevel -= 1
		var bloodToPitch:float = 1.25 - inverse_lerp(0, PlayerData.maxBloodLevel, PlayerData.currentBloodLevel) / 2
		SoundManager.playRandomSound3D(placedSounds, position, 0, bloodToPitch, 0, 0)

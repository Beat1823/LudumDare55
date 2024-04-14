extends Area2D

class_name Blood

@export var radius: float = 0
@export var placedSounds:Array[AudioStreamOggVorbis]

func _ready():
	var collisionShape: CollisionShape2D = get_node("CollisionShape2D")
	radius = collisionShape.shape.radius



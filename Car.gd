extends Area2D

@export var speed = 400
var screenSize
 
# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_transform().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

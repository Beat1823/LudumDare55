extends Camera2D

@export var Car: CharacterBody2D
@export var ZoomScaling: float = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var vel = Car.velocity.length() / ZoomScaling
	zoom.x = 2 / (1 + vel)
	zoom.y = 2 / (1 + vel)

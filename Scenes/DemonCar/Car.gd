extends CharacterBody2D

@export var wheelBase = 70
@export var steeringAngle = 15

var charVelocity = Vector2.ZERO
var steerDirection

func _physics_process(delta):
	getInput()
	calcSteering(delta)
	move_and_slide()

func getInput():
	var turn = 0
	if Input.is_action_pressed("turnRight"):
		turn += 1
	if Input.is_action_pressed("turnLeft"):
		turn -= 1
	steerDirection = turn * steeringAngle
	velocity = Vector2.ZERO
	if Input.is_action_pressed("accelerate"):
		velocity = transform.x * 500
	
func calcSteering(delta):
	var rearWheel = position - transform.x * wheelBase/2.0
	var frontWheel = position + transform.x * wheelBase/2.0
	rearWheel += velocity * delta
	frontWheel += velocity.rotated(steerDirection) * delta
	var newHeading = (frontWheel - rearWheel).normalized()
	velocity = newHeading * velocity.length()
	rotation = newHeading.angle()
	
 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends CharacterBody2D

@export var wheelBase = 70
@export var steeringAngle = 20
@export var engine_power = 800

var acceleration
var steerDirection

func _physics_process(delta):
	acceleration = Vector2.ZERO
	getInput()
	calcSteering(delta)
	velocity += acceleration * delta
	move_and_slide()

func getInput():
	var turn = 0
	if Input.is_action_pressed("turnRight"):
		turn += 1
	if Input.is_action_pressed("turnLeft"):	
		turn -= 1
	steerDirection = turn * deg_to_rad(steeringAngle)
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * -engine_power
	
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
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

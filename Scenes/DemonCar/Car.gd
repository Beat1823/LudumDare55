extends CharacterBody2D

@export var wheelBase = 70
@export var steeringAngle = 20
@export var engine_power = 1000
@export var friction = -0.9
@export var drag = -0.001
@export var breaking = -450
@export var maxReverseSpeed = 250
@export var slipSpeed = 400
@export var tractionFast = 0.1
@export var tractionSlow = 1.0

var acceleration
var steerDirection

func _physics_process(delta):
	acceleration = Vector2.ZERO
	getInput()
	applyFriction()
	calcSteering(delta)
	velocity += acceleration * delta
	move_and_slide()

func applyFriction():
	if velocity.length() < 5 : 
		velocity = Vector2.ZERO
	var frictionForce = velocity * friction
	var dragForce = velocity * velocity.length() * drag
	acceleration += dragForce + frictionForce

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
		acceleration = transform.x * breaking
	
func calcSteering(delta):
	var rearWheel = position - transform.x * wheelBase/2.0
	var frontWheel = position + transform.x * wheelBase/2.0
	rearWheel += velocity * delta
	frontWheel += velocity.rotated(steerDirection) * delta
	var newHeading = (frontWheel - rearWheel).normalized()
	var traction = tractionSlow
	if velocity.length() > slipSpeed:
		traction = tractionFast
	var dot = newHeading.dot(velocity.normalized())
	if dot > 0:
		velocity = velocity.lerp(newHeading * velocity.length(), traction)
	if dot < 0:
		velocity = -newHeading * min(velocity.length(), maxReverseSpeed)
	rotation = newHeading.angle()
	
 
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

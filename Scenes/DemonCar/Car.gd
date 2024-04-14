extends CharacterBody2D

@export var wheelBase = 70
@export var steeringAngle = 20
@export var steeringRate = 60
@export var engine_power = 1000
@export var friction = -0.9
@export var drag = -0.001
@export var breaking = -450
@export var maxReverseSpeed = 250
@export var slipSpeed = 400
@export var tractionFast = 0.1
@export var tractionSlow = 1.0

@export var engine_volume_multiplier = 3
@export var engine_pitch_scale = 0.5
@export var min_engine_volume = -10
@export var tireSkidSound:AudioStream = preload("res://sound/tire_skid.ogg")
@export var skid_min_rot = 0.3

@export var wheelFR: AnimatedSprite2D
@export var wheelFL: AnimatedSprite2D
@export var wheelBR: AnimatedSprite2D
@export var wheelBL: AnimatedSprite2D

var acceleration
var steerDirection

signal BloodTrackPlaced(pos)

func _physics_process(delta):
	acceleration = Vector2.ZERO
	getInput(delta)
	applyFriction()
	calcSteering(delta)
	velocity += acceleration * delta
	move_and_slide()
	setEngineSound()
	setTireSkidSound()

func applyFriction():
	if velocity.length() < 5 : 
		velocity = Vector2.ZERO
	var frictionForce = velocity * friction
	var dragForce = velocity * velocity.length() * drag
	acceleration += dragForce + frictionForce

func getInput(delta):
	
	#var turn = 0
	#if Input.is_action_pressed("turnRight"):
		#turn += 1
	#if Input.is_action_pressed("turnLeft"):	
		#turn -= 1
	
	#if turn == 0:
		#steerDirection = 0
	#else:
		#steerDirection += turn * delta * deg_to_rad(steeringRate)
		#steerDirection = turn * min(abs(steerDirection), deg_to_rad(steeringAngle))
	var mousePosition = get_global_mouse_position()
	var direction = (mousePosition - position).normalized()
	
	var forward = global_transform.basis_xform(Vector2.RIGHT)
	
	var turnAngle = acos(forward.dot(direction))
	
	if direction.cross(forward) > 0:
		turnAngle = -turnAngle
	
	steerDirection = turnAngle
	wheelFL.rotation = deg_to_rad(90) + steerDirection
	wheelFR.rotation = deg_to_rad(90) + steerDirection
	
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
	
func setEngineSound():
	var volume_scale = 80
	var EngineSound:AudioStreamPlayer2D = $EngineSound
	var unclampedEngineSound:float = inverse_lerp(0, engine_power / engine_volume_multiplier, velocity.length()) * volume_scale - volume_scale
	EngineSound.volume_db = clampf(unclampedEngineSound, min_engine_volume, 0)
	EngineSound.pitch_scale = inverse_lerp(0, engine_power, velocity.length()) * engine_pitch_scale * 2 + 0.5

func setTireSkidSound():
	if abs(steerDirection) > skid_min_rot:
		if velocity.length() > slipSpeed:
			if !$TireSkidSound.playing:
				$TireSkidSound.play(randf_range(0, tireSkidSound.get_length()))
			return
	if $TireSkidSound.playing:
		$TireSkidSound.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if Input.is_action_pressed("BloodTracks"):
		BloodTrackPlaced.emit(position - transform.x * wheelBase/2.0)

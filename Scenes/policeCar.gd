extends CharacterBody2D

@export var wheelBase = 70
@export var steeringAngle = 20
@export var steeringRate = 60
@export var engine_power = 500
@export var friction = -0.9
@export var drag = -0.001
@export var breaking = -450
@export var maxReverseSpeed = 250
@export var slipSpeed = 400
@export var tractionFast = 0.1
@export var tractionSlow = 1.0
@export var offsetScale = 300.0

@export var move_speed : float = 100
@export var walk_time : float = 1
@export var siren_sounds: Array[AudioStreamOggVorbis]

@export var dopplerSpeedDelta = 800
@export var dopplerPitchRange = 0.3

var move_direction : Vector2 = Vector2.ZERO

@onready var timer = $MovementTimer
@onready var car = get_node("/root/MainScreen/Car")

var is_alive:bool = true
var is_moving:bool = true
var is_bouncing:bool = false
var acceleration
var steerDirection

var targetOffset:Vector2 = Vector2(0.0, 0.0)

signal CarHit

func _ready():
	select_new_direction()
	timer.start(walk_time)
	$SirenSound.stream = siren_sounds.pick_random()
	$SirenSound.play()
	$AnimationPlayer.speed_scale = randf_range(0.8, 1.2)
	
func _process(delta):
	var delta_vector:Vector2 = car.velocity - velocity
	var clamped_delta_vector = clampf(delta_vector.length(), -dopplerSpeedDelta, dopplerSpeedDelta)
	$SirenSound.pitch_scale = clamped_delta_vector / (dopplerSpeedDelta / dopplerPitchRange) + 1 

func _on_movement_timer_timeout():
	select_new_direction()
	timer.start(walk_time)
	
func select_new_direction():
	targetOffset = Vector2(randf_range(0.0, offsetScale), randf_range(0.0, offsetScale))
	
func _physics_process(delta):
	if is_alive and is_moving:	
		acceleration = Vector2.ZERO
		getInput(delta)
		applyFriction()
		calcSteering(delta)
		velocity += acceleration * delta
		
		move_and_slide()

func unalive():
	$CarDetector/CollisionShape2D.disabled = true
	$FrontDetector/CollisionShape2D.disabled = true
	PlayerData.police_count -= 1
	timer.stop()
	is_alive = false
	$AnimatedSprite2D.play("dead")
	$SirenSound.stop()
	SoundManager.playSound3D(load("res://sound/policecar_destroy.ogg"), position)
	$Hoodlights.visible = false
	$Headlights.visible = false
	

func _on_car_detactor_body_entered(body):
	if is_alive:
		unalive()

func _on_front_detector_body_entered(body):
	if is_alive:
		CarHit.emit()
		is_bouncing = true
		select_new_direction()
		$BounceTimer.start()

func _on_idle_timer_timeout():
	is_moving = true
	select_new_direction()

func _on_bounce_timer_timeout():
	is_moving = false
	is_bouncing = false
	$IdleTimer.start()
	

func getInput(delta):
	if !is_alive:
		return
		
	var direction = (car.position + targetOffset - position).normalized()
	var forward = global_transform.basis_xform(Vector2.RIGHT)
	var turnAngle = min(acos(forward.dot(direction)), deg_to_rad(steeringAngle))
	
	if direction.cross(forward) > 0:
		turnAngle = -turnAngle
	
	steerDirection = turnAngle
	acceleration = transform.x * engine_power

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
	
func applyFriction():
	if velocity.length() < 5 : 
		velocity = Vector2.ZERO
	var frictionForce = velocity * friction
	var dragForce = velocity * velocity.length() * drag
	acceleration += dragForce + frictionForce

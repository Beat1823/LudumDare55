extends CharacterBody2D

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

var target:Vector2 = Vector2(0.0, 0.0)

signal CarHit

func _ready():
	select_new_direction()
	timer.start(walk_time)
	$SirenSound.stream = siren_sounds.pick_random()
	$SirenSound.play()
	
func _process(delta):
	var delta_vector:Vector2 = car.velocity - velocity
	var clamped_delta_vector = clampf(delta_vector.length(), -dopplerSpeedDelta, dopplerSpeedDelta)
	$SirenSound.pitch_scale = clamped_delta_vector / (dopplerSpeedDelta / dopplerPitchRange) + 1 

func _on_movement_timer_timeout():
	select_new_direction()
	timer.start(walk_time)
	
func select_new_direction():
	target = car.position
	var dir = position.direction_to(target)
	if is_moving:
		move_direction = dir
	if is_bouncing:
		move_direction = -dir
	
func _physics_process(_delta):
	if is_alive and is_moving:
		
		velocity = move_direction * move_speed 
		
		var angle_to_car = move_direction.angle()
		rotation = move_toward(rotation, angle_to_car, _delta)
		
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

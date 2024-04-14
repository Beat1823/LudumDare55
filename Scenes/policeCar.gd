extends CharacterBody2D

@export var move_speed : float = 60
@export var walk_time : float = 1
var move_direction : Vector2 = Vector2.ZERO

@onready var timer = $MovementTimer
@onready var car = get_node("/root/MainScreen/Car")

var is_alive:bool = true

var target:Vector2 = Vector2(0.0, 0.0)

signal CarHit

func _ready():
	select_new_direction()
	timer.start(walk_time)

func _on_movement_timer_timeout():
	select_new_direction()
	timer.start(walk_time)
	
func select_new_direction():
	target = car.position
	var dir = position.direction_to(target)
	move_direction = dir
	
func _physics_process(_delta):
	if is_alive:
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


func _on_car_detactor_body_entered(body):
	if is_alive:
		unalive()

func _on_front_detector_body_entered(body):
	CarHit.emit()
	move_direction = -move_direction
	
	

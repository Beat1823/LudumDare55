extends CharacterBody2D

@export var move_speed : float = 60
@export var walk_time : float = 4
var move_direction : Vector2 = Vector2.ZERO

@onready var timer = $MovementTimer

var is_alive:bool = true

signal CarHit

func _ready():
	select_new_direction()
	timer.start(walk_time)

func _on_movement_timer_timeout():
	select_new_direction()
	timer.start(walk_time)
	
func select_new_direction():
	var car = get_node("/root/MainScreen/Car")
	var carPosition = car.position
	var dir = position.direction_to(carPosition)
	move_direction = dir
	
func _physics_process(_delta):
	if is_alive:
		velocity = move_direction * move_speed
		rotation = atan2(move_direction.y, move_direction.x)
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

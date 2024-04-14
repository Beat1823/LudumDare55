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
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	
func _physics_process(_delta):
	if is_alive:
		velocity = move_direction * move_speed
		rotation = atan2(move_direction.y, move_direction.x)
		move_and_slide()

func unalive():
	$CarDetector/CollisionShape2D.disabled = true
	PlayerData.police_count -= 1
	timer.stop()
	is_alive = false
	queue_free()


func _on_car_detactor_body_entered(body):
	if is_alive:
		unalive()

func _on_front_detector_body_entered(body):
	CarHit.emit()

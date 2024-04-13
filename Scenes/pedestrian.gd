extends CharacterBody2D

@export var move_speed : float = 20
@export var walk_time : float = 2
var move_direction : Vector2 = Vector2.ZERO

@onready var timer = $MovementTimer

var is_alive: bool = true

func _ready():
	select_new_direction()
	timer.start(walk_time)

func _on_movement_timer_timeout():
	$AnimatedSprite2D.play("idle")
	select_new_direction()
	timer.start(walk_time)
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	$AnimatedSprite2D.play("walking")
	
func _physics_process(_delta):
	velocity = move_direction * move_speed
	move_and_slide()

func _on_car_detector_body_entered(body):
	$CarDetector/CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("dead")
	PlayerData.pedestrian_count -= 1
	is_alive = false
	

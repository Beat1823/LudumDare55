extends CharacterBody2D

@export var move_speed : float = 20
@export var walk_time : float = 2
var move_direction : Vector2 = Vector2.ZERO

@onready var timer = $MovementTimer

var is_alive:bool = true

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

	PlayerData.pedestrian_count -= 1
	timer.stop()
	is_alive = false

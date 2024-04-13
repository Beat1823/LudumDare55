extends CharacterBody2D

@export var move_speed : float = 20
@export var walk_time : float = 2
var move_direction : Vector2 = Vector2.ZERO

@onready var timer = $MovementTimer

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
	velocity = move_direction * move_speed
	move_and_slide()


func _on_car_detector_body_entered(body):
	get_node("CollisionShape2D").disabled = true
	queue_free()
	PlayerData.pedestrian_count -= 1

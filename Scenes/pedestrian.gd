extends CharacterBody2D

@export var move_speed : float = 20
@export var walk_time : float = 2
@export var deathSounds:Array[AudioStreamOggVorbis]
@export var killVoices:Array[AudioStreamOggVorbis]
var move_direction : Vector2 = Vector2.ZERO
@export var chanceToPlayKillSound = 0.5

@onready var timer = $MovementTimer

var is_alive:bool = true
signal PedestrianHit

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
	if is_alive:
		velocity = move_direction * move_speed
		rotation = atan2(move_direction.y, move_direction.x)
		move_and_slide()

func unalive():
	$CarDetector/CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("dead")
	PlayerData.pedestrian_count -= 1
	timer.stop()
	PedestrianHit.emit()
	if randf() <= chanceToPlayKillSound:
		SoundManager.playRandomSound2D(killVoices, -8, 1, 0, 0)
	SoundManager.playRandomSound3D(deathSounds, global_position)
	is_alive = false

func _on_car_detector_body_entered(body):
	if is_alive:
		CameraManager.SmallShake()
		unalive()

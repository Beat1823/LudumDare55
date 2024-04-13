extends Node2D

@export var pedestrian_scene: PackedScene

var onready

func _ready():
	$PedestrianTimer.start()

func _on_pedestrian_timer_timeout():
	var pedestrian = pedestrian_scene.instantiate()
	
	# Choose a random location on Path2D.
	var pedestrian_spawn_location = $PedestrianPath/PedestrianSpawnLocation
	pedestrian_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = pedestrian_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	pedestrian.position = pedestrian_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	pedestrian.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	pedestrian.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(pedestrian)

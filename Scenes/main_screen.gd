extends Node2D

@export var pedestrian_scene: PackedScene

func _ready():
	$PedestrianTimer.start()

func _on_pedestrian_timer_timeout():
	var pedestrian = pedestrian_scene.instantiate()
	
	# Choose a random location on Path2D.
	var pedestrian_spawn_location = $PedestrianPath/PedestrianSpawnLocation
	pedestrian_spawn_location.progress_ratio = randf()
#
	# Set the mob's position to a random location.
	pedestrian.position = pedestrian_spawn_location.position
#
	# Spawn the mob by adding it to the Main scene.
	add_child(pedestrian)
	

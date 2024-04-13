extends Node2D

@export var pedestrian_scene: PackedScene
@export var blood_scene: PackedScene

@export var PEDESTRIAN_LIMIT = 5 

func _ready():
	$PedestrianTimer.start()
	var Car = get_node("Car")
	Car.BloodTrackPlaced.connect(placeBlood)

func _on_pedestrian_timer_timeout():
	if PlayerData.pedestrian_count >= PEDESTRIAN_LIMIT:
		return
	
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
	PlayerData.pedestrian_count += 1

func placeBlood(pos):
	var blood = blood_scene.instantiate()
	blood.position = pos
	blood.name = "Blood"
	add_child(blood, true)
	
	

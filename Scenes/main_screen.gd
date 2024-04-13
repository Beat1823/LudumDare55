extends Node2D

@export var pedestrian_scene: PackedScene
@export var blood_scene: PackedScene

@export var PEDESTRIAN_LIMIT = 5 

var pedestrian_count = 0

func _ready():
	$PedestrianTimer.start()

func _on_pedestrian_timer_timeout():
	if pedestrian_count >= PEDESTRIAN_LIMIT:
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
	pedestrian_count += 1
	
func _input(event):
	if Input.is_action_pressed("click"):
		var blood = blood_scene.instantiate()
		blood.position = event.position
		blood.name = "Blood"
		add_child(blood, true)
		
	
	

extends Node2D

@export var maxBloodLevel = 100.0
@export var startingBloodlevel = 50.0
var currentBloodLevel

@export var pedestrian_scene: PackedScene
@export var blood_scene: PackedScene

@export var PEDESTRIAN_LIMIT = 5 

func _ready():
	$PedestrianTimer.start()
	var Car = get_node("Car")
	Car.BloodTrackPlaced.connect(placeBlood)
	currentBloodLevel = startingBloodlevel

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
	pedestrian.PedestrianHit.connect(FillBlood)
#
	# Spawn the mob by adding it to the Main scene.
	add_child(pedestrian)
	PlayerData.pedestrian_count += 1

func FillBlood():
	currentBloodLevel += 10.0

func placeBlood(pos):
	var canPlace = true
	for child in get_children():
		if (child.name.contains("Blood")):
			if Geometry2D.is_point_in_circle(pos, child.position, child.radius):
				canPlace = false
				break
				
	if canPlace && currentBloodLevel > 0:
		print("blood %s" % pos)
		var blood = blood_scene.instantiate()
		blood.position = pos
		blood.name = "Blood"
		add_child(blood, true)
		currentBloodLevel -= 1
	
	

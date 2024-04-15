extends Node2D

@export var startingBloodlevel = 50.0

@export var pedestrian_scene: PackedScene
@export var police_car_scene: PackedScene
@export var blood_scene: PackedScene

@export var PEDESTRIAN_LIMIT = 500
@export var POLICE_CAR_LIMIT = 200 

var placementCooldownMs = 500
var lastTriggerTime = 0

var hasWon = false

func _ready():
	PlayerData.pedestrian_count = 0
	PlayerData.police_count = 0
	
	$PedestrianTimer.start()
	$PoliceTimer.start()
	var Car = get_node("Car")
	Car.BloodTrackPlaced.connect(placeBlood)
	
	var NewCamera = PlayerCamera.new()
	Car.add_child(NewCamera)
	CameraManager.mainCamera = NewCamera
	
	PlayerData.currentBloodLevel = startingBloodlevel

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
	
func _on_police_car_timer_timeout():
	if PlayerData.police_count >= POLICE_CAR_LIMIT:
		return
	
	var police = police_car_scene.instantiate()
	
	# Choose a random location on Path2D.
	var spawn_location = $PedestrianPath/PedestrianSpawnLocation
	spawn_location.progress_ratio = randf()
#
	# Set the mob's position to a random location.
	police.position = spawn_location.position
	police.CarHit.connect(HitCar)
#
	# Spawn the mob by adding it to the Main scene.
	add_child(police)
	PlayerData.police_count += 1

func FillBlood():
	PlayerData.currentBloodLevel += 10.0
	
func HitCar():
	if hasWon:
		return
		
	SoundManager.playSound2D(load("res://sound/take_damage.ogg"), -3)
	CameraManager.MidShake()
	if PlayerData.currentBloodLevel > 0.0:
		PlayerData.currentBloodLevel -= 10.0
		SoundManager.playSound2D(load("res://sound/vox/vox_oof.ogg"), -6)
	if PlayerData.currentBloodLevel <= 0.0:
		PlayerData.currentBloodLevel = 0.0
		var Car = get_node("Car")
		Car.die()
		var gray = get_node("GrayscaleLayer")
		gray.set_visible(true)

func placeBlood(pos):
	var canPlace = true
	for child in get_children():
		if (child.name.contains("Blood")):
			if Geometry2D.is_point_in_circle(pos, child.position, child.radius * 0.6):
				canPlace = false
				break
				
	if canPlace && PlayerData.currentBloodLevel > 0:
		var blood = blood_scene.instantiate()
		blood.position = pos
		add_child(blood, true)
		blood.onPlaced()
		$Pentagram.checkPoint(pos, blood.radius)
		
	if PlayerData.currentBloodLevel <= 0 and lastTriggerTime + placementCooldownMs <= Time.get_ticks_msec():
		SoundManager.playSound2D(load("res://sound/vox/vox_youreouttablood.ogg"), -8, 1, 0, 0)
		lastTriggerTime = Time.get_ticks_msec()

func _on_pentagram_on_covered():
	hasWon = true
	$GameUi.showEndGameScreen(true)

extends Node2D

@export var pedestrian_scene: PackedScene

var _allPoints: Array

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


func _on_line_2d_draw():
	var pentagram: Line2D = get_node("Pentagram") 
	var points: PackedVector2Array = pentagram.points
	
	_allPoints.clear()
	
	for i in range(points.size() - 1):
		var pointA: Vector2 = points[i]
		var pointB: Vector2 = points[i + 1]
		
		var m = (pointA.y - pointB.y) / (pointA.x - pointB.x)
		var c = pointA.y - pointA.x * m

		for x in range(pointA.x, pointB.x):
			var y = m*x + c
			_allPoints.append(Vector2(x, y))
			
	print(_allPoints.size())
	

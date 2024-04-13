extends Line2D

var _allPoints: Array

func _on_draw():
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
	
func _process(delta):
	if is_covered_in_blood():
		print("You summoned the demon")
	
func is_covered_in_blood() -> bool:
	var bloodAreas = []
	for child in get_parent().get_children():
		if (child.name.contains("Blood")):
			bloodAreas.push_back(child)
	
	for point in _allPoints:
		if !is_point_covered(point, bloodAreas):
			return false
	return true
	
func is_point_covered(point: Vector2, bloodAreas: Array) -> bool:
	for bloodArea in bloodAreas:
		if Geometry2D.is_point_in_circle(point, bloodArea.position, bloodArea.radius):
			return true
	return false	
	

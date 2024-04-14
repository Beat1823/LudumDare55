extends Line2D

@export var camera: Camera2D

var _allPoints: Array

func _on_draw():
	_allPoints.clear()
	
	print("points: %s" % points)

	for i in range(points.size()):
		
		var pointA: Vector2 = points[i]
		var pointB: Vector2 = points[i + 1 if i + 1 < points.size() else 0]
		
		var left = pointA if pointA.x < pointB.x else pointB
		var right = pointB if pointA.x <= pointB.x else pointA
		
		var m = (left.y - right.y) / (left.x - right.x)
		var c = left.y - left.x * m

		for x in range(left.x, right.x):
			var y = m*x + c
			_allPoints.append(Vector2(x, y))
			#draw_circle(Vector2(x, y), 3, Color.PURPLE)
			
	print("all points %s" % _allPoints.size())
	
func _process(delta):
	if is_covered_in_blood():
		print("You summoned the demon")
	
func is_covered_in_blood() -> bool:
	var bloodAreas = []
	for child in get_parent().get_children():
		if (child.name.contains("Blood")):
			bloodAreas.push_back(child)
			
	var bloodCenters = []
	for thing in bloodAreas:
		var pos = camera.get_canvas_transform() * thing.position
		bloodCenters.push_back(pos)
			
	material.set("shader_parameter/blood_points", bloodCenters)
	material.set("shader_parameter/blood_num", bloodCenters.size())
	
	if bloodAreas.size() > 0:
		material.set("shader_parameter/blood_radius", bloodAreas[0].radius)
	
	for point in _allPoints:
		if !is_point_covered(point, bloodAreas):
			return false
	return true
	
func is_point_covered(point: Vector2, bloodAreas: Array) -> bool:
	for bloodArea in bloodAreas:
		# print("point %s, bloodArea.position %s, bloodArea.radius %s" % [point, bloodArea.position, bloodArea.radius])
		if Geometry2D.is_point_in_circle(point, bloodArea.position, bloodArea.radius):
			# print("point %s" % point)
			return true
	return false	
	

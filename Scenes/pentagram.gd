extends Line2D

@export var graceMultiplier = 1.25
var _allPoints: Array

signal onCovered
signal progressUpdate(progress)

@export var ProgressSoundMap: Dictionary
var SoundsPlayed: Array[AudioStreamOggVorbis]

var covered:bool = false
var coveredAreas:Array

func _ready():
	covered = false
	
func _process(delta):
	var bloodAreas = []
	for child in get_parent().get_children():
		if (child.name.contains("Blood")):
			bloodAreas.push_back(child)
			
	var transform = get_viewport().get_screen_transform() * get_global_transform_with_canvas()
			
	var bloodCenters = []
	for thing in bloodAreas:
		var pos = transform * thing.global_position
		bloodCenters.push_back(pos)
			
	material.set("shader_parameter/blood_points", bloodCenters)
	material.set("shader_parameter/blood_num", bloodCenters.size())
	
	if bloodAreas.size() > 0:
		var scale = CameraManager.mainCamera.zoom.length()
		material.set("shader_parameter/blood_radius", scale * bloodAreas[0].radius)

func _on_draw():
	_allPoints.clear()

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
			#draw_circle(Vector2(x, y), 12, Color.PURPLE)
			
	updateCoveredStatus()
	
func checkPoint(pos, radius):
	for point in _allPoints:
		if Geometry2D.is_point_in_circle(point, pos, radius):
			if !coveredAreas.has(point):
				coveredAreas.append(point)
	updateCoveredStatus()

func updateCoveredStatus():
	if is_covered_in_blood():
		if !covered:
			onCovered.emit()
		covered = true
	
func is_covered_in_blood() -> bool:
	var bloodAreas = []
	for child in get_parent().get_children():
		if (child.name.contains("Blood")):
			bloodAreas.push_back(child)
	
	var progress = float(coveredAreas.size()) / _allPoints.size() * graceMultiplier
	var covered = progress >= 1
	
	SoundProgress(progress)
	progressUpdate.emit(progress)
	return covered

func SoundProgress(progress):
	var keys = ProgressSoundMap.keys()
	for entry in keys:
		if progress >= entry:
			if !SoundsPlayed.has(ProgressSoundMap[entry]):
				SoundsPlayed.append(ProgressSoundMap[entry])
				SoundManager.playSound2D(ProgressSoundMap[entry], -8, 0, 0, 0)
				return

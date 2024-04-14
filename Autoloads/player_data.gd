extends Node

@export var maxBloodLevel = 100.0

@export var pedestrian_count: = 0:
	get:
		return pedestrian_count
	set(value):
		pedestrian_count = value
		
@export var police_count: = 0:
	get:
		return police_count
	set(value):
		police_count = value

var currentBloodLevel = 0.0

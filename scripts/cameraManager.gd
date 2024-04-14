extends Node

var mainCamera : PlayerCamera

func MidShake():
	mainCamera.add_trauma(0.6)
	mainCamera.shake()

func SmallShake():
	mainCamera.add_trauma(0.3)
	mainCamera.shake()

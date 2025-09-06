extends Node

var cube: MeshInstance3D
var rotation_speed := 0.1

func _ready() -> void:
	cube = $Cube

func _process(delta: float) -> void:
	cube.transform = cube.transform.rotated(Vector3.UP, rotation_speed * delta)

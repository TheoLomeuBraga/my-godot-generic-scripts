extends CharacterBody3D



@export var speed : Vector3 = Vector3.ZERO

func floor_normal() -> Vector3:
	return Vector3.ZERO

func touch_floor() -> bool:
	return floor_normal() != Vector3.ZERO

func touch_cealing() -> bool:
	return $ShapeCastCealing.is_colliding()

func movement_plugin(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	movement_plugin(delta)

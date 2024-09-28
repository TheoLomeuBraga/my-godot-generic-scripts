extends CharacterBody3D
class_name GenericPathFinder

@export var speed := 500.0

@export var target_position : Vector3
@export var go : bool = false

enum look_modes {
	not_look = 0,
	look_next_point = 1,
	look_target = 2
}
@export var look_mode : look_modes = look_modes.not_look

@export var target_location : Vector3

@export var turn_speed : float = 10.0





func movement_plugin(delta: float) -> void:
	pass


var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var countdown_path : int = 0

func _physics_process(delta: float) -> void:
	
	movement_plugin(delta)
	
	var distance_next_point : Vector3 = (target_position - global_position)
	if countdown_path <= 0:
		target_position = $NavigationAgent3D.get_next_path_position()
		$NavigationAgent3D.target_position = target_location 
		countdown_path = rng.randi_range(5,30)
	
	if go:
		var new_velocity : Vector3 = (target_position - global_position).normalized() * speed * delta
		if new_velocity != Vector3.ZERO:
			velocity = (target_position - global_position).normalized() * speed * delta
		move_and_slide()
	
	if look_mode == 1:
		var target_direction : Vector3 = (target_position - global_position).normalized()
		var current_direction : Vector3 = global_transform.basis.z.normalized()
		
		var current_rotation : float = atan2(current_direction.x, current_direction.z)
		var target_rotation : float = atan2(target_direction.x, target_direction.z)
		
		var new_rotation : float = lerp_angle(current_rotation, target_rotation, turn_speed * delta)
		
		rotation.y = new_rotation
	elif look_mode == 2:
		var target_direction : Vector3 = (target_location - global_position).normalized()
		var current_direction : Vector3 = global_transform.basis.z.normalized()
		
		var current_rotation : float = atan2(current_direction.x, current_direction.z)
		var target_rotation : float = atan2(target_direction.x, target_direction.z)
		
		var new_rotation : float = lerp_angle(current_rotation, target_rotation, turn_speed * delta)
		
		rotation.y = new_rotation
	
	countdown_path -= 1
	
	
	


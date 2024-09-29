extends RigidBody3D
class_name BasicMovement

var sliding_time := 0.0

var jump_recently := 0.0

var in_floor : bool = false

@export var speed := 3.0

@export var move_direction : Vector3 = Vector3.ZERO

@export var jump_power := 3.0

@export  var air_control := false

func jump() -> void:
	linear_velocity.y = jump_power
	jump_recently = 0.2

func move(delta) -> void:
	
	
	if move_direction.length() > 0:
		physics_material_override.friction = 0
	elif sliding_time <= 0:
		physics_material_override.friction = 10
	
	var new_move_direction : Vector3 = move_direction
	
	in_floor = $floorChekerRay.is_colliding() or $floorChekerShape.is_colliding()
	if in_floor and move_direction != Vector3.ZERO:
		
		if  $floorChekerRay.is_colliding():
			new_move_direction = move_direction.slide($floorChekerRay.get_collision_normal()).normalized()
		elif $floorChekerShape.is_colliding():
			new_move_direction = move_direction.slide($floorChekerShape.get_collision_normal(0)).normalized()
		else:
			new_move_direction = move_direction
	
	
	if new_move_direction != Vector3.ZERO:
		new_move_direction = new_move_direction.normalized()
		if sliding_time > 0 or not in_floor:
			if air_control:
				var new_velocity = new_move_direction * speed  * 100 * delta
				new_velocity = new_velocity.normalized() * min(new_velocity.length(), speed)
				linear_velocity.x = new_velocity.x
				linear_velocity.z = new_velocity.z
				physics_material_override.friction = 0
			else:
				var new_velocity = new_move_direction * speed * delta
				new_velocity = new_velocity.normalized() * min(new_velocity.length(), speed)
				apply_impulse(new_velocity)
				physics_material_override.friction = 0
		else:
			var new_velocity = new_move_direction * speed  * 100 * delta
			new_velocity = new_velocity.normalized() * min(new_velocity.length(), speed)
			linear_velocity.x = new_velocity.x
			if jump_recently <= 0:
				linear_velocity.y = new_velocity.y
			linear_velocity.z = new_velocity.z
	
	
	
	if in_floor:
		sliding_time -= delta
	jump_recently -= delta

func _on_body_entered(body) -> void:
	if body is RigidBody3D:
		if body.linear_velocity.length() > 50:
			sliding_time = 1
			physics_material_override.friction = 0
			linear_velocity += (body.linear_velocity * body.mass) / mass


func movement_plugin(delta) -> void:
	pass

func _physics_process(delta) -> void:
	movement_plugin(delta)
	move(delta)


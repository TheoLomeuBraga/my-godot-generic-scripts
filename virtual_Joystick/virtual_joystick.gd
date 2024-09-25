extends TouchScreenButton

var point_center : Vector2 = Vector2.ZERO
var max_distance : float = shape.radius

func _ready() -> void:
	$point.position = point_center
	$point.visibility_mode = visibility_mode
	set_process(false)

'''
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			set_process(true)
		else:
			set_process(false)
			$point.position = point_center
'''

func _process(delta: float) -> void:
	$point.global_position = get_global_mouse_position()
	$point.position = ($point.position - ($point.texture_normal.get_size() / 2)).limit_length(max_distance)


func _on_pressed() -> void:
	set_process(true)


func _on_released() -> void:
	set_process(false)
	$point.position = point_center

func get_joystick_input() -> Vector2:
	return $point.position.normalized() * ($point.position / max_distance)

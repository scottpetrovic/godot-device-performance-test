extends Camera3D

var orbit_speed: float = 0.1  # Rotations per second
var orbit_radius: float = 15.0  # Distance from center
var orbit_height: float = 8.0   # Height above ground
var current_angle: float = 0.0

func _process(delta: float) -> void:
	current_angle += orbit_speed * TAU * delta
	
	global_position = Vector3(
		cos(current_angle) * orbit_radius,
		orbit_height,
		sin(current_angle) * orbit_radius
	)
	
	look_at(Vector3.ZERO)

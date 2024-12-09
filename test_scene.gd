# Main.gd
extends Node3D

var mesh_instance_template: MeshInstance3D
var meshes: Array[MeshInstance3D] = []
@onready var fps_label: Label = $Control/VBoxContainer/FPSLabel
@onready var polygon_count_label: Label = $Control/VBoxContainer/PolygonCountLabel
@onready var draw_calls_label: Label = $Control/VBoxContainer/DrawCallsLabel
@onready var model_count_label: Label = $Control/VBoxContainer/ModelCountLabel


@onready var add_models_button: Button = $Control/VBoxContainer2/AddModelsButton
@onready var remove_models_button: Button = $Control/VBoxContainer2/RemoveModelsButton
@onready var shadows_enable_button: Button = $Control/VBoxContainer2/ShadowsEnableButton
@onready var toggle_v_sync_button: Button = $Control/VBoxContainer2/ToggleVSyncButton

@onready var world_environment: WorldEnvironment = $WorldEnvironment


# Variable to store the monkey model's polygon count
var model_poly_count: int = 0

func _ready():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	add_models_button.pressed.connect(add_models)
	remove_models_button.pressed.connect(remove_models)	
	shadows_enable_button.toggled.connect(_toggle_shadows)
	toggle_v_sync_button.toggled.connect(_toggle_v_sync)
	
	# Load the monkey.glb model
	load_model_template("res://monkey.glb")
	
	
func load_model_template(model_file: String) -> void:
	var scene = load(model_file) # Adjust path as needed
	if scene:
		var model_instance = scene.instantiate()
		# Assuming the first child is our mesh, adjust if your model structure is different
		if model_instance.get_child(0) is MeshInstance3D:
			mesh_instance_template = model_instance.get_child(0).duplicate()
			# Count polygons in the model (assuming triangles)
			var mesh = mesh_instance_template.mesh
			if mesh:
				model_poly_count = mesh.get_faces().size() / 3
			model_instance.queue_free()


func _toggle_shadows(toggled: bool) -> void:
	$DirectionalLight3D.shadow_enabled = toggled


func _toggle_v_sync(_toggled: bool) -> void:
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func add_models(count: int = 10):
	for i in range(count):
		var instance = mesh_instance_template.duplicate()
		add_child(instance)
		
		# Add material to make the models visible
		var material = StandardMaterial3D.new()
		material.albedo_color = Color(randf(), randf(), randf())
		instance.material_override = material
		
		# Random position within a reasonable area
		instance.position = Vector3(
			randf_range(-7, 7),
			randf_range(0, 7),
			randf_range(-7, 7)
		)
		
		# Random rotation
		instance.rotation = Vector3(
			randf_range(0, PI),
			randf_range(0, PI),
			randf_range(0, PI)
		)
		
		meshes.append(instance)
	
	update_stats()

func remove_models(count: int = 10):
	count = mini(count, meshes.size())
	for i in range(count):
		if meshes.size() > 0:
			var mesh = meshes.pop_back()
			mesh.queue_free()
			
	update_stats()

func _process(_delta):
	update_stats()

func update_stats():
	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()
	
	var poly_count = format_number( meshes.size() * model_poly_count )  # Use actual model polygon count
	polygon_count_label.text = "Monkey Poly #: " + poly_count
	
	# Note: Draw calls are approximated here
	draw_calls_label.text = "Draw Calls: " +  format_number( RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME) ) 
	
	model_count_label.text = "Models: " + format_number(meshes.size()) 


func format_number(number: float) -> String:
	# Convert to string with 1 decimal place
	var text = "%.1f" % number
	
	# Split into integer and decimal parts
	var parts = text.split(".")
	var integer_part = parts[0]
	var decimal_part = parts[1] if parts.size() > 1 else ""
	
	# Add commas to integer part
	var formatted = ""
	var count = 0
	for i in range(integer_part.length() - 1, -1, -1):
		if count == 3:
			formatted = "," + formatted
			count = 0
		formatted = integer_part[i] + formatted
		count += 1
	
	# Add back decimal if it exists and isn't "0"
	if decimal_part != "" and decimal_part != "0":
		formatted += "." + decimal_part
		
	return formatted

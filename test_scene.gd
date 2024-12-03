# Main.gd
extends Node3D

var mesh_instance_template: MeshInstance3D
var meshes: Array[MeshInstance3D] = []

@onready var fps_label: Label = $Control/VBoxContainer/FPSLabel
@onready var polygon_count_label: Label = $Control/VBoxContainer/PolygonCountLabel
@onready var draw_calls_label: Label = $Control/VBoxContainer/DrawCallsLabel
@onready var model_count_label: Label = $Control/VBoxContainer/ModelCountLabel
@onready var add_models_button: Button = $Control/VBoxContainer/AddModelsButton
@onready var remove_models_button: Button = $Control/VBoxContainer/RemoveModelsButton


func _ready():
	
	add_models_button.pressed.connect(add_models)
	remove_models_button.pressed.connect(remove_models)	
	
	# Create a simple cube mesh as our test model
	var mesh = BoxMesh.new()
	mesh_instance_template = MeshInstance3D.new()
	mesh_instance_template.mesh = mesh
	

func add_models(count: int = 10):
	for i in range(count):
		var instance = mesh_instance_template.duplicate()
		add_child(instance)
		
		# Add material to make the cubes visible
		var material = StandardMaterial3D.new()
		material.albedo_color = Color(randf(), randf(), randf())
		instance.material_override = material
		
		# Random position within a reasonable area
		instance.position = Vector3(
			randf_range(-5, 5),
			randf_range(0, 5),
			randf_range(-5, 5)
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
	
	var poly_count = meshes.size() * 12  # 12 triangles in a cube
	polygon_count_label.text = "Polygons: %d" % poly_count
	
	# Note: Draw calls are approximated here
	draw_calls_label.text = "Draw Calls: %d" % meshes.size()
	
	model_count_label.text = "Models: %d" % meshes.size()

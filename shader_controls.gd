extends VBoxContainer


@onready var noshader_button: Button = $NoshaderButton
@onready var basic_grid_shader_button: Button = $BasicGridShaderButton
@onready var noise_shader_button: Button = $NoiseShaderButton
@onready var texture_shader_button: Button = $TextureShaderButton


@onready var ground_plane: MeshInstance3D = $"../../GroundPlane"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noshader_button.pressed.connect(_no_shader_click)
	basic_grid_shader_button.pressed.connect(_basic_grid_click)
	noise_shader_button.pressed.connect(_noise_shader_click)
	texture_shader_button.pressed.connect(_texture_shader_click)
	
func _noise_shader_click() -> void:
	var new_shader = load("res://shaders/noise.gdshader")
	ground_plane.get_surface_override_material(0).shader = new_shader

func _no_shader_click() -> void:
	var new_shader = load("res://shaders/basic.gdshader")
	ground_plane.get_surface_override_material(0).shader = new_shader

func _texture_shader_click() -> void:
	var new_shader = load("res://shaders/texture-offset.gdshader")
	var material = ground_plane.get_surface_override_material(0)
	material.shader = new_shader

	# Load your texture
	var texture = load("res://icon.svg")
	# Set the texture uniform
	material.set_shader_parameter("tex", texture)
	material.set_shader_parameter("tiling", Vector2(5.0, 5.0))

	
func _basic_grid_click() -> void:
	var new_shader = load("res://shaders/ground-grid.gdshader")
	ground_plane.get_surface_override_material(0).shader = new_shader

extends VBoxContainer

@onready var toggle_cpu_particles_button: Button = $ToggleCPUParticlesButton
@onready var toggle_gpu_particles_button: Button = $ToggleGPUParticlesButton
@onready var toggle_world_button: Button = $ToggleWorldButton



@onready var cpu_particle_label: Label3D = $"../../CPUParticleLabel"
@onready var cpu_particles: CPUParticles3D = $"../../CPUParticleLabel/CPUParticles"
@onready var gpu_particles_label: Label3D = $"../../GPUParticlesLabel"
@onready var gpu_particles_3d: GPUParticles3D = $"../../GPUParticlesLabel/GPUParticles3D"

@onready var cpu_particles_2: CPUParticles3D = $"../../CPUParticleLabel/CPUParticles2"
@onready var gpu_particles_3d_2: GPUParticles3D = $"../../GPUParticlesLabel/GPUParticles3D2"

@onready var world_environment: WorldEnvironment = $"../../WorldEnvironment"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_cpu_particles_button.toggled.connect(_cpu_particles_toggle)
	toggle_gpu_particles_button.toggled.connect(_gpu_particles_toggle)
	toggle_world_button.toggled.connect(_world_toggle)
	
	# start with GPU particles and CPU particles off
	_cpu_particles_toggle(false)
	_gpu_particles_toggle(false)
	_world_toggle(false)
	

func _world_toggle(toggled: bool) -> void:
	var environment = world_environment.environment
	
	if toggled:
		# Sky scenario
		environment.background_mode = Environment.BG_SKY
		
		# Create sky with physical material
		var sky = Sky.new()

		var sky_material: ProceduralSkyMaterial = ProceduralSkyMaterial.new()

		# Nice default sky colors
		sky_material.sky_top_color = Color(0.385, 0.454, 0.55)
		sky_material.sky_horizon_color = Color(0.646, 0.656, 0.67)
		sky_material.sky_curve = 0.05
		sky_material.energy_multiplier = 1.0
		
		# Ground colors
		sky_material.ground_bottom_color = Color(0.2, 0.169, 0.133)
		sky_material.ground_horizon_color = Color(0.646, 0.656, 0.67)
		sky_material.ground_curve = 0.12
		
		# Sun settings
		sky_material.sun_angle_max = 30.0
		sky_material.sun_curve = 0.15

		
		# set sky material
		sky.sky_material = sky_material
		environment.sky = sky
	else:
		# Solid color scenario
		environment.background_mode = Environment.BG_COLOR
		environment.background_color = Color(0.0, 0.3, 0.8)  # Adjust color as needed




func _cpu_particles_toggle(toggled: bool) -> void:
	cpu_particles.emitting = toggled
	cpu_particles_2.emitting = toggled
	cpu_particle_label.visible = toggled
	

func _gpu_particles_toggle(toggled: bool) -> void:
	gpu_particles_3d.emitting = toggled
	gpu_particles_3d_2.emitting = toggled
	gpu_particles_label.visible = toggled

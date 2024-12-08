extends VBoxContainer

@onready var toggle_cpu_particles_button: Button = $ToggleCPUParticlesButton
@onready var toggle_gpu_particles_button: Button = $ToggleGPUParticlesButton



@onready var cpu_particle_label: Label3D = $"../../CPUParticleLabel"
@onready var cpu_particles: CPUParticles3D = $"../../CPUParticleLabel/CPUParticles"
@onready var gpu_particles_label: Label3D = $"../../GPUParticlesLabel"
@onready var gpu_particles_3d: GPUParticles3D = $"../../GPUParticlesLabel/GPUParticles3D"

@onready var cpu_particles_2: CPUParticles3D = $"../../CPUParticleLabel/CPUParticles2"
@onready var gpu_particles_3d_2: GPUParticles3D = $"../../GPUParticlesLabel/GPUParticles3D2"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_cpu_particles_button.toggled.connect(_cpu_particles_toggle)
	toggle_gpu_particles_button.toggled.connect(_gpu_particles_toggle)
	
	# start with GPU particles and CPU particles off
	_cpu_particles_toggle(false)
	_gpu_particles_toggle(false)

func _cpu_particles_toggle(toggled: bool) -> void:
	cpu_particles.emitting = toggled
	cpu_particles_2.emitting = toggled
	cpu_particle_label.visible = toggled
	

func _gpu_particles_toggle(toggled: bool) -> void:
	gpu_particles_3d.emitting = toggled
	gpu_particles_3d_2.emitting = toggled
	gpu_particles_label.visible = toggled

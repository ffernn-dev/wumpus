@tool
extends MeshInstance3D

@export var length: float = 3:
	set(value):
		self.mesh.height = value
	get:
		return self.mesh.height

@export var thickness: float = 0.05:
	set(value):
		self.mesh.radius = value
	get:
		return self.mesh.radius

func set_red():
	var mat: StandardMaterial3D = get_surface_override_material(0)
	mat = mat.duplicate()
	mat.albedo_color = "#f00"
	set_surface_override_material(0, mat)

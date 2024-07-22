extends Node3D

var edge_node = preload("res://objects/minimap/edge.tscn")
@onready var root = $Edges
var connection_cache = {}


var _target_vertex_index: int = 0
@export var target_vertex_index: int = 0:
	set(value):
		if value > len(DodecahedronData.vertices) - 1:
			value = value % len(DodecahedronData.vertices)
		_target_vertex_index = value
		set_dodec_rotation(value)
	get:
		return _target_vertex_index


func _ready():
	$Edges.transform.basis = Basis()


func set_dodec_rotation(i):
	var target_vertex = DodecahedronData.vertices[i]

	var rotation_axis = Vector3.UP.cross(target_vertex).normalized() * -1
	var angle = acos(Vector3.UP.dot(target_vertex.normalized()))
	var rotation_basis = Basis(rotation_axis, angle)
	var rotation_quat = rotation_basis.get_rotation_quaternion()
	
	self.quaternion = rotation_quat
	draw_room_symbols()
	#$Edges.transform.basis = rotation_basis

func create_dodecahedron_edges():
	draw_room_symbols()
	
	for edge in DodecahedronData.edges:
		var start = DodecahedronData.vertices[edge[0]]
		var end = DodecahedronData.vertices[edge[1]]
		var mid_point = (start + end) / 2
		var direction = (end - start).normalized()

		var capsule_instance = edge_node.instantiate()
		
		if not connection_cache.get(str(edge[0])): connection_cache[str(edge[0])] = {}
		if not connection_cache.get(str(edge[1])): connection_cache[str(edge[1])] = {}
		connection_cache[str(edge[0])][str(edge[1])] = capsule_instance
		connection_cache[str(edge[1])][str(edge[0])] = capsule_instance
		
		root.add_child(capsule_instance)
		capsule_instance.transform.origin = mid_point

		var distance = start.distance_to(end)
		capsule_instance.length = distance + capsule_instance.thickness

		var up = Vector3(0, 1, 0)
		var axis = up.cross(direction).normalized()
		if axis.length() == 0:
			axis = Vector3(0, 0, 1)

		var angle = acos(up.dot(direction))
		var rotation_basis = Basis(axis, angle)

		# Apply the rotation to the transform
		capsule_instance.transform.basis = rotation_basis * capsule_instance.transform.basis

func update_connection_colour(start: String, end: String):
	var edge: MeshInstance3D = connection_cache[start][end]
	var mat: StandardMaterial3D = edge.get_surface_override_material(0)
	mat = mat.duplicate()
	mat.albedo_color = "#df203d"
	edge.set_surface_override_material(0, mat)

func turn_connection_red(source: String, dest: String):
	connection_cache[source][dest].set_red()

func draw_room_symbols():
	var virus_symbol := "🦠"
	
	for n in $Edges/Labels.get_children():
		$Edges/Labels.remove_child(n)
		n.queue_free()
	
	for i in range(len(DodecahedronData.vertices)):
		var label = Label3D.new()
		
		if GlobalData.rooms[i].contents.any(func(x): return x is Virus):
			label.text = virus_symbol
			label.font_size = 160
		else:
			label.text = str(i)
			label.font_size = 96

		var _vert_pos = DodecahedronData.vertices[i]
		var _vert_dir = _vert_pos.normalized()
		var _vert_dist = _vert_pos.distance_to(Vector3.ZERO)
		label.transform.origin = _vert_dir * (_vert_dist + 0.2)
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.pixel_size = 0.002
		$Edges/Labels.add_child(label)

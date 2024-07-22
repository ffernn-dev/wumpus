class_name Portal extends Area3D

@export var destination_id: int:
	get:
		return destination_id
	set(value):
		destination_id = value
		$Label3D.text = str(destination_id)
		if destination_id == 20:
			go_purple()

const colours = {"dark_green": "#009100", "green": "#1eca5a", "dark_red": "#8a0f18", "red": "b81924"}
@onready var creation_cooldown := $CreationCooldown
var emit_colour = ""

signal portal_entered(destination)


func close_door():
	$portal/DataStream.hide()
	$portal/OmniLight3D.hide()
	collision_layer = 0
	collision_mask = 0
	var mat: StandardMaterial3D = $SwitchPanel/Bulb.get_surface_override_material(0)
	mat = mat.duplicate()
	mat.albedo_color = colours.red
	mat.emission = colours.dark_red
	emit_colour = colours.dark_red
	$SwitchPanel/Bulb.set_surface_override_material(0, mat)
	$SwitchPanel/Bulb/OmniLight3D.light_color = colours.dark_red
	var source = str(GlobalData.current_room)
	var dest = str(destination_id)
	GlobalData.block_connection(source, dest)

func button_hover():
	var mat: StandardMaterial3D = $SwitchPanel/Bulb.get_surface_override_material(0)
	mat = mat.duplicate()
	mat.emission = Color.WHITE
	$SwitchPanel/Bulb.set_surface_override_material(0, mat)

func button_unhover():
	var mat: StandardMaterial3D = $SwitchPanel/Bulb.get_surface_override_material(0)
	mat = mat.duplicate()
	mat.emission = emit_colour
	$SwitchPanel/Bulb.set_surface_override_material(0, mat)

func _ready():
	var source = str(GlobalData.current_room)
	var dest = str(destination_id)
	if GlobalData.connections[source][dest] == GlobalData.CONNECTION_BLOCKED:
		close_door()
	elif GlobalData.connections[dest][source] == GlobalData.CONNECTION_BLOCKED:
		# Shouldn't get here but worth the check anyway
		close_door()
	else:
		var mat: StandardMaterial3D = $SwitchPanel/Bulb.get_surface_override_material(0)
		mat = mat.duplicate()
		mat.albedo_color = colours.green
		mat.emission = colours.dark_green
		$SwitchPanel/Bulb.set_surface_override_material(0, mat)
		emit_colour = colours.dark_green
		$SwitchPanel/Bulb/OmniLight3D.light_color = colours.dark_green


func _on_body_entered(body):
	# Creation cooldown is a bit of a hack to fix a mystery bug
	# wherin the player would move rooms again immediately after moving once
	# I think it's some wierd physics desync, but this fixes it.
	if body is Player and creation_cooldown.is_stopped():
		portal_entered.emit(destination_id)
		# print("to room ", destination_id)

func go_purple():
	var mat: StandardMaterial3D = $portal/Body.get_surface_override_material(0)
	mat = mat.duplicate()
	mat.albedo_color = Color("#7000c0")
	$portal/DataStream.hide()
	$SwitchPanel.hide()
	$portal/Body.set_surface_override_material(0, mat)

class_name Portal extends Area3D

@export var destination_id: int:
	get:
		return destination_id
	set(value):
		destination_id = value
		$Label3D.text = str(destination_id)
		if destination_id == 20:
			go_purple()


signal portal_entered(destination)

@onready var creation_cooldown := $CreationCooldown

func _on_body_entered(body):
	# Creation cooldown is a bit of a hack to fix a mystery bug
	# wherin the player would move rooms again immediately after moving once
	# I think it's some wierd physics desync, but this fixes it.
	if body is Player and creation_cooldown.is_stopped():
		portal_entered.emit(destination_id)
		print("to room ", destination_id)

func go_purple():
	var mat: StandardMaterial3D = $portal/Body.get_surface_override_material(0)
	mat = mat.duplicate()
	mat.albedo_color = Color("#7000c0")
	$portal/DataStream.hide()
	$portal/Body.set_surface_override_material(0, mat)

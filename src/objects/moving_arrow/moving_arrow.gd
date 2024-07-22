extends RigidBody3D

var initial_vel = 28

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(-transform.basis.z * initial_vel, transform.basis.z)
	$arrow/Rot.hide()
	$arrow/Rot_001.hide()
	$arrow/Rot_002.hide()



func _on_body_entered(body):
	body.take_damage(1)
	call_deferred("disable")
	call_deferred("reparent", body, true)

func disable():
	process_mode = Node.PROCESS_MODE_DISABLED

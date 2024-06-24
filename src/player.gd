class_name Player extends CharacterBody3D


const MAX_SPEED = 5.0 #m/s
const ACCEL = 100 #m/s^2
const JUMP_HEIGHT = 1.5 #m
const CAMERA_SENSITIVITY = 1

var jumping := false
var mouse_captured := false

# Default project gravity to sync with physics objects
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera := $Neck/Eyes

var input_vec: Vector2 # Movement direction given by input keys
var look_vec: Vector2 # Input direction for look/aim

var walk_vel: Vector3
var gravity_vel: Vector3
var jump_vel: Vector3


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_vec = event.relative * 0.001
		_rotate_camera()
	if Input.is_action_just_pressed("jump"): jumping = true
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	if Input.is_action_just_pressed("toggle_mouse_capture"): toggle_mouse_capture()


func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_vec.x * CAMERA_SENSITIVITY * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_vec.y * CAMERA_SENSITIVITY * sens_mod, -1.5, 1.5)


func _walk(delta: float):
	input_vec = Input.get_vector("left", "right", "forward", "backward")
	var forward: Vector3 = camera.global_transform.basis * Vector3(input_vec.x, 0, input_vec.y)
	var global_walk_dir: Vector3 = Vector3(forward.x, 0, forward.z).normalized()
	walk_vel = walk_vel.move_toward(global_walk_dir * MAX_SPEED * input_vec.length(), ACCEL * delta)
	return walk_vel


func _gravity(delta: float) -> Vector3:
	gravity_vel = Vector3.ZERO if is_on_floor() else gravity_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return gravity_vel


func _jump(delta: float) -> Vector3:
	if jumping:
		if is_on_floor(): jump_vel = Vector3(0, sqrt(4 * JUMP_HEIGHT * gravity), 0)
		jumping = false
		return jump_vel
	jump_vel = Vector3.ZERO if is_on_floor() else jump_vel.move_toward(Vector3.ZERO, gravity * delta)
	return jump_vel


func _physics_process(delta: float) -> void:
	velocity = _walk(delta) + _jump(delta) + _gravity(delta)
	move_and_slide()

func toggle_mouse_capture():
	var mode = Input.MOUSE_MODE_VISIBLE if mouse_captured else Input.MOUSE_MODE_CAPTURED
	Input.set_mouse_mode(mode)
	mouse_captured = !mouse_captured

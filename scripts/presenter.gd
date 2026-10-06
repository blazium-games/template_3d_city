extends Node3D

const Rules = preload("res://scripts/rules.gd")
var rules = Rules.new()

@onready var walker: CharacterBody3D = $Walker
@onready var rig_eye: Camera3D = $RigEye

func _ready() -> void:
	rig_eye.look_at(Vector3.ZERO)
	if not rules.scale_accepted(1.0):
		push_error("City scale must be 1.")
	var widths := rules.block_widths(7)
	var cursor := -6.0
	for width in widths:
		var block := MeshInstance3D.new()
		var box_mesh := BoxMesh.new()
		box_mesh.size = Vector3(float(width), 2, 2)
		block.mesh = box_mesh
		block.position = Vector3(cursor, 1, 0)
		var body := StaticBody3D.new()
		body.position = block.position
		var shape := CollisionShape3D.new()
		var col := BoxShape3D.new()
		col.size = box_mesh.size
		shape.shape = col
		body.add_child(shape)
		add_child(block)
		add_child(body)
		cursor += float(width) + 1.0

func _physics_process(_delta: float) -> void:
	var wish := Vector2(
		Input.get_action_strength("stride_east") - Input.get_action_strength("stride_west"),
		Input.get_action_strength("stride_south") - Input.get_action_strength("stride_north")
	)
	walker.velocity.x = wish.x * 3.0
	walker.velocity.z = wish.y * 3.0
	if not walker.is_on_floor():
		walker.velocity.y -= 12.0 * _delta
	walker.move_and_slide()
	rig_eye.look_at(walker.global_position)
	if Input.is_action_just_pressed("primary"):
		rules.open_bar()
	if not rules.may_cross() and walker.position.z < -2.0:
		walker.position.z = -2.0
	elif rules.may_cross() and walker.position.z < -5.0:
		_go("res://scenes/cross.tscn")

func _go(next_path: String) -> void:
	get_tree().change_scene_to_file(next_path)

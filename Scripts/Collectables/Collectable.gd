extends Sprite3D

class_name Collectable

# Reference Objects
@export_node_path(RigidDynamicBody3D) var playerNodePath
var player : RigidDynamicBody3D

@export_node_path(CanvasLayer) var hudNodePath
var hud : CanvasLayer

@export_node_path(Node3D) var gameManagerNodePath
var gameManager : Node3D

# Class Properties
var collisionArea : Area3D
var collisionSize : Vector3 = Vector3.ZERO

func _ready() -> void:
	# Assign References
	player = get_node(playerNodePath)
	hud = get_node(hudNodePath)
	gameManager = get_node(gameManagerNodePath)
	pass

func _process(_delta) -> void:
	if collisionArea != null and player != null:
		if collisionArea.overlaps_body(player):
			onOverlap()
			queue_free()
	pass
	
func generateCollisionShape(size) -> void:
	collisionArea = Area3D.new()
	add_child(collisionArea)
	
	var collisionShape = CollisionShape3D.new()
	collisionShape.shape = BoxShape3D.new()
	collisionShape.shape.set("Size", size)
	collisionArea.add_child(collisionShape)
	pass
	
func onOverlap() -> void:
	pass

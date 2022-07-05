extends Node3D

# Reference Objects
@export_node_path(Node3D) var playerBodyNodePath
var player : RigidDynamicBody3D

@export_node_path(CanvasLayer) var hudNodePath
var hud : CanvasLayer

@export_node_path(Node3D) var gameManagerNodePath
var gameManager : Node3D

func _ready() -> void:
	# Assign References
	hud = get_node(hudNodePath)
	player = get_node(playerBodyNodePath)
	gameManager = get_node(gameManagerNodePath)
	
	# Establish Node Tree
	generateCollection()
	pass 

func _process(delta) -> void:
	for collectableChildren in get_children():
		collectableChildren.rotation.y += 5 * delta
	pass
	
func generateNewCoinCollectable(root) -> void:
	var newCollec = CoinCollectable.new()
	newCollec.hud = get_node(hudNodePath)
	newCollec.player = get_node(playerBodyNodePath)
	newCollec.gameManager = get_node(gameManagerNodePath)
	newCollec.texture = load("res://Textures/UI/Star 1.png")
	newCollec.modulate = Color.FIREBRICK
	root.add_child(newCollec)
	pass
	
func generateNewPowerupCollectable(root) -> void:
	var newCollec = PowerupCollectable.new()
	newCollec.hud = get_node(hudNodePath)
	newCollec.player = get_node(playerBodyNodePath)
	newCollec.gameManager = get_node(gameManagerNodePath)
	newCollec.texture = load("res://Textures/UI/PowerupIcon.png")
	root.add_child(newCollec)
	pass
	
func generateCollection() -> void:
	for collectableChildren in get_children():
		if collectableChildren.get_child_count() == 0:
			if collectableChildren.currentCollectableType == CollectableType.collectableType.DASH_POWERUP:
				generateNewPowerupCollectable(collectableChildren)
			elif collectableChildren.currentCollectableType == CollectableType.collectableType.COIN:
				generateNewCoinCollectable(collectableChildren)
	pass
	
func reset() -> void:
	for collectableChildren in get_children():
		if collectableChildren.get_child_count() == 0:
			if collectableChildren.currentCollectableType == CollectableType.collectableType.DASH_POWERUP:
				generateNewPowerupCollectable(collectableChildren)
				gameManager.removePowerup()
			elif collectableChildren.currentCollectableType == CollectableType.collectableType.COIN:
				generateNewCoinCollectable(collectableChildren)
				gameManager.decrease()
	pass

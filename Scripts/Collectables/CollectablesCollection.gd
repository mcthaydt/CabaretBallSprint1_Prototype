extends Node3D

@export_node_path(Node3D) var playerBodyNodePath
var player : RigidDynamicBody3D

@export_node_path(CanvasLayer) var hudNodePath
var HUD : CanvasLayer

@onready var collectableSlot1 = $CollectableSlot1
@onready var collectableSlot2 = $CollectableSlot2
@onready var collectableSlot3 = $CollectableSlot3
@onready var collectableSlot4 = $CollectableSlot4
@onready var collectableSlot5 = $CollectableSlot5
@onready var collectableSlot6 = $CollectableSlot6

func _ready():
	HUD = get_node(hudNodePath)
	player = get_node(playerBodyNodePath)
	generateNewCoinCollectable(collectableSlot1)
	generateNewCoinCollectable(collectableSlot2)
	generateNewCoinCollectable(collectableSlot3)
	generateNewCoinCollectable(collectableSlot4)
	generateNewCoinCollectable(collectableSlot5)
	generateNewPowerupCollectable(collectableSlot6)
	pass 

func _process(delta):
	collectableSlot1.rotation.y += 5 * delta
	collectableSlot2.rotation.y += 5 * delta
	collectableSlot3.rotation.y += 5 * delta
	collectableSlot4.rotation.y += 5 * delta
	collectableSlot5.rotation.y += 5 * delta
	collectableSlot6.rotation.y += 3 * delta
	pass
	
func generateNewCoinCollectable(root):
	var newCollec = CoinCollectable.new()
	newCollec.hud = get_node(hudNodePath)
	newCollec.player = get_node(playerBodyNodePath)
	newCollec.texture = load("res://Textures/UI/Star 1.png")
	newCollec.modulate = Color.FIREBRICK
	root.add_child(newCollec)
	pass
	
func generateNewPowerupCollectable(root):
	var newCollec = PowerupCollectable.new()
	newCollec.hud = get_node(hudNodePath)
	newCollec.player = get_node(playerBodyNodePath)
	newCollec.texture = load("res://Textures/UI/PowerupIcon.png")
	root.add_child(newCollec)
	pass
	
func reset():
	if collectableSlot1.get_child_count() == 0:
		generateNewCoinCollectable(collectableSlot1)
		HUD.decrease()
	if collectableSlot2.get_child_count() == 0:
		generateNewCoinCollectable(collectableSlot2)
		HUD.decrease()
	if collectableSlot3.get_child_count() == 0:
		generateNewCoinCollectable(collectableSlot3)
		HUD.decrease()
	if collectableSlot4.get_child_count() == 0:
		generateNewCoinCollectable(collectableSlot4)
		HUD.decrease()
	if collectableSlot5.get_child_count() == 0:
		generateNewCoinCollectable(collectableSlot5)
		HUD.decrease()
	if collectableSlot6.get_child_count() == 0:
		generateNewPowerupCollectable(collectableSlot6)
		HUD.removePowerup()
	pass

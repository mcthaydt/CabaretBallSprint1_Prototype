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

func _ready():
	HUD = get_node(hudNodePath)
	player = get_node(playerBodyNodePath)
	generateNewCollectable(collectableSlot1)
	generateNewCollectable(collectableSlot2)
	generateNewCollectable(collectableSlot3)
	generateNewCollectable(collectableSlot4)
	generateNewCollectable(collectableSlot5)
	pass 

func _process(_delta):
	pass
	
func generateNewCollectable(root):
	var newCollec = Collectable.new()
	newCollec.hud = get_node(hudNodePath)
	newCollec.player = get_node(playerBodyNodePath)
	newCollec.texture = load("res://Textures/icon.png")
	root.add_child(newCollec)
	pass
	
func reset():
	if collectableSlot1.get_child_count() == 0:
		generateNewCollectable(collectableSlot1)
		HUD.decrease()
	if collectableSlot2.get_child_count() == 0:
		generateNewCollectable(collectableSlot2)
		HUD.decrease()
	if collectableSlot3.get_child_count() == 0:
		generateNewCollectable(collectableSlot3)
		HUD.decrease()
	if collectableSlot4.get_child_count() == 0:
		generateNewCollectable(collectableSlot4)
		HUD.decrease()
	if collectableSlot5.get_child_count() == 0:
		generateNewCollectable(collectableSlot5)
		HUD.decrease()
	pass

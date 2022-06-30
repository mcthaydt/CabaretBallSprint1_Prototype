extends Node3D

@onready var area3D = $Area3D

@export_node_path(Node3D) var playerBodyNodePath
var playerBody : RigidDynamicBody3D

@export_node_path(Node3D) var gameManagerNodePath
var gameManager : Node3D

var tempTimer = 0
var tempBool = false
func _ready():
	playerBody = get_node(playerBodyNodePath)
	gameManager = get_node(gameManagerNodePath)
	pass 

func _process(delta):
	rotation.z += 2 * delta
	if tempBool:
		Engine.time_scale = 0.1
		tempTimer += delta
		if tempTimer > 2 * 0.1:
			Engine.time_scale = 1
			gameManager.respawnPlayer()
			tempTimer = 0
			tempBool = false
	if area3D.overlaps_body(playerBody):
		tempBool = true
	pass


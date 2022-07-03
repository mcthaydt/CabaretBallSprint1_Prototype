extends Node3D

@onready var area3D = $Area3D

@export_node_path(Node3D) var playerBodyNodePath
var playerBody : RigidDynamicBody3D

@export_node_path(Node3D) var gameManagerNodePath
var gameManager : Node3D

@export_node_path(Camera3D) var cameraNodePath
var cam : Camera3D

@export_node_path(Label3D) var currentTimeLabelPath
var curTimeLabel : Label3D

var tempTimer = 0
var tempBool = false

func _ready():
	playerBody = get_node(playerBodyNodePath)
	gameManager = get_node(gameManagerNodePath)
	cam = get_node(cameraNodePath)
	curTimeLabel = get_node(currentTimeLabelPath)
	pass 

func _process(delta):
	rotation.z += 2 * delta
	if tempBool:
		Engine.time_scale = 0.1
		tempTimer += delta
		cam.rotation.z += 2*delta
		curTimeLabel.waitingForReset = true
		if tempTimer > 2 * 0.1:
			Engine.time_scale = 1
			gameManager.respawnPlayer(delta)
			tempTimer = 0
			curTimeLabel.waitingForReset = false
			curTimeLabel.resetTimer()
			tempBool = false
	if area3D.overlaps_body(playerBody):
		tempBool = true
	pass


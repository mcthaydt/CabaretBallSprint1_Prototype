extends Node3D

# Reference Objects
@export_node_path(RigidDynamicBody3D) var playerNodePath
var player : RigidDynamicBody3D

@export_node_path(Node3D) var gameManagerNodePath
var gameManager : Node3D

@export_node_path(Camera3D) var cameraNodePath
var cam : Camera3D

@export_node_path(Label3D) var currentTimeLabelPath
var curTimeLabel : Label3D

@onready var area3D = $Area3D

# Class Properties
@export var winSequenceDuration : float = 2.0
@export var slowMotionPercentage : float = 10
var postWinTimer : float = 0.0
var activateWinSequence : float = false

func _ready() -> void:
	# Assign References
	player = get_node(playerNodePath)
	gameManager = get_node(gameManagerNodePath)
	cam = get_node(cameraNodePath)
	curTimeLabel = get_node(currentTimeLabelPath)
	pass 

func _process(delta) -> void:
	# Pre-Win
	applyGoalAnimation(delta)
	
	# Win Conditons
	if area3D.overlaps_body(player):
		activateWinSequence = true	
		
	# Post-Win
	if activateWinSequence:
		Engine.time_scale = (slowMotionPercentage * .01)
		postWinTimer += delta
		curTimeLabel.waitingForReset = true
		applyCameraAnimation(delta)
		
		if postWinTimer > winSequenceDuration * (slowMotionPercentage * .01):
			Engine.time_scale = 1.0
			postWinTimer = 0.0
			gameManager.wonRound = true
			#gameManager.respawnPlayer(delta)
			curTimeLabel.resetTimer()
			curTimeLabel.waitingForReset = false
			activateWinSequence = false
	pass

func applyGoalAnimation(delta) -> void:
	rotation.z += 2 * delta
	pass
	
func applyCameraAnimation(delta) -> void:
	rotation.z += 2 * delta
	pass

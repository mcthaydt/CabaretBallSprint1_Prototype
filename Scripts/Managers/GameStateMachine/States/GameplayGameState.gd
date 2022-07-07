extends BaseGameState

# Load Required Components
const GameplayState = preload("res://GameStates/GameplayState.tscn")	
var gameplayStateInstance

# Transitions 
@export_node_path(Node) var failureNodePath
var failureNode
@export_node_path(Node) var successNodePath
var successNode

func init():
	failureNode = get_node(failureNodePath)
	successNode = get_node(successNodePath)
	
	gameplayStateInstance = GameplayState.instantiate()
	self.add_child(gameplayStateInstance)
	
	onEnter()
	pass

func onEnter() -> void:
	pass
	
func onUpdate() -> void:
	if gameplayStateInstance.curLivesRemaining < 0:
		nextState = failureNode
		exitConditionsFulfilled = true
	
	if gameplayStateInstance.wonRound == true:
		nextState = successNode
		exitConditionsFulfilled = true	
	pass
	
func onExit() -> void:
	if gameplayStateInstance != null:
		gameplayStateInstance.queue_free()
	pass

extends Node

@onready var IntroState = $Intro
@onready var GameplayState = $Gameplay
@onready var FailureState = $Failure
@onready var SuccessState = $Success
var curState : Node = null

func _ready():
	curState = GameplayState
	init()
	pass

func _process(_delta):
	onUpdate()
	pass
	
func init():
	curState.init()
	pass

func onEnter():
	curState.onEnter()
	pass
	
func onUpdate():
	if !curState.exitConditionsFulfilled:
		curState.onUpdate()
	else:
		onExit()
	pass
	
func onExit():
	curState.onExit()
	curState.switchState(curState.nextState)
	pass

func switchState(_nextState):
	if curState != _nextState:
		curState = _nextState
	if _nextState == null:
		get_tree().quit()
	pass

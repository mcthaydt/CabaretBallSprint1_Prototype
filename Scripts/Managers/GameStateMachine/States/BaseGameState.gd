extends Node

class_name BaseGameState

var exitConditionsFulfilled : bool = false
var nextState : Node = null
	
func init():
	pass

func onEnter():
	pass
	
func onUpdate():
	pass
	
func onExit():
	pass

func switchState(_nextState):
	pass

extends Label3D

# Reference Objects
@export_node_path(Node3D) var followObjectNodePath
var followObject : Node3D

# Class Properties
@export var textLabelOffset : Vector3 = Vector3.ZERO
var curTime : float = 0

# State Checking
var waitingForReset : bool = false

func _ready() -> void:
	# Assign References
	followObject = get_node(followObjectNodePath)
	
	# Assign Basline Settings 
	top_level = true
	
	if textLabelOffset == Vector3.ZERO:
		textLabelOffset = Vector3(2, 0, 0)
	pass 

func _process(delta) -> void:
	#Update Timer
	if !waitingForReset:
		curTime += delta
		
	# Update Text
	text = str(curTime).pad_zeros(2).pad_decimals(2).replace(".", ":")
	
	# Update Position
	global_transform.origin = followObject.global_transform.origin + textLabelOffset
	pass

func resetTimer() -> void:
	curTime = 0
	pass

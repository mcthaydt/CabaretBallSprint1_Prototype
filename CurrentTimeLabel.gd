extends Label3D

@export var camOffset : Vector3 = Vector3(0,3,2)
@export_node_path(Node3D) var followObjectNodePath
var followObject : Node3D

var curGameplayTime = 0
var waitingForReset = false
func _ready():
	top_level = true
	followObject = get_node(followObjectNodePath)
	pass 


func _process(delta):
	if !waitingForReset:
		curGameplayTime += delta
	text = str(curGameplayTime).pad_zeros(2).pad_decimals(2).replace(".", ":")
	global_transform.origin = followObject.global_transform.origin + camOffset
	pass

func resetTimer():
	curGameplayTime = 0
	pass

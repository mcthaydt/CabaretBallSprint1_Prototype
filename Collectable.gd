extends Sprite3D

class_name Collectable

var player : RigidDynamicBody3D
var hud : CanvasLayer
var area3D : Area3D

func _ready():
	area3D = Area3D.new()
	add_child(area3D)
	
	var collisionShape = CollisionShape3D.new()
	collisionShape.shape = BoxShape3D.new()
	collisionShape.shape.set("Size", Vector3(0.929, 0.824, 0.628))
	area3D.add_child(collisionShape)
	pass


func _process(delta):
	if area3D != null and player != null:
		if area3D.overlaps_body(player):
			hud.increase()
			queue_free()
	pass

extends Collectable

class_name CoinCollectable 

func _ready():
	collisionSize = Vector3(0.929, 0.824, 0.628)
	generateCollisionShape(collisionSize)
	pass

func applyOverlap():
	hud.increase()
	pass

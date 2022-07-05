extends Collectable

class_name CoinCollectable 

func _ready() -> void:
	collisionSize = Vector3(0.929, 0.824, 0.628)
	generateCollisionShape(collisionSize)
	pass

func onOverlap() -> void:
	gameManager.increase()
	pass

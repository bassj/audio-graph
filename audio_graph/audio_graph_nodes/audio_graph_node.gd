@abstract
extends Resource
class_name AudioGraphNode

func sample(_increment: float) -> float:
	assert(false, "sample() not implemented in subclass")
	return 0.0

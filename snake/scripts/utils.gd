extends Node

#creates repeat function, file can be deleted once we have collision
func repeat(value: float, length: float) -> float:
	return fposmod(value, length)

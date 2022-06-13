extends Node2D

const DISPARO = preload("res://Scripts/Disparo.gd")

var tMin = 1.0
var tMax = 3.0

var tSiguiente = tMax
var t = 0

func _ready():
	pass

func _process(delta):
	tSiguiente += -delta
	if(t >= tSiguiente):
		t = 0
		tSiguiente = tMin + randf() * (tMax - tMin)
		var disparo = DISPARO

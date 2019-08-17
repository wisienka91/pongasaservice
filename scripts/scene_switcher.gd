#source: https://godotengine.org/qa/1883/transfering-a-variable-over-to-another-scene?show=6450#a6450
extends Node


var _params = null


func switch_scene(new_scene, params=null):
	_params = params
	# warning-ignore:return_value_discarded
	get_tree().change_scene(new_scene)


func get_param(name):
	if (_params != null and _params.has(name)):
		return _params[name]
	return null

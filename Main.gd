extends Control

export(NodePath) var dropDownPath
onready var dropDown = get_node(dropDownPath)

func _ready():
	print("requesting releases")
	$HTTPRequest.request("https://api.github.com/repos/godotengine/godot/releases")

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	print("requests complete")
	if response_code != 200:
		push_error("json request failed \n error: " + response_code)
	var jsonData = JSON.parse(body.get_string_from_utf8())
	
	if typeof(jsonData.result) == TYPE_ARRAY:
		dropDown.remove_item(0)
		dropDown.add_item("Latest")
		dropDown.select(0)
		for i in jsonData.result.size():
			dropDown.add_item(jsonData.result[i].name)
	else:
		push_error("JSON parse fail")


func _on_Launch_Version_pressed():
	pass

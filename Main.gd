extends Control

export(NodePath) var dropDownPath
onready var dropDown = get_node(dropDownPath)

func _ready():
	
	$HTTPRequest.request("https://api.github.com/repos/godotengine/godot/tags")

func _on_HTTPRequest_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		push_error("json request failed \n error: " + response_code)
	var jsonData = JSON.parse(body.get_string_from_utf8())
	
	if typeof(jsonData.result) == TYPE_ARRAY:
		dropDown.add_item("Latest")
		for i in jsonData.result.size():
			dropDown.add_item(jsonData.result[i].name)
	else:
		push_error("JSON parse fail")

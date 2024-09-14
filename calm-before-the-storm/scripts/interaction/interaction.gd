extends Area2D

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"

"""
This is just an example of interaction that can be hooked up to npcs
TODO: Maybe have a global class that holds the days along with the dialogues
that will be unique PER day
Unfortunately, I had to do this with creating a singleton
to share player behavior across the entire project.
I think Godot enforces this... Sadly.
"""

func interact() -> PlayerBehavior.INTERACTIONS:
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	return PlayerBehavior.INTERACTIONS.TALK

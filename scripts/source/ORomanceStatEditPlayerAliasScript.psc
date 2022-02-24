ScriptName ORomanceStatEditPlayerAliasScript Extends ReferenceAlias

ORomanceStatEditScript Property orse Auto

Event OnInit()
	orse = (GetOwningQuest()) as ORomanceStatEditScript
EndEvent

Event OnPlayerLoadGame()
	orse.OnLoad()
EndEvent

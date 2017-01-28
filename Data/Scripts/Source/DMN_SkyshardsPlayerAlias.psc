ScriptName DMN_SkyshardsPlayerAlias Extends ReferenceAlias

{Skyshards - Player Alias Script by Deadmano.

Allows the Maintenance function in the Skyshards
Config script to run on each save game load.
}
 
DMN_SkyshardsConfig Property DMN_SC Auto

Event OnPlayerLoadGame()
	DMN_SC.Maintenance()
EndEvent
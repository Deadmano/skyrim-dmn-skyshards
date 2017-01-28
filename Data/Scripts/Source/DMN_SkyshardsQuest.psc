ScriptName DMN_SkyshardsQuest Extends Quest  
{Helper scripts that handles all Skyshards
quest related matters.
}

Import Debug

GlobalVariable Property DMN_SkyshardsCountCurrent Auto
{The current amount of Skyshards the player has activated throughout Skyrim and
other DLCs/Mods which resets once it reaches DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountCap Auto
{The amount of Skyshard absorptions required before gaining a perk point. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim and other DLCs/Mods. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim and other DLCs/Mods. Auto-Fill.}

Quest Property DMN_Skyshards Auto
{The quest that handles all Skyshards and tracks them. Auto-Fill.}

Quest Property DMN_SkyshardsSkyrim Auto
{The quest that handles the Skyshards in Skrim. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable. Auto-Fill.}

ReferenceAlias Property DMN_SkyshardTest01 Auto

Function updateSkyshardsGlobals()

	DMN_Skyshards.UpdateCurrentInstanceGlobal(DMN_SkyshardsCountCurrent)
	DMN_Skyshards.UpdateCurrentInstanceGlobal(DMN_SkyshardsCountCap)

EndFunction

Function startSkyshardsSkyrim()
	If (!DMN_SkyshardsSkyrim.IsRunning())
		If (DMN_SkyshardsDebug.GetValue() == 1)
			Notification("The main quest is not running! Starting it now.")
		EndIf
		DMN_SkyshardsSkyrim.Start()
		DMN_SkyshardsSkyrim.SetStage(10)
		DMN_SkyshardsSkyrim.SetObjectiveDisplayed(10)
	EndIf
EndFunction
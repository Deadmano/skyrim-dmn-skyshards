ScriptName DMN_SkyshardsQuest Extends Quest  
{Helper scripts that handles all Skyshards
quest related matters.
}

Import DMN_DeadmaniacFunctions
Import Debug

GlobalVariable Property DMN_SkyshardsCountCurrent Auto
{The current amount of Skyshards the player has activated throughout Skyrim and
other DLCs/Mods which resets once it reaches DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountCap Auto
{The amount of Skyshard absorptions required before gaining a perk point. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsSkyrimCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsSkyrimCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim and other DLCs/Mods. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim and other DLCs/Mods. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable. Auto-Fill.}

Quest Property DMN_Skyshards Auto
{The quest that handles all Skyshards and tracks them. Auto-Fill.}

Quest Property DMN_SkyshardsSkyrim Auto
{The quest that handles the Skyshards in Skyrim. Auto-Fill.}

Function updateSkyshardsGlobals()
; Main Quest - Skyshards
	skyshardsGlobalUpdater(DMN_Skyshards, DMN_SkyshardsCountCurrent)
	skyshardsGlobalUpdater(DMN_Skyshards, DMN_SkyshardsCountCap)
	skyshardsGlobalUpdater(DMN_Skyshards, DMN_SkyshardsSkyrimCountActivated)
	skyshardsGlobalUpdater(DMN_Skyshards, DMN_SkyshardsSkyrimCountTotal)
	skyshardsGlobalUpdater(DMN_Skyshards, DMN_SkyshardsCountActivated)
	skyshardsGlobalUpdater(DMN_Skyshards, DMN_SkyshardsCountTotal)
	
; Side Quest - Skyshards: Skyrim
	skyshardsGlobalUpdater(DMN_SkyshardsSkyrim, DMN_SkyshardsSkyrimCountActivated)
	skyshardsGlobalUpdater(DMN_SkyshardsSkyrim, DMN_SkyshardsSkyrimCountTotal)
EndFunction

Function skyshardsGlobalUpdater(Quest questName, GlobalVariable globalName)
	questName.UpdateCurrentInstanceGlobal(globalName)
EndFunction

Function startSkyshardsSkyrim()
	If (!DMN_SkyshardsSkyrim.IsRunning())
	;Debugger.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: The Skyshards in Skyrim quest is not running! Starting it now.")
		DMN_SkyshardsSkyrim.Start()
		updateSkyshardsGlobals()
		DMN_SkyshardsSkyrim.SetStage(10)
		updateSkyshardsQuestProgress()
	EndIf
EndFunction

Function updateSkyshardsQuestProgress()

;Check progress of Skyshards in Skyrim side quest.
	If (DMN_SkyshardsSkyrimCountActivated.GetValue() as Int == DMN_SkyshardsSkyrimCountTotal.GetValue() as Int)
	;Debugger.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You found all the Skyshards in Skyrim! Marking quest as complete now.")
	;Complete the Skyshards in Skyrim side quest.
		DMN_SkyshardsSkyrim.SetObjectiveCompleted(10)
		DMN_SkyshardsSkyrim.CompleteQuest()
	EndIf
;Show quest objective for Skyshards in Skyrim side quest if on the right stage.
	If (DMN_SkyshardsSkyrim.GetCurrentStageID() == 10)
		DMN_SkyshardsSkyrim.SetObjectiveDisplayed(10, true, true)
	EndIf
EndFunction

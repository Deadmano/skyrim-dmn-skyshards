; Copyright (C) 2017 Phillip Stolić
; 
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

ScriptName DMN_SkyshardsQuest Extends Quest  
{Helper script that handles all Skyshards
quest related matters.
}

Import Debug
Import Game
Import DMN_DeadmaniacFunctions
Import DMN_SkyshardsFunctions

DMN_SkyshardsQuestData Property DMN_SQD Auto

GlobalVariable Property DMN_SkyshardsCountCurrent Auto
{The current amount of Skyshards the player has activated throughout Skyrim and
other DLCs/Mods which resets once it reaches DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountCap Auto
{The amount of Skyshard absorptions required before gaining a perk point. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim and other DLCs/Mods. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim and other DLCs/Mods. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable. Auto-Fill.}

; SKYRIM VARIABLES
; ----------------
GlobalVariable Property DMN_SkyshardsSkyrimCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim. Auto-Fill.}
GlobalVariable Property DMN_SkyshardsSkyrimCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim. Auto-Fill.}

; MAIN QUESTS
; -----------
Quest Property DMN_Skyshards Auto
{The quest that handles all Skyshards and tracks them. Auto-Fill.}
Quest Property DMN_SkyshardsSkyrim Auto
{The quest that handles the Skyshards in Skyrim. Auto-Fill.}

Quest[] mainQuest ; Initialises an empty array to store all main quests.
GlobalVariable[] mainQuestGlobal ; Initialises an empty array to store all main quest globals.

Function buildArrays()
	mainQuest = new Quest[2]
	mainQuest[0] = DMN_Skyshards
	mainQuest[1] = DMN_SkyshardsSkyrim
	
	mainQuestGlobal = new GlobalVariable[6]
	mainQuestGlobal[0] = DMN_SkyshardsCountCurrent
	mainQuestGlobal[1] = DMN_SkyshardsCountCap
	mainQuestGlobal[2] = DMN_SkyshardsCountActivated
	mainQuestGlobal[3] = DMN_SkyshardsCountTotal
	mainQuestGlobal[4] = DMN_SkyshardsSkyrimCountActivated
	mainQuestGlobal[5] = DMN_SkyshardsSkyrimCountTotal
EndFunction

Function updateGlobals()
	buildArrays()
	Int i = mainQuest.Length
	Int j = mainQuestGlobal.Length
	While (i)
		i -= 1
		While (j)
			j -= 1
		; For each main quest that is running, update every global variable attached to it.
			If (mainQuest[i].IsRunning())
				mainQuest[i].UpdateCurrentInstanceGlobal(mainQuestGlobal[j])
			EndIf
		EndWhile
		j = mainQuestGlobal.Length
	EndWhile
EndFunction

Function updateMainQuests(Bool bFinalise = False, Bool bSilent = False)
Bool skyrimCompleted = False
; Check progress of Skyshards in Skyrim main quest.
;==================================================
; If all Skyshards were found, mark the objective and quest as complete.
;-----------------------------------------------------------------------
	If (DMN_SkyshardsSkyrimCountActivated.GetValue() as Int == DMN_SkyshardsSkyrimCountTotal.GetValue() as Int \
		&& bFinalise)
	; Complete the Skyshards in Skyrim main quest.
		skyrimCompleted = True
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You found all the Skyshards in Skyrim! Marking quest as complete now.")
		DMN_SQD.stopSideQuests() ; Complete and hide the side quests.
		DMN_SkyshardsSkyrim.SetStage(200) ; Set the main quest completed stage.
		DMN_SkyshardsSkyrim.SetObjectiveCompleted(10) ; Mark the main quest objective as completed.
		DMN_SkyshardsSkyrim.CompleteQuest() ; Complete the main quest.
	EndIf
; If new Skyshards have been added, and the cap increased.
; And if the placeholder objective is the one displayed.
;---------------------------------------------------------
	If (DMN_SkyshardsSkyrimCountTotal.GetValue() as Int > DMN_SkyshardsSkyrimCountActivated.GetValue() as Int \
		&& DMN_SkyshardsSkyrim.IsObjectiveDisplayed(100) && !skyrimCompleted)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: New Skyshards detected. Updating quest objective.")
	; Hide the placeholder objective, so that the new objective further down can be shown.
		DMN_SkyshardsSkyrim.SetObjectiveDisplayed(100, False, True)
	EndIf
; If more than 1 Skyshard was found, advance the quest stage.
;------------------------------------------------------------
	If (DMN_SkyshardsSkyrimCountActivated.GetValue() as Int > 1 && DMN_SkyshardsSkyrim.GetCurrentStageID() != 20 && !skyrimCompleted)
		DMN_SkyshardsSkyrim.SetStage(20)
	EndIf
; Show the quest objective for the Skyshards in Skyrim main quest if on the
; right stages AND if the placeholder objective is NOT currently displayed.
	If (DMN_SkyshardsSkyrim.GetCurrentStageID() < 100 && !DMN_SkyshardsSkyrim.IsObjectiveDisplayed(100) \ 
		&& !skyrimCompleted && !bFinalise)
		If (bSilent)
		; Hide the objective notification if it's already been shown before.
			DMN_SkyshardsSkyrim.SetObjectiveDisplayed(10, True, False)
		Else
			DMN_SkyshardsSkyrim.SetObjectiveDisplayed(10, True, True)
		EndIf
	EndIf
EndFunction

Function startMainQuest(String questName)
	GlobalVariable cnt
	Quest qst
	If (questName == "Skyrim")
		cnt = DMN_SkyshardsSkyrimCountActivated
		qst = DMN_SkyshardsSkyrim
	ElseIf (questName == "Dawnguard")
		; To-Do.
	EndIf
	If (cnt.GetValue() as Int > 0 && !qst.IsRunning())
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: The Skyshards in " + questName + " quest is not running! Starting it now.")
		qst.Start()
		updateGlobals()
		qst.SetStage(10)
		updateMainQuests()
	EndIf
EndFunction

Function stopMainQuest(String questName)
	Quest qst
	If (questName == "Skyrim")
		qst = DMN_SkyshardsSkyrim
	ElseIf (questName == "Dawnguard")
		; To-Do.
	EndIf
	If (qst.IsRunning())
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: The Skyshards in " + questName + " quest is running! Stopping it now.")
		qst.Stop()
	EndIf
EndFunction

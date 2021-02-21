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

GlobalVariable Property DMN_SkyshardsComplete Auto
{Whether or not all Skyshards have been found across all main quests.
0 = there are Skyshards to be found, 1 = all have been found. Auto-Fill.}

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

; Initialises an empty array to store all main quests.
Quest[] mainQuest
; Initialises an empty array to store all main quest names.
String[] mainQuestName
; Initialises an empty array to store all main quest current counter values.
; Ensure the indexes match the other mainQuest arrays for comparisons.
GlobalVariable[] mainQuestCounter
; Initialises an empty array to store all main quest globals.
GlobalVariable[] mainQuestGlobal
; Initialises an empty array to store all main quest total counter values.
; Ensure the indexes match the other mainQuest arrays for comparisons.
GlobalVariable[] mainQuestTotal

Function buildArrays()
	mainQuest = new Quest[2]
	mainQuest[0] = DMN_Skyshards
	mainQuest[1] = DMN_SkyshardsSkyrim

	mainQuestName = new String[2]
	mainQuestName[0] = "Skyshards"
	mainQuestName[1] = "Skyrim"

	mainQuestCounter = new GlobalVariable[2]
	mainQuestCounter[0] = DMN_SkyshardsCountActivated
	mainQuestCounter[1] = DMN_SkyshardsSkyrimCountActivated

	mainQuestTotal = new GlobalVariable[2]
	mainQuestTotal[0] = DMN_SkyshardsCountTotal
	mainQuestTotal[1] = DMN_SkyshardsSkyrimCountTotal

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

Function updateMainQuests(Bool bSilent = False)
Bool skyrimCompleted = False
; Check progress of Skyshards in Skyrim main quest.
;==================================================
; If all Skyshards were found, mark the objective and quest as complete.
;-----------------------------------------------------------------------
	If (DMN_SkyshardsSkyrimCountActivated.GetValue() as Int \
		== DMN_SkyshardsSkyrimCountTotal.GetValue() as Int)
	; Complete the Skyshards in Skyrim main quest.
		skyrimCompleted = True
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You found " + \
		"all the Skyshards in Skyrim! Marking quest as complete now.")
	; Complete and hide the side quests.
		DMN_SQD.stopSideQuests()
	; Update any outstanding global values on the main quest.
		updateGlobals()
	; Set the main quest completed stage.
		DMN_SkyshardsSkyrim.SetStage(200)
	; Mark the main quest objective as completed.
		DMN_SkyshardsSkyrim.SetObjectiveCompleted(10)
	; Complete the main quest.
		DMN_SkyshardsSkyrim.CompleteQuest()
	; Stop the main quest.
		DMN_SkyshardsSkyrim.Stop()
	; Flag the global variable that controls if all Skyshards have been found.
		DMN_SkyshardsComplete.SetValue(1 as Int)
	EndIf
; If new Skyshards have been added, and the cap increased.
; And if the placeholder objective is the one displayed.
;---------------------------------------------------------
	If (DMN_SkyshardsSkyrimCountTotal.GetValue() as Int \
		> DMN_SkyshardsSkyrimCountActivated.GetValue() as Int \
		&& DMN_SkyshardsSkyrim.IsObjectiveDisplayed(100) \
		&& !skyrimCompleted)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: New " + \
		"Skyshards detected. Updating quest objective.")
	; Hide the placeholder objective, so that the
	; new objective further down can be shown.
		DMN_SkyshardsSkyrim.SetObjectiveDisplayed(100, False, True)
	EndIf
; If more than 1 Skyshard was found, advance the quest stage.
;------------------------------------------------------------
	If (DMN_SkyshardsSkyrimCountActivated.GetValue() as Int > 1 \
		&& DMN_SkyshardsSkyrim.GetCurrentStageID() != 20 \
		&& !skyrimCompleted)
		DMN_SkyshardsSkyrim.SetStage(20)
	EndIf
; Show the quest objective for the Skyshards in Skyrim main quest if on the
; right stages AND if the placeholder objective is NOT currently displayed.
	If (DMN_SkyshardsSkyrim.GetCurrentStageID() < 100 \
		&& !DMN_SkyshardsSkyrim.IsObjectiveDisplayed(100) \ 
		&& !skyrimCompleted)
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
		qst.SetStage(10)
		updateMainQuests()
	EndIf
EndFunction

Function startMainQuests()
; Populate the quest data array for use down below.
	buildArrays()
	Int i = mainQuest.Length
	While (i)
		i -= 1
	; We skip the Skyshards main quest as it holds all the tracking data.
	; For every other main quest, we do the following...
		If (mainQuest[i] && mainQuest[i] != DMN_Skyshards \
			&& !mainQuest[i].IsRunning() \
			&& mainQuestCounter[i].GetValue() as Int > 0)
			debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Starting the " + \
			mainQuestName[i] + " main quest.")
		; Start each main quest and set its starting stage where at
		; least 1 Skyshard has been found in that quests region.
			mainQuest[i].Start()
			mainQuest[i].SetStage(10)
		EndIf
	EndWhile
; Perform any additional updates to the main quests as needed, silently.
	updateMainQuests(True)
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

Function stopTrackingMainQuests()
; Populate the quest data array for use down below.
	buildArrays()
	Int i = mainQuest.Length
	debugNotificationAndTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: " + \
	"Stopping main quests...")
	While (i)
		i -= 1
	; We skip the Skyshards main quest as it holds all the tracking data.
	; For every other main quest, we do the following...
		If (mainQuest[i] && mainQuest[i] != DMN_Skyshards && \
			mainQuest[i].IsRunning())
			debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Stopping the " + \
			mainQuestName[i] + " main quest.")
		; Hide the main quest objective.
			mainQuest[i].SetObjectiveDisplayed(10, False, True)
		; Set the quest stage to the "stopped" stage and mark it as completed.
			mainQuest[i].SetStage(500)
			mainQuest[i].SetObjectiveDisplayed(500)
			mainQuest[i].SetObjectiveCompleted(500)
		; Complete the quest and stop tracking it.
			mainQuest[i].CompleteQuest()
			mainQuest[i].Stop()
		EndIf
	EndWhile
	debugNotificationAndTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Main " + \
	"quests have been stopped!")
EndFunction
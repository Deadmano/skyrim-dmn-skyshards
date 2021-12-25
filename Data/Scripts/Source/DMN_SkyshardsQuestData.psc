; Copyright (C) 2021 Phillip Stolić
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

ScriptName DMN_SkyshardsQuestData Extends Quest  
{Helper script that stores all Skyshards
quest data and variables.
}

Import Debug
Import Game
Import Utility
Import DMN_DeadmaniacFunctions
Import DMN_SkyshardsFunctions

DMN_SkyshardsQuest Property DMN_SQN Auto
DMN_SkyshardsQuestHelper Property DMN_SQH Auto
DMN_SkyshardsQuestManager Property DMN_SQM Auto

GlobalVariable Property DMN_SkyshardsComplete Auto
{Whether or not all Skyshards have been found across all main quests.
0 = there are Skyshards to be found, 1 = all have been found. Auto-Fill.}
GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable. Auto-Fill.}
GlobalVariable Property DMN_SkyshardsQuestSystem Auto
{Controls which quest system is used. 1 for Full (default), 0 for Lite. Auto-Fill.}
GlobalVariable[] Property skyshardsCounterList Auto
{The list of all Skyshard counters.
Ensure indexes match skyshardsTotalList.}
GlobalVariable[] Property skyshardsTotalList Auto
{The list of all Skyshard totals per main quest.
Ensure indexes match skyshardsCounterList.}

Quest Property helperQuest Auto
{Set to the helper quest manually. Does not auto-fill.}

; Ensure the indexes match up. e.g: DMN_SkyshardsSkyrimWhiterun and
; DMN_SkyshardsSkyrimWhiterunHelper both on index 7 of the array.
; Else you will have the incorrect values for each quest.
Quest[] Property holdQuest Auto
{The list of all Skyshard hold quests.}
Quest[] Property holdQuestHelper Auto
{The list of all Skyshard hold quest helpers.}
Int[] Property holdSkyshardsActivated Auto
{The list of activated Skyshard counts per hold.}
Quest[] Property skyshardsMainQuestList Auto
{The list of all Skyshard main quests. Ensure indexes match
either skyshardsCounterList or skyshardsTotalList.}
String[] Property holdName Auto
{The name of the hold the Skyshards are found in.}

GlobalVariable currentAbsorbedSkyshard

GlobalVariable Property currentSkyshard Hidden
	GlobalVariable Function get()
		Return currentAbsorbedSkyshard
	  EndFunction
EndProperty

Bool isUpdateNeeded

Bool Property updateStatus Hidden
	Bool Function get()
		Return isUpdateNeeded
	  EndFunction
EndProperty

; Starts the helper quest that is responsible for updating all main
; and side quests as well as performing any needed maintenance.
Function beginQuestUpdates(GlobalVariable skyshardCounter)
	If (!isQuestUpdateNeeded())
		Return
	EndIf

	Int i = skyshardsCounterList.Length
	While(i)
		i -= 1
		If (skyshardCounter == skyshardsCounterList[i])
			currentAbsorbedSkyshard = skyshardsCounterList[i]
			helperQuest.Stop()
			helperQuest.Start()
		EndIf
	EndWhile
EndFunction

Function disableUpdating()
; We no longer need to update the quests, so disable updating.
	isUpdateNeeded = False	
EndFunction

Bool Function isQuestUpdateNeeded()
; Helper function that checks if we need to update the Skyshard quests.
	debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Checking if any " + \
	"quests require an update...")
	Bool isUpdateRequired = False
	Int i = skyshardsCounterList.Length

	While(i && !isUpdateRequired)
	; Loop through each Skyshard counter and compare it to the total for
	; that specific counter and if they don't match flag an update!
		i -= 1
		Int counterValueCap = skyshardsTotalList[i].GetValue() as Int
		Int counterValueCurrent = skyshardsCounterList[i].GetValue() as Int
		If (counterValueCurrent < counterValueCap)
			isUpdateRequired = True
		EndIf
	; Handle an edge case where quest requirements could have been met but
	; the quests were not updated and completed. Loops through each main quest
	; and also compares the counter totals to decide if an update is needed.
		If (skyshardsMainQuestList[i] && skyshardsMainQuestList[i].IsRunning() \
			&& counterValueCurrent == counterValueCap)
			isUpdateRequired = True
		EndIf
	EndWhile

	If (isUpdateRequired)
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: One or more main " + \
		"quests require an update!")
	Else
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: No quests " + \
		"require an update.")
	EndIf
	Return isUpdateRequired
EndFunction

; Ensures all the helper quests responsible for the side quests are started.
Function startSideQuests()
; Runs only if we are using the Full quest system.
	If (DMN_SkyshardsQuestSystem.GetValue() as Int == 1 \
		&& DMN_SkyshardsComplete.GetValue() as Int != 1)
		; Log the time the function started running.
		Float fStart = GetCurrentRealTime()
		; Log the time the function stopped running.
		Float fStop
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: [Started " + \
		"startSideQuests Function]")

	; Flag this as an update to avoid helper quests running on game load.
	; This ensures that the quests only update when we want them to.
		isUpdateNeeded = True

		Int i = holdQuest.Length
		While (i)
		; Loop through all hold quests helpers to stop and start them,
		; triggering their own update functions. This is done
		; to handle the updates asynchronously, speeding up checking.
			i -= 1
			holdQuestHelper[i].Stop()
			holdQuestHelper[i].Start()
		EndWhile

	; Clear the specified Skyshard as we are done with it.
		currentAbsorbedSkyshard = None

		fStop = GetCurrentRealTime()
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: startSideQuests " + \
		"function took " + (fStop - fStart) + " seconds to complete.")
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: [Ended " + \
		"startSideQuests Function]\n\n")
	EndIf
EndFunction

Function stopSideQuests()
	Int i = holdQuest.Length
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Completing hold quests...")
	While (i)
		i -= 1
	; Complete all running side quest objectives.
		If (holdQuest[i].IsRunning())
			holdQuest[i].CompleteAllObjectives()
		; Set the side quest stage to the final stage and mark it as completed.
			setQuestStageFinal(holdQuest[i], holdQuestHelper[i], DMN_SkyshardsDebug, holdName[i])
		; Complete the side quest and stop tracking it.
			holdQuest[i].CompleteQuest()
			holdQuest[i].Stop()
		EndIf
	EndWhile
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Hold quests have been completed!")
EndFunction

Function stopTrackingSideQuests()
	Int i = holdQuest.Length
	debugNotificationAndTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: " + \
	"Stopping hold quests...")
	While (i)
		i -= 1
	; Hide running side quest objectives and stop them.
		If (holdQuest[i].IsRunning())
		; Hide the side quest objectives.
			hideQuestObjective(holdQuest[i], holdQuestHelper[i], DMN_SkyshardsDebug, holdName[i])
		; Set the side quest stage to the "stopped" stage and mark it as completed.
			holdQuest[i].SetStage(500)
			holdQuest[i].SetObjectiveDisplayed(500)
			holdQuest[i].SetObjectiveCompleted(500)
		; Complete the side quest and stop tracking it.
			holdQuest[i].CompleteQuest()
			holdQuest[i].Stop()
		EndIf
	EndWhile
	debugNotificationAndTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Hold " + \
	"quests have been stopped!")
EndFunction

Function stopTrackingMainQuests()
	DMN_SQN.stopTrackingMainQuests()
EndFunction

Function syncQuestProgress()
; Helper function called by config after an update to ensure all quest
; progress is synced up with any changes that were made.

If (!isQuestUpdateNeeded())
	Return
EndIf

; Update the global variable values on the main quests.
	DMN_SQN.updateGlobals()

; Check main quest progression to update stages and objectives as needed.
	DMN_SQN.updateMainQuests(True)

; Update all activated side quest objectives with any new
; Skyshards added since the last update.
	startSideQuests()
EndFunction

; Helper function to switch between the full and lite quest system.
; Accepts an integer. 1 = full quest system. 0 = lite quest system.
Function switchQuestSystem(Int questSystem)
	Int currentQuestSystem = DMN_SkyshardsQuestSystem.GetValue() as Int

; If no change is needed to the quest system due to a duplicate choice
; being made, then simply exit out of the function early.
	If (currentQuestSystem == questSystem)
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: The selected " + \
		"quest system matches the current one. Skipping switching systems...")
		Return
	EndIf

	If (questSystem == 1)
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Switching to the " + \
		"full quest system...")
		DMN_SkyshardsQuestSystem.SetValue(1 as Int)

		If (isQuestUpdateNeeded())
			startSideQuests()
			disableUpdating()
			startMainQuests()
		EndIf

		If (DMN_SkyshardsQuestSystem.GetValue() as Int == 1)
			debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Successfully " + \
			"switched to the full quest system!")
		Else
			debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: An unknown " + \
			"error occurred while attempting to switch quest systems!")
		EndIf
	ElseIf (questSystem == 0)
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Switching to the " + \
		"lite quest system...")
		DMN_SkyshardsQuestSystem.SetValue(0 as Int)

		; Disable updating so that the side quests don't trigger updates
		; when the helper quests are cycled to update their objectives.
		disableUpdating()
		stopTrackingSideQuests()
		startMainQuests()

		If (DMN_SkyshardsQuestSystem.GetValue() as Int == 0)
			debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Successfully " + \
			"switched to the lite quest system!")
		Else
			debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: An unknown " + \
			"error occurred while attempting to switch quest systems!")
		EndIf
	EndIf
EndFunction

Function startMainQuests()
	DMN_SQN.startMainQuests()
EndFunction

Function updateMainQuests()
	DMN_SQN.updateMainQuests()
EndFunction
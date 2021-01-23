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

ScriptName DMN_SkyshardsQuestHelper Extends Quest  
{Helper script for other quests.}

Import Utility
Import DMN_DeadmaniacFunctions

DMN_SkyshardsQuest Property DMN_SQN Auto
DMN_SkyshardsQuestData Property DMN_SQD Auto
DMN_SkyshardsQuestManager Property DMN_SQM Auto

GlobalVariable Property DMN_SkyshardsDebug Auto
{Auto-Fill.}
GlobalVariable Property DMN_SkyshardsSkyrimCountActivated Auto
{Auto-Fill.}
GlobalVariable Property DMN_SkyshardsDLC01CountActivated Auto
{Auto-Fill.}

Event OnInit()
	If (DMN_SQD.currentSkyshard)
		updateQuests()
	EndIf
EndEvent

Function updateQuests()
; Log the time the function started running.
	Float fStart = GetCurrentRealTime()
; Log the time the function stopped running.
	Float fStop
	debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: [Started " + \
	"updateQuests Function]")
	GlobalVariable skyshardCounter = DMN_SQD.currentSkyshard

	debugNotificationAndTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: " + \
	"Updating quest progress...\n\n")

; Check if the Skyshard activated is from Skyrim.
	If (SkyshardCounter == DMN_SkyshardsSkyrimCountActivated)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You " + \
		"activated a Skyrim Skyshard!")

	; Check if the Skyshards in Skyrim quest is running,
	; and if it is not then start it.
		DMN_SQN.startMainQuest("Skyrim")

; Check if the Skyshard activated is from DLC01 (Dawnguard).
	ElseIf (SkyshardCounter == DMN_SkyshardsDLC01CountActivated)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You " + \
		"activated a Dawnguard Skyshard!")
		
	; Add DLC01 start quest here.
		; DMN_SQN.startMainQuest("Dawnguard")
	EndIf

; Begin the process of updating the Skyshards side quests
; to handle the Skyshard that was just absorbed.
	DMN_SQD.startSideQuests()

; We now keep checking if all side quests have completed their updates and we
; will wait until either they have or we have reached the maximum amount of
; time allocated. We do this to update side quests before the main quests.
	Bool isEverySideQuestStillUpdating
	Bool isSideQuestUpdateCompleted
; The time we started tracking side quest completion.
	Float fTimeStarted = GetCurrentRealTime()
; The amount of time elapsed since we started tracking.
	Float fTimePassed
	While (!isSideQuestUpdateCompleted && fTimePassed < 5)
	; Update the time with each attempt.
		fTimePassed = GetCurrentRealTime() - fTimeStarted
	; The array of all side quests and their update status.
		Bool[] sideQuestStatusArray = DMN_SQM.isEverySideQuestUpdated
		Int i = 0
		isEverySideQuestStillUpdating = False
	; So long as there is still a side quest that is busy, keep running.
		While (!isEverySideQuestStillUpdating && \
		i < sideQuestStatusArray.Length)
			If (!sideQuestStatusArray[i])
				isEverySideQuestStillUpdating = True
			EndIf
			i += 1
		EndWhile
	; If all side quests are finished with their updates, break the loop.
		If (!isEverySideQuestStillUpdating)
			isSideQuestUpdateCompleted = True
		EndIf
	EndWhile

; Update the tracking quests global variable values.
	DMN_SQN.updateGlobals()

; Check for main quest progression.
	DMN_SQN.updateMainQuests()

; Finalise parameter set to true to complete main quests if
; requirements are met.
	DMN_SQN.updateMainQuests(True)

; Once all updates have been performed, flag the data quest so that
; helper quests do not randomly fire off during game loads. 
	DMN_SQD.disableUpdating()

	debugNotificationAndTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: " + \
	"Quest progress has been updated successfully!")

	fStop = GetCurrentRealTime()
	debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: updateQuests function " + \
	"took " + (fStop - fStart) + " seconds to complete.")
	debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: [Ended " + \
	"updateQuests Function]\n\n")
EndFunction
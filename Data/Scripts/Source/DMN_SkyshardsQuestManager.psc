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

ScriptName DMN_SkyshardsQuestManager Extends Quest
{Quest manager that that handles tasks for multiple quest helpers.}

Import Utility
Import DMN_DeadmaniacFunctions
Import DMN_SkyshardsFunctions

DMN_SkyshardsQuestData Property DMN_SQD Auto

DMN_SkyshardsQuestsEastmarch Property DMN_SQEA Auto
DMN_SkyshardsQuestsFalkreath Property DMN_SQFA Auto
DMN_SkyshardsQuestsHaafingar Property DMN_SQHA Auto
DMN_SkyshardsQuestsHjaalmarch Property DMN_SQHJ Auto
DMN_SkyshardsQuestsThePale Property DMN_SQPA Auto
DMN_SkyshardsQuestsTheReach Property DMN_SQRE Auto
DMN_SkyshardsQuestsTheRift Property DMN_SQRI Auto
DMN_SkyshardsQuestsWhiterun Property DMN_SQWH Auto
DMN_SkyshardsQuestsWinterhold Property DMN_SQWI Auto

Bool[] Property isEverySideQuestUpdated Hidden
    Bool[] Function get()
        Bool[] sideQuestStatus
        ; Create as many indexes as needed for all side quests, not zero-based!
        ; So for 3 items in the array, the number in the bracket should be 3.
        sideQuestStatus = new Bool[9]
        ; Array items are zero-based however, starting at index 0.
	    sideQuestStatus[0] = DMN_SQEA.sideQuestStatus
	    sideQuestStatus[1] = DMN_SQFA.sideQuestStatus
        sideQuestStatus[2] = DMN_SQHA.sideQuestStatus
        sideQuestStatus[3] = DMN_SQHJ.sideQuestStatus
        sideQuestStatus[4] = DMN_SQPA.sideQuestStatus
        sideQuestStatus[5] = DMN_SQRE.sideQuestStatus
	    sideQuestStatus[6] = DMN_SQRI.sideQuestStatus
	    sideQuestStatus[7] = DMN_SQWH.sideQuestStatus
	    sideQuestStatus[8] = DMN_SQWI.sideQuestStatus
        Return sideQuestStatus
	EndFunction
EndProperty

GlobalVariable Property debugVariable Hidden
	GlobalVariable Function get()
		Return DMN_SQD.DMN_SkyshardsDebug
	EndFunction
EndProperty

String[] Property holdName Hidden
	String[] Function get()
		Return DMN_SQD.holdName
	EndFunction
EndProperty

Quest[] Property holdQuest Hidden
	Quest[] Function get()
		Return DMN_SQD.holdQuest
	EndFunction
EndProperty

Quest[] Property holdQuestHelper Hidden
	Quest[] Function get()
		Return DMN_SQD.holdQuestHelper
	EndFunction
EndProperty

Int[] Property holdSkyshardsActivated Hidden
	Int[] Function get()
		Return DMN_SQD.holdSkyshardsActivated
	EndFunction
EndProperty

Function updateSideQuestProgress(Int holdIndex)
; Log the time the function started running.
	Float fStart = GetCurrentRealTime()
; Log the time the function stopped running.
	Float fStop
	debugTrace(debugVariable, "Skyshards DEBUG: " + holdName[holdIndex] + \
	" side quest update started.")

; Start the helper quest to perform checks on.
	startQuestSafe(holdQuestHelper[holdIndex])
	Bool startQuest
	Int i = 0
	Int j
	Int k
	Int l = 0
; Loop through each alias attached to the helper quest. 
	While (holdQuestHelper[holdIndex].GetAlias(i))
		ObjectReference ref = getQuestAlias(holdQuestHelper[holdIndex], i)
	; We're looking for a Skyshard that is IgnoringFriendlyHits or disabled.
	; We use that to determine the amount of absorbed Skyshards for this hold.
		If (ref && ref.IsDisabled() || ref && ref.IsIgnoringFriendlyHits())
			k += 1
			startQuest = True
		EndIf
		i += 1
	EndWhile

	; If we have already found all the Skyshards for this hold, skip updating.
	If (i == holdSkyshardsActivated[holdIndex])
		fStop = GetCurrentRealTime()
		debugTrace(debugVariable, "Skyshards DEBUG: All " + \
		holdName[holdIndex] + " Skyshards have already been found. " + \
		"Completed in " + (fStop - fStart) + " seconds.")
		Return
	EndIf

; If we found a valid reference and the quest isn't running...
	If (i != holdSkyshardsActivated[holdIndex] && \
		startQuest && !holdQuest[holdIndex].IsRunning())
	; Start the quest up and set its initial stage.
		startQuestSafeSetStage(holdQuest[holdIndex])
	EndIf

; Update the stored Skyshard activations for this hold.
	If (i != holdSkyshardsActivated[holdIndex])
		DMN_SQD.holdSkyshardsActivated[holdIndex] = k
	EndIf

; Loop through each alias attached to the helper quest.
	While (holdQuestHelper[holdIndex].GetAlias(l))
		ObjectReference ref = getQuestAlias(holdQuestHelper[holdIndex], l)
	; So long as the quest is running, do the following...
		If (holdQuest[holdIndex].IsRunning())
		; Set and display the objective for each Skyshard.
			setQuestObjectiveDisplayed(ref, holdQuest[holdIndex], l, \
			j, debugVariable, holdName[holdIndex])
		; Mark specific objectives as complete for any found Skyshards.
			setQuestObjectiveCompleted(ref, holdQuest[holdIndex], l, \
			j, debugVariable, holdName[holdIndex])
		EndIf
		l += 1
	EndWhile
	startQuest = False
	debugTrace(debugVariable, "Skyshards DEBUG: The amount of " + \
	holdName[holdIndex] + " Skyshards found: " + k + "/" + i + ".")
	If (i != holdSkyshardsActivated[holdIndex] && \
		holdQuest[holdIndex].IsRunning())
		setQuestStage(holdQuest[holdIndex], k, \
		debugVariable, holdName[holdIndex])
	EndIf
	stopQuestSafe(holdQuestHelper[holdIndex])
	; Check to see if all Skyshards for a hold have been found.
	If (i == holdSkyshardsActivated[holdIndex] && \
		holdQuest[holdIndex].IsRunning())
	; If all have been found complete the side quest and stop tracking it.
		debugTrace(debugVariable, "Skyshards DEBUG: All Skyshards in " + \
		holdName[holdIndex] + " found! Marking quest as complete now.")
		holdQuest[holdIndex].CompleteAllObjectives()
	; Set the side quest stage to the final stage and mark it as completed.
		setQuestStageFinal(holdQuest[holdIndex], \
		holdQuestHelper[holdIndex], debugVariable, \
		holdName[holdIndex])
	; Complete the side quest and stop tracking it.
		holdQuest[holdIndex].CompleteQuest()
		holdQuest[holdIndex].Stop()
	EndIf
	fStop = GetCurrentRealTime()
	debugTrace(debugVariable, "Skyshards DEBUG: " + \
	holdName[holdIndex] + " side " + "quest updated in " + \
	(fStop - fStart) + " seconds.")
EndFunction
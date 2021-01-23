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

Function updateSideQuestProgress(GlobalVariable debugVariable, Quest holdQuest, Quest holdQuestHelper, String holdName) Global
; Log the time the function started running.
	Float fStart = GetCurrentRealTime()
; Log the time the function stopped running.
	Float fStop
	debugTrace(debugVariable, "Skyshards DEBUG: " + holdName + " side " + \
	"quest update started.")
; Start the helper quest to perform checks on.
	startQuestSafe(holdQuestHelper)
	Bool startQuest
	Int i = 0
	Int j
	Int k
	Int l = 0
; Loop through each alias attached to the helper quest. 
	While (holdQuestHelper.GetAlias(i))
		ObjectReference ref = getQuestAlias(holdQuestHelper, i)
	 ; If we find a reference that exists and is disabled, do the following...
		If (ref && ref.IsDisabled())
			k += 1
			startQuest = True
		 ; If we found a valid reference and the quest isn't running, do...
			If (startQuest && !holdQuest.IsRunning())
			; Start the quest up and set its initial stage.
				startQuestSafeSetStage(holdQuest)
			EndIf
		EndIf
		i += 1
	EndWhile
; Loop through each alias attached to the helper quest.
	While (holdQuestHelper.GetAlias(l))
		ObjectReference ref = getQuestAlias(holdQuestHelper, l)
	; So long as the quest is running, do the following...
		If (holdQuest.IsRunning())
		; Set and display the objective for each Skyshard.
			setQuestObjectiveDisplayed(ref, holdQuest, l, j, debugVariable, \
			holdName)
		; Mark specific objectives as complete for any found Skyshards.
			setQuestObjectiveCompleted(ref, holdQuest, l, j, debugVariable, \
			holdName)
		EndIf
		l += 1
	EndWhile
	startQuest = False
	debugTrace(debugVariable, "Skyshards DEBUG: The amount of " + holdName + \
	" Skyshards found: " + k + "/" + i + ".")
	setQuestStage(holdQuest, k, debugVariable, holdName)
	stopQuestSafe(holdQuestHelper)
	fStop = GetCurrentRealTime()
	debugTrace(debugVariable, "Skyshards DEBUG: " + holdName + " side " + \
	"quest updated in " + (fStop - fStart) + " seconds.")
EndFunction
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

ScriptName DMN_SkyshardsQuestData Extends Quest  
{Helper script that stores all Skyshards
quest data and variables.
}

Import Debug
Import Game
Import DMN_DeadmaniacFunctions
Import DMN_SkyshardsFunctions

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable. Auto-Fill.}
GlobalVariable Property DMN_SkyshardsQuestSystem Auto
{Controls which quest system is used. 1 for Full (default), 0 for Lite. Auto-Fill.}

; Ensure the indexes match up. e.g: DMN_SkyshardsSkyrimWhiterun and
; DMN_SkyshardsSkyrimWhiterunHelper both on index 7 of the array.
; Else you will have the incorrect values for each quest. 
Quest[] Property holdQuest Auto
{The list of all Skyshard hold quests.}
Quest[] Property holdQuestHelper Auto
{The list of all Skyshard hold quest helpers.}
Int[] Property skyshardsActivated Auto
{The list of activated Skyshard counts.}
Int[] Property skyshardsTotal Auto
{The list of total Skyshard counts.}
String[] Property holdName Auto
{The name of the hold the Skyshards are found in.}

Function updateSideQuests()
	; Runs only if we are using the Full quest system.
	If (DMN_SkyshardsQuestSystem.GetValue() as Int == 1)
		Int i = holdQuest.Length
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Updating quest progress...")
		While (i)
			i -= 1
		; Start the quest safely, update Skyshard activated/total counts as well as set/update quest objectives and stages.
			updateQuestProgress(holdQuest[i], holdQuestHelper[i], DMN_SkyshardsDebug, holdName[i], skyshardsActivated[i], skyshardsTotal[i])
		EndWhile
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Quest progress has been updated successfully!")
	EndIf
EndFunction

Function stopSideQuests()
	Int i = holdQuest.Length
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Stopping hold quests...")
	While (i)
		i -= 1
	; Hide running side-quest objectives and stop them.
		If (holdQuest[i].IsRunning())
			hideQuestObjective(holdQuest[i], holdQuestHelper[i], DMN_SkyshardsDebug, holdName[i])
			holdQuest[i].SetStage(500)
			holdQuest[i].SetObjectiveDisplayed(500)
			holdQuest[i].SetObjectiveCompleted(500)
			holdQuest[i].CompleteQuest()
			holdQuest[i].Stop()
		EndIf
	EndWhile
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Hold quests have been stopped!")
EndFunction

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

GlobalVariable Property DMN_SkyshardsCountCurrent Auto
{The current amount of Skyshards the player has activated throughout Skyrim and
other DLCs/Mods which resets once it reaches DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountCap Auto
{The amount of Skyshard absorptions required before gaining a perk point. Auto-Fill.}

;=======================
; BEGIN SKYRIM VARIABLES
;=======================

GlobalVariable Property DMN_SkyshardsSkyrimCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim. Auto-Fill.}
GlobalVariable Property DMN_SkyshardsSkyrimCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim. Auto-Fill.}

; EASTMARCH
;---------
; The total amount of Skyshards the player has activated in the Eastmarch hold.
Int DMN_SkyshardsSkyrimEastmarchCountActivated
; The amount of Skyshards that exist in total throughout the Eastmarch hold.
Int DMN_SkyshardsSkyrimEastmarchCountTotal
Quest Property DMN_SkyshardsSkyrimEastmarch Auto
Quest Property DMN_SkyshardsSkyrimEastmarchHelper Auto

; FALKREATH
;---------
; The total amount of Skyshards the player has activated in the Falkreath hold.
Int DMN_SkyshardsSkyrimFalkreathCountActivated
; The amount of Skyshards that exist in total throughout the Falkreath hold.
Int DMN_SkyshardsSkyrimFalkreathCountTotal
Quest Property DMN_SkyshardsSkyrimFalkreath Auto
Quest Property DMN_SkyshardsSkyrimFalkreathHelper Auto

; HAAFINGAR
;---------
; The total amount of Skyshards the player has activated in the Haafingar hold.
Int DMN_SkyshardsSkyrimHaafingarCountActivated
; The amount of Skyshards that exist in total throughout the Haafingar hold.
Int DMN_SkyshardsSkyrimHaafingarCountTotal
Quest Property DMN_SkyshardsSkyrimHaafingar Auto
Quest Property DMN_SkyshardsSkyrimHaafingarHelper Auto

; MORTHAL
;---------
; The total amount of Skyshards the player has activated in the Morthal hold.
Int DMN_SkyshardsSkyrimMorthalCountActivated
; The amount of Skyshards that exist in total throughout the Morthal hold.
Int DMN_SkyshardsSkyrimMorthalCountTotal
Quest Property DMN_SkyshardsSkyrimMorthal Auto
Quest Property DMN_SkyshardsSkyrimMorthalHelper Auto

; THE PALE
;---------
; The total amount of Skyshards the player has activated in The Pale hold.
Int DMN_SkyshardsSkyrimThePaleCountActivated
; The amount of Skyshards that exist in total throughout The Pale hold.
Int DMN_SkyshardsSkyrimThePaleCountTotal
Quest Property DMN_SkyshardsSkyrimThePale Auto
Quest Property DMN_SkyshardsSkyrimThePaleHelper Auto

; THE REACH
;---------
; The total amount of Skyshards the player has activated in The Reach hold.
Int DMN_SkyshardsSkyrimTheReachCountActivated
; The amount of Skyshards that exist in total throughout The Reach hold.
Int DMN_SkyshardsSkyrimTheReachCountTotal
Quest Property DMN_SkyshardsSkyrimTheReach Auto
Quest Property DMN_SkyshardsSkyrimTheReachHelper Auto

; THE RIFT
;---------
; The total amount of Skyshards the player has activated in The Rift hold.
Int DMN_SkyshardsSkyrimTheRiftCountActivated
; The amount of Skyshards that exist in total throughout The Rift hold.
Int DMN_SkyshardsSkyrimTheRiftCountTotal
Quest Property DMN_SkyshardsSkyrimTheRift Auto
Quest Property DMN_SkyshardsSkyrimTheRiftHelper Auto

; WHITERUN
;---------
; The total amount of Skyshards the player has activated in the Whiterun hold.
Int DMN_SkyshardsSkyrimWhiterunCountActivated
; The amount of Skyshards that exist in total throughout the Whiterun hold.
Int DMN_SkyshardsSkyrimWhiterunCountTotal
Quest Property DMN_SkyshardsSkyrimWhiterun Auto
Quest Property DMN_SkyshardsSkyrimWhiterunHelper Auto

; WINTERHOLD
;---------
; The total amount of Skyshards the player has activated in the Winterhold hold.
Int DMN_SkyshardsSkyrimWinterholdCountActivated
; The amount of Skyshards that exist in total throughout the Winterhold hold.
Int DMN_SkyshardsSkyrimWinterholdCountTotal
Quest Property DMN_SkyshardsSkyrimWinterhold Auto
Quest Property DMN_SkyshardsSkyrimWinterholdHelper Auto

;=======================
; END SKYRIM VARIABLES
;=======================

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

Quest[] skyrimSkyshardHoldQuests
Quest[] skyrimSkyshardHoldQuestHelpers
Int[] skyrimSkyshardHoldQuestCountActivated
Int[] skyrimSkyshardHoldQuestCountTotal

Function testUpdate()
	skyrimSkyshardHoldQuests = new Quest[9] ; Update counts to reflect amount of items below.
	skyrimSkyshardHoldQuests[0] = DMN_SkyshardsSkyrimEastmarch
	skyrimSkyshardHoldQuests[1] = DMN_SkyshardsSkyrimFalkreath
	skyrimSkyshardHoldQuests[2] = DMN_SkyshardsSkyrimHaafingar
	skyrimSkyshardHoldQuests[3] = DMN_SkyshardsSkyrimMorthal
	skyrimSkyshardHoldQuests[4] = DMN_SkyshardsSkyrimThePale
	skyrimSkyshardHoldQuests[5] = DMN_SkyshardsSkyrimTheReach
	skyrimSkyshardHoldQuests[6] = DMN_SkyshardsSkyrimTheRift
	skyrimSkyshardHoldQuests[7] = DMN_SkyshardsSkyrimWhiterun
	skyrimSkyshardHoldQuests[8] = DMN_SkyshardsSkyrimWinterhold
	
	skyrimSkyshardHoldQuestHelpers = new Quest[9] ; Update counts to reflect amount of items below.
	skyrimSkyshardHoldQuestHelpers[0] = DMN_SkyshardsSkyrimEastmarchHelper
	skyrimSkyshardHoldQuestHelpers[1] = DMN_SkyshardsSkyrimFalkreathHelper
	skyrimSkyshardHoldQuestHelpers[2] = DMN_SkyshardsSkyrimHaafingarHelper
	skyrimSkyshardHoldQuestHelpers[3] = DMN_SkyshardsSkyrimMorthalHelper
	skyrimSkyshardHoldQuestHelpers[4] = DMN_SkyshardsSkyrimThePaleHelper
	skyrimSkyshardHoldQuestHelpers[5] = DMN_SkyshardsSkyrimTheReachHelper
	skyrimSkyshardHoldQuestHelpers[6] = DMN_SkyshardsSkyrimTheRiftHelper
	skyrimSkyshardHoldQuestHelpers[7] = DMN_SkyshardsSkyrimWhiterunHelper
	skyrimSkyshardHoldQuestHelpers[8] = DMN_SkyshardsSkyrimWinterholdHelper
	
	skyrimSkyshardHoldQuestCountActivated = new Int[9] ; Update counts to reflect amount of items below.
	skyrimSkyshardHoldQuestCountActivated[0] = DMN_SkyshardsSkyrimEastmarchCountActivated
	skyrimSkyshardHoldQuestCountActivated[1] = DMN_SkyshardsSkyrimFalkreathCountActivated
	skyrimSkyshardHoldQuestCountActivated[2] = DMN_SkyshardsSkyrimHaafingarCountActivated
	skyrimSkyshardHoldQuestCountActivated[3] = DMN_SkyshardsSkyrimMorthalCountActivated
	skyrimSkyshardHoldQuestCountActivated[4] = DMN_SkyshardsSkyrimThePaleCountActivated
	skyrimSkyshardHoldQuestCountActivated[5] = DMN_SkyshardsSkyrimTheReachCountActivated
	skyrimSkyshardHoldQuestCountActivated[6] = DMN_SkyshardsSkyrimTheRiftCountActivated
	skyrimSkyshardHoldQuestCountActivated[7] = DMN_SkyshardsSkyrimWhiterunCountActivated
	skyrimSkyshardHoldQuestCountActivated[8] = DMN_SkyshardsSkyrimWinterholdCountActivated
	
	skyrimSkyshardHoldQuestCountTotal = new Int[9] ; Update counts to reflect amount of items below.
	skyrimSkyshardHoldQuestCountTotal[0] = DMN_SkyshardsSkyrimEastmarchCountTotal
	skyrimSkyshardHoldQuestCountTotal[1] = DMN_SkyshardsSkyrimFalkreathCountTotal
	skyrimSkyshardHoldQuestCountTotal[2] = DMN_SkyshardsSkyrimHaafingarCountTotal
	skyrimSkyshardHoldQuestCountTotal[3] = DMN_SkyshardsSkyrimMorthalCountTotal
	skyrimSkyshardHoldQuestCountTotal[4] = DMN_SkyshardsSkyrimThePaleCountTotal
	skyrimSkyshardHoldQuestCountTotal[5] = DMN_SkyshardsSkyrimTheReachCountTotal
	skyrimSkyshardHoldQuestCountTotal[6] = DMN_SkyshardsSkyrimTheRiftCountTotal
	skyrimSkyshardHoldQuestCountTotal[7] = DMN_SkyshardsSkyrimWhiterunCountTotal
	skyrimSkyshardHoldQuestCountTotal[8] = DMN_SkyshardsSkyrimWinterholdCountTotal
	
	If (skyrimSkyshardHoldQuestHelpers.Length && \
		skyrimSkyshardHoldQuestCountActivated.Length && \
		skyrimSkyshardHoldQuestCountTotal.Length == \
		skyrimSkyshardHoldQuests.Length)
		Int i = skyrimSkyshardHoldQuests.Length
		Int j = 0
		Int k
		Int l
		String holdName
		While (i)
			i -= 1
			If (startSkyshardsQuest(skyrimSkyshardHoldQuestHelpers[i]))
			
				If (!skyrimSkyshardHoldQuests[i].IsRunning())
					skyrimSkyshardHoldQuests[i].Start()
					skyrimSkyshardHoldQuests[i].SetStage(10)
					
					skyrimSkyshardHoldQuestHelpers[i].Start()
					While (skyrimSkyshardHoldQuestHelpers[i].GetAlias(j)) ; Stop looping once our alias cannot be found.
						ObjectReference ref = (skyrimSkyshardHoldQuestHelpers[i].GetAlias(j) as ReferenceAlias).GetReference()
						If (ref)
							k = 10 * (1+j)
						; Display objectives in reverse-order to ensure they are displayed as per the objective order in the quest.
							If (!skyrimSkyshardHoldQuests[i].IsObjectiveDisplayed(k))
								skyrimSkyshardHoldQuests[i].SetObjectiveDisplayed(k)
								Notification("Skyshards Set Objective Displayed Value: " + k)
							EndIf
						EndIf
						j += 1
					EndWhile
					j = 0
					skyrimSkyshardHoldQuestHelpers[i].Stop()
				EndIf

				If (skyrimSkyshardHoldQuests[i].IsRunning())
					skyrimSkyshardHoldQuestCountActivated[i] = updateSkyshardQuestValues(skyrimSkyshardHoldQuestHelpers[i], 1)
					skyrimSkyshardHoldQuestCountTotal[i] = updateSkyshardQuestValues(skyrimSkyshardHoldQuestHelpers[i], 2)

					skyrimSkyshardHoldQuestHelpers[i].Start()
					While (skyrimSkyshardHoldQuestHelpers[i].GetAlias(j)) ; Stop looping once our alias cannot be found.
						ObjectReference ref = (skyrimSkyshardHoldQuestHelpers[i].GetAlias(j) as ReferenceAlias).GetReference()
						If (ref && ref.IsDisabled())
							k = 10 * (1+j)
							l += 1
							If (!skyrimSkyshardHoldQuests[i].IsObjectiveCompleted(k))
								skyrimSkyshardHoldQuests[i].SetObjectiveCompleted(k)
								Notification("Skyshards: Set Objective Completed Value: " + k)
								If skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimEastmarch
									holdName = "Eastmarch"
								ElseIf skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimFalkreath
									holdName = "Falkreath"
								ElseIf skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimHaafingar
									holdName = "Haafingar"
								ElseIf skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimMorthal
									holdName = "Morthal"
								ElseIf skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimThePale
									holdName = "The Pale"
								ElseIf skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimTheReach
									holdName = "The Reach"
								ElseIf skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimTheRift
									holdName = "The Rift"
								ElseIf skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimWhiterun
									holdName = "Whiterun"
								ElseIf skyrimSkyshardHoldQuests[i] == DMN_SkyshardsSkyrimWinterhold
									holdName = "Winterhold"
								EndIf
								Notification("The amount of " + holdName + " Skyshards found: " + skyrimSkyshardHoldQuestCountActivated[i] + "/" + skyrimSkyshardHoldQuestCountTotal[i])
							EndIf
						EndIf
						j += 1
					EndWhile
					l = 10 * l
					If (skyrimSkyshardHoldQuests[i].GetCurrentStageID() != l)
						skyrimSkyshardHoldQuests[i].SetStage(l)
						Notification("Skyshards: Set Stage Value: " + l)
					EndIf
					l = 0
					j = 0
					skyrimSkyshardHoldQuestHelpers[i].Stop()
				EndIf

			ElseIf (!startSkyshardsQuest(skyrimSkyshardHoldQuestHelpers[i]))
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: We found no filled aliases. Not starting the Skyshard hold quest.")
			EndIf
		EndWhile
	Else
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: WARNING - The Skyshards quest handler has mismatched array lengths!")
	EndIf
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

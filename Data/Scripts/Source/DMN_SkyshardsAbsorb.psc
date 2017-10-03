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

ScriptName DMN_SkyshardsAbsorb Extends ObjectReference  
{Handles several things when a player absorbs a Skyshard;

*Absorption tracking across base game + DLCs/Mods.
*Perk handling.
*Activation blocking.
*Skyshard activator & beacon effect disabling.
}

Import Debug
Import Game
Import Utility
Import DMN_DeadmaniacFunctions

DMN_SkyshardsQuest Property DMN_SQN Auto
DMN_SkyshardsQuestData Property DMN_SQD Auto

Actor Property PlayerRef Auto
{The player reference we will be checking for. Auto-Fill}

FormList Property DMN_SkyshardsAbsorbedList Auto
{Stores all absorbed Skyshards into this FormList. Auto-Fill.}

FormList Property DMN_SkyshardsAbsorbedStaticList Auto
{Stores all dynamically placed Skyshard Statics into this FormList. Auto-Fill.}

FormList Property DMN_SkyshardsBeaconListMCM Auto
{Stores all user-disabled Skyshard Beacons from the MCM. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsActivatedCounter Auto
{Set this to the ACTIVATED global variable to which DLC/Mod this Skyshard belongs to.
So DMN_SkyshardsSkyrimCountActivated will increment the Skyrim Skyshard counter.}

GlobalVariable Property DMN_SkyshardsCountCurrent Auto
{The current amount of Skyshards the player has activated throughout Skyrim and
other DLCs/Mods which resets once it reaches DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountCap Auto
{The amount of Skyshard absorptions required before gaining a perk point. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim and other DLCs/Mods. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsPerkPoints Auto
{The amount of perk points awarded to the player after absorbing DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsSkyrimCountActivated Auto
{Tracks Skyrim Skyshard activations. Set on Skyshard object if in Skyrim worldspace. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDLC01CountActivated Auto
{Tracks DLC01 Skyshard activations. Set on Skyshard object if in DLC01 worldspace. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsShowStaticSkyshards Auto
{Whether or not Skyshard statics are displayed. 1 displayed, 0 hidden.}

Message Property DMN_SkyshardAbsorbedMessage Auto
{The message shown to the player as a notification when a Skyshard is absorbed. Auto-Fill.}

Static Property DMN_SkyshardActivated Auto
{Static version of the Skyshard, switched out when the player activates and absorbs a Skyshard. Auto-Fill.}

Auto State Absorbing
	Event OnActivate(ObjectReference WhoDaresTouchMe)
	; Ensure script runs only if the Skyshard is activated by the player.
		If (WhoDaresTouchMe == PlayerRef)
		; Ensure we don't run the script multiple times per Skyshard activation.
			GotoState("KochBlock")

		; Update global variables.
			DMN_SkyshardsCountCurrent.Mod(1 as Int)
			DMN_SkyshardsActivatedCounter.Mod(1 as Int)
			DMN_SkyshardsCountActivated.Mod(1 as Int)
			
		; Add this Skyshard to a FormList so we know it was activated.
			DMN_SkyshardsAbsorbedList.AddForm(Self)
			
		; Disable the Skyshard and begin the animation sequence.
			ObjectReference disabledSkyshardStatic = PlaceAtMe(DMN_SkyshardActivated, 1, True, True)
		; Only show the Skyshard static if the user hasn't chosen to disable them.
			If (DMN_SkyshardsShowStaticSkyshards.GetValue() as Int != 0)
				disabledSkyshardStatic.EnableNoWait() ; Used to enable the Skyshard Static WITHOUT a fade-in.
			EndIf
			DMN_SkyshardsAbsorbedStaticList.AddForm(disabledSkyshardStatic) ; Add the Skyshard Static to a FormList for future use.
			Wait(1)
			Disable(True) ; Disable the Skyshard Activator WITH a fade-out.
		; Remove the Skyshard Beacon from the beacon list managed by the MCM, if it exists.
			If DMN_SkyshardsBeaconListMCM.HasForm(GetLinkedRef())
				DMN_SkyshardsBeaconListMCM.RemoveAddedForm(GetLinkedRef())
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Beacon detected and removed from the MCM beacon FormList.")
			EndIf
			Wait(2)
			GetLinkedRef().Disable(True) ; Disable the Skyshard Beacon with a fade-out.
			
		; Check if the Skyshard activated is from Skyrim.
			If (DMN_SkyshardsActivatedCounter == DMN_SkyshardsSkyrimCountActivated)
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You activated a Skyrim Skyshard!")

			; Check if the Skyshards in Skyrim quest is running, and if it is not then start it.
				DMN_SQN.startMainQuest("Skyrim")

		; Check if the Skyshard activated is from DLC01 (Dawnguard).
			ElseIf (DMN_SkyshardsActivatedCounter == DMN_SkyshardsDLC01CountActivated)
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You activated a Dawnguard Skyshard!")
				
			; Add DLC01 start quest here.
				; DMN_SQN.startMainQuest("Dawnguard")
			EndIf
			
		; Show the abosrb message once we've allocated the Skyshard counters
		; AND if the user has chosen not to opt out of point distribution.
			If (DMN_SkyshardsPerkPoints.GetValue() as Int != 0)
				DMN_SkyshardAbsorbedMessage.Show()
			EndIf

		; Check if we reach the specified Skyshards cap to give perk points and
		; ensure that the user has not chosen to opt out of point distribution.
			If (DMN_SkyshardsCountCurrent.GetValue() as Int == DMN_SkyshardsCountCap.GetValue() as Int && \
			DMN_SkyshardsPerkPoints.GetValue() as Int != 0)
				AddPerkPoints(DMN_SkyshardsPerkPoints.GetValue() as Int)
				DMN_SkyshardsCountCurrent.SetValue(0 as Int)
				Notification("Skyshards: I have absorbed enough Skyshards to advance my skills!")
		; Else the user had turned off perk point distribution at some point.
			Else
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Perk point distribution is disabled. Skipping perk point allocation.")
			EndIf
			
		; Update the global variable values for the tracking quests and check for main quest progression.
			DMN_SQN.updateGlobals()
			DMN_SQN.updateMainQuests()
			
		; Update the relevant Skyshards side-quest to take into account this absorbed Skyshard.
			DMN_SQD.updateSideQuests()
			
			DMN_SQN.updateMainQuests(True) ; Finalise parameter set to true to complete main quests if requirements are met.
		EndIf
	EndEvent
EndState

State KochBlock
	Event OnActivate(ObjectReference WhoDaresTouchMe)
	; Empty state. Ensures we don't run our Absorbing state multiple times due to player triggers.
	EndEvent
EndState

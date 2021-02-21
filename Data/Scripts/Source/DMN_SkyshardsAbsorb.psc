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
{Set this to the ACTIVATED global variable to which DLC/Mod this Skyshard belongs to.}

GlobalVariable Property DMN_SkyshardsCountCurrent Auto
{The current amount of Skyshards the player has activated throughout Skyrim and
other DLCs/Mods which resets once it reaches DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountCap Auto
{The amount of Skyshard absorptions required before gaining a perk point. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsPerkPoints Auto
{The amount of perk points awarded to the player after absorbing DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsShowStaticSkyshards Auto
{Whether or not Skyshard statics are displayed. 1 displayed, 0 hidden.}

Static Property DMN_SkyshardActivated Auto
{Static version of the Skyshard, switched out when the player activates and absorbs a Skyshard. Auto-Fill.}

Auto State Absorbing
	Event OnActivate(ObjectReference WhoDaresTouchMe)
	; Ensure script runs only if the Skyshard is activated by the player.
		If (WhoDaresTouchMe == PlayerRef)
		; Ensure we don't run the script multiple times per Skyshard activation.
			GotoState("KochBlock")
			
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

		; Update the current amount of Skyshards absorbed.
			DMN_SkyshardsCountCurrent.Mod(1 as Int)

		; Begin the process of updating the quests.
			DMN_SQD.beginQuestUpdates(DMN_SkyshardsActivatedCounter)

		; Remove the Skyshard Beacon from the beacon list managed by the MCM, if it exists.
			If DMN_SkyshardsBeaconListMCM.HasForm(GetLinkedRef())
				DMN_SkyshardsBeaconListMCM.RemoveAddedForm(GetLinkedRef())
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Beacon detected and removed from the MCM beacon FormList.")
			EndIf
			Wait(2)
			GetLinkedRef().Disable(True) ; Disable the Skyshard Beacon with a fade-out.

		; Get the value of the global variables for later use.
			Int absorbedSkyshards = DMN_SkyshardsCountCurrent.GetValue() as Int
			Int absorbCap = DMN_SkyshardsCountCap.GetValue() as Int
			Int perkPointsGiven = DMN_SkyshardsPerkPoints.GetValue() as Int

		; Show the absorb message once we've allocated the Skyshard counters
		; AND if the user has chosen not to opt out of point distribution.
		If (DMN_SkyshardsPerkPoints.GetValue() as Int != 0)
			Notification("Skyshard absorbed! Pieces collected: " + \
			absorbedSkyshards + "/" + absorbCap + ".")
		EndIf

		; Catch any overflows/incorrect values and reset them to defaults.
			If (absorbedSkyshards < 0)
				absorbedSkyshards = 0
				DMN_SkyshardsCountCurrent.SetValue(0)
			EndIf
			If (absorbCap < 0)
				absorbCap = 3
				DMN_SkyshardsCountCap.SetValue(3)
			EndIf
			If (perkPointsGiven < 0)
				perkPointsGiven = 0
				DMN_SkyshardsPerkPoints.SetValue(0)
			EndIf

		; So long as we have enough absorbed Skyshards, give perk points.
			If (absorbedSkyshards >= absorbCap && perkPointsGiven != 0)
				While (absorbedSkyshards >= absorbCap)
					AddPerkPoints(perkPointsGiven)
					absorbedSkyshards = absorbedSkyshards - absorbCap
					DMN_SkyshardsCountCurrent.SetValue(absorbedSkyshards)
				EndWhile
				Notification("Skyshards: I have absorbed enough Skyshards to " + \
				"advance my skills!")
		; Else the user had turned off perk point distribution at some point.
			ElseIf(perkPointsGiven == 0)
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: " + \
				"Perk point distribution is disabled. Skipping perk point " + \
				"allocation.")
			EndIf
		EndIf
	EndEvent
EndState

State KochBlock
	Event OnActivate(ObjectReference WhoDaresTouchMe)
	; Empty state. Ensures we don't run our Absorbing state multiple times due to player triggers.
	EndEvent
EndState
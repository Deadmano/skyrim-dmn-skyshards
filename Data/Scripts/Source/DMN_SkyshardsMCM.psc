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

ScriptName DMN_SkyshardsMCM Extends ObjectReference

{Temporary mod configuration script pre-MCM.}

Import Game
Import Debug
Import Utility
Import DMN_SkyshardsFunctions

DMN_SkyshardsQuestData Property DMN_SQD Auto

Alias Property skyshardBeaconEnabled Auto
Alias Property skyshardBeaconDisabled Auto

FormList Property DMN_SkyshardsMapMarkersList Auto
FormList Property DMN_SkyshardsBeaconList Auto
FormList Property DMN_SkyshardsAbsorbedList Auto

GlobalVariable Property DMN_SkyshardsCountCap Auto
GlobalVariable Property DMN_SkyshardsCountCurrent Auto
GlobalVariable Property DMN_SkyshardsDebug Auto
GlobalVariable Property DMN_SkyshardsPerkPoints Auto
GlobalVariable Property DMN_SkyshardsQuestSystem Auto

Message Property DMN_SkyshardsConfigMenu Auto
Message Property DMN_SkyshardsConfigMenuBeacons Auto
Message Property DMN_SkyshardsConfigMenuMapMarkers Auto
Message Property DMN_SkyshardsConfigMenuMisc Auto
Message Property DMN_SkyshardsConfigMenuMiscPerkPoints Auto
Message Property DMN_SkyshardsConfigMenuMiscSkyshardsCap Auto
Message Property DMN_SkyshardsConfigMenuQuestSystem Auto
Message Property DMN_SkyshardsPerkPointDistribution Auto

Quest Property DMN_SkyshardsHelper Auto

Event OnRead()
	Wait(0.1)
	configureMod()
EndEvent

Function configureMod()
; Stop further config menu activation until we finish processing this request.
	GotoState("configuring")
; MAIN CONFIG MENU
	Int choice = DMN_SkyshardsConfigMenu.Show()
	;------------
	; MAP MARKERS
	;============
	If (choice == 0)
		Int choice00 = DMN_SkyshardsConfigMenuMapMarkers.Show()
		If (choice00 == 0)
		; Enable Map Markers.
			Wait(0.1)
			Notification("Skyshards: Enabling map markers...")
			showSkyshardMapMarkers(DMN_SkyshardsMapMarkersList, True)
			Wait(0.1)
			Notification("Skyshards: Map markers have been enabled!")
		ElseIf (choice00 == 1)
		; Disable Map Markers.
			Wait(0.1)
			Notification("Skyshards: Disabling map markers...")
			showSkyshardMapMarkers(DMN_SkyshardsMapMarkersList, False)
			Wait(0.1)
			Notification("Skyshards: Map markers have been disabled!")
		ElseIf (choice00 == 2)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	;-----------------
	; SKYSHARD BEACONS
	;=================
	ElseIf (choice == 1)
		Int choice01 = DMN_SkyshardsConfigMenuBeacons.Show()
		If (choice01 == 0)
		; Enable Beacons.
			Wait(0.1)
			Notification("Skyshards: Enabling Skyshard beacons...")
			showSkyshardBeacons(DMN_SkyshardsHelper, DMN_SkyshardsBeaconList, True, DMN_SkyshardsDebug)
			Wait(0.1)
			Notification("Skyshards: Skyshard beacons have been enabled!")
		ElseIf (choice01 == 1)
		; Disable Beacons.
			Wait(0.1)
			Notification("Skyshards: Disabling Skyshard beacons...")
			showSkyshardBeacons(DMN_SkyshardsHelper, DMN_SkyshardsBeaconList, False, DMN_SkyshardsDebug, skyshardBeaconEnabled)
			Wait(0.1)
			Notification("Skyshards: Skyshard beacons have been disabled!")
		ElseIf (choice01 == 2)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	;-------------
	; QUEST SYSTEM
	;=============
	ElseIf (choice == 2)
		Int choice02 = DMN_SkyshardsConfigMenuQuestSystem.Show()
		If (choice02 == 0)
		; Full Quest System.
			Wait(0.1)
			Notification("Skyshards: Switching to the Full Quest System...")
			DMN_SkyshardsQuestSystem.SetValue(1 as Int)
			DMN_SQD.updateSideQuests()
			Wait(0.1)
			Notification("Skyshards: Successfully switched to the Full Quest System!")
		ElseIf (choice02 == 1)
		; Lite Quest System.
			Wait(0.1)
			Notification("Skyshards: Switching to the Lite Quest System...")
			DMN_SQD.stopSideQuests()
			DMN_SkyshardsQuestSystem.SetValue(0 as Int)
			Wait(0.1)
			Notification("Skyshards: Successfully switched to the Lite Quest System!")
		ElseIf (choice02 == 2)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	;-----
	; MISC
	;=====
	ElseIf (choice == 3)
		Int choice03 = DMN_SkyshardsConfigMenuMisc.Show()
	; Adjust Skyshards Cap.
		If (choice03 == 0)
			Int choice030 = DMN_SkyshardsConfigMenuMiscSkyshardsCap.Show()
		; Default - 3 Skyshards.
			If (choice030 == 0)
				Wait(0.1)
				DMN_SkyshardsCountCap.SetValue(3 as Int)
				Notification("Skyshards: Set required Skyshards absorbed cap to 3.")
				GoToState("postConfig")
				configureMod()
		; 6 Skyshards.
			ElseIf (choice030 == 1)
				Wait(0.1)
				DMN_SkyshardsCountCap.SetValue(6 as Int)
				Notification("Skyshards: Set required Skyshards absorbed cap to 6.")
				GoToState("postConfig")
				configureMod()
		; 9 Skyshards.
			ElseIf (choice030 == 2)
				Wait(0.1)
				DMN_SkyshardsCountCap.SetValue(9 as Int)
				Notification("Skyshards: Set required Skyshards absorbed cap to 9.")
				GoToState("postConfig")
				configureMod()
		; 12 Skyshards.
			ElseIf (choice030 == 3)
				Wait(0.1)
				DMN_SkyshardsCountCap.SetValue(12 as Int)
				Notification("Skyshards: Set required Skyshards absorbed cap to 12.")
				GoToState("postConfig")
				configureMod()
		; Check Current.
			ElseIf (choice030 == 4)
				Wait(0.1)
				Notification("Skyshards: Required Skyshards absorbed: " + DMN_SkyshardsCountCap.GetValue() as Int + ".")
				GoToState("postConfig")
				configureMod()
		; Return To Main Config Menu.
			ElseIf (choice030 == 5)
				GoToState("postConfig")
				configureMod()
			EndIf
	; Adjust Perk Points Given.
		ElseIf (choice03 == 1)
			Int choice031 = DMN_SkyshardsConfigMenuMiscPerkPoints.Show()
		; 0 Perk Points.
			If (choice031 == 0)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(0 as Int)
				Notification("Skyshards: Disabled perk point distribution.")
				GoToState("postConfig")
				configureMod()
		; Default - 1 Perk Point.
			ElseIf (choice031 == 1)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(1 as Int)
				Notification("Skyshards: Set perk points given to 1.")
				calculatePerkPoints(DMN_SkyshardsCountCurrent, DMN_SkyshardsCountCap, DMN_SkyshardsPerkPoints, DMN_SkyshardsPerkPointDistribution, DMN_SkyshardsDebug)
				GoToState("postConfig")
				configureMod()
		; 2 Perk Points.
			ElseIf (choice031 == 2)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(2 as Int)
				Notification("Skyshards: Set perk points given to 2.")
				calculatePerkPoints(DMN_SkyshardsCountCurrent, DMN_SkyshardsCountCap, DMN_SkyshardsPerkPoints, DMN_SkyshardsPerkPointDistribution, DMN_SkyshardsDebug)
				GoToState("postConfig")
				configureMod()
		; 3 Perk Points.
			ElseIf (choice031 == 3)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(3 as Int)
				Notification("Skyshards: Set perk points given to 3.")
				calculatePerkPoints(DMN_SkyshardsCountCurrent, DMN_SkyshardsCountCap, DMN_SkyshardsPerkPoints, DMN_SkyshardsPerkPointDistribution, DMN_SkyshardsDebug)
				GoToState("postConfig")
				configureMod()
		; 4 Perk Points.
			ElseIf (choice031 == 4)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(4 as Int)
				Notification("Skyshards: Set perk points given to 4.")
				calculatePerkPoints(DMN_SkyshardsCountCurrent, DMN_SkyshardsCountCap, DMN_SkyshardsPerkPoints, DMN_SkyshardsPerkPointDistribution, DMN_SkyshardsDebug)
				GoToState("postConfig")
				configureMod()
		; Check Current.
			ElseIf (choice031 == 5)
				Wait(0.1)
				Notification("Skyshards: Perk points given per absorb cap: " + DMN_SkyshardsPerkPoints.GetValue() as Int + ".")
				GoToState("postConfig")
				configureMod()
		; Return To Main Config Menu.
			ElseIf (choice031 == 6)
				GoToState("postConfig")
				configureMod()
			EndIf
		ElseIf (choice03 == 2)
		; Toggle Debugging.
			Wait(0.1)
			If (DMN_SkyshardsDebug.GetValue() as Int == 0)
				Notification("Skyshards: Turning debug messages on...")
				DMN_SkyshardsDebug.SetValue(1 as Int)
				Wait(0.1)
				Notification("Skyshards: Successfully turned debug messages on!")
			ElseIf (DMN_SkyshardsDebug.GetValue() as Int == 1)
				Notification("Skyshards: Turning debug messages off...")
				DMN_SkyshardsDebug.SetValue(0 as Int)
				Wait(0.1)
				Notification("Skyshards: Successfully turned debug messages off!")
			EndIf
		ElseIf (choice03 == 3)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	;-----------------
	; EXIT CONFIG MENU
	;=================
	ElseIf (choice == 4)
	Else
		Notification("Skyshards: The mod configuration script ran into an unknown error. Please inform Deadmano.")
	EndIf
; We can allow config menu activation once more now that the first request has been completed.
	GoToState("postConfig")
EndFunction

State configuring
	Function configureMod()
		; Empty function to ensure user doesn't activate the config menu several times in succession.
		Notification("Skyshards: Please wait for the previous configuration changes to complete...")
	EndFunction
EndState

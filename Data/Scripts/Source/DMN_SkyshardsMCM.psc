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

ScriptName DMN_SkyshardsMCM Extends ObjectReference

{Temporary mod configuration script pre-MCM.}

Import Game
Import Debug
Import Utility
Import DMN_SkyshardsFunctions

DMN_SkyshardsConfig Property DMN_SC Auto
DMN_SkyshardsQuestData Property DMN_SQD Auto

Book Property DMN_SkyshardsConfigurator Auto

FormList Property DMN_SkyshardsAbsorbedStaticList Auto
FormList Property DMN_SkyshardsBeaconList Auto
FormList Property DMN_SkyshardsBeaconListMCM Auto
FormList Property DMN_SkyshardsMapMarkersList Auto

GlobalVariable Property DMN_SkyshardsCountCap Auto
GlobalVariable Property DMN_SkyshardsCountCurrent Auto
GlobalVariable Property DMN_SkyshardsDebug Auto
GlobalVariable Property DMN_SkyshardsPerkPoints Auto
GlobalVariable Property DMN_SkyshardsPersistGodMode Auto
GlobalVariable Property DMN_SkyshardsQuestSystem Auto
GlobalVariable Property DMN_SkyshardsShowBeacons Auto
GlobalVariable Property DMN_SkyshardsShowMapMarkers Auto
GlobalVariable Property DMN_SkyshardsShowStaticSkyshards Auto

Message Property DMN_SkyshardsConfigMenu Auto
Message Property DMN_SkyshardsConfigMenuBeacons Auto
Message Property DMN_SkyshardsConfigMenuMapMarkers Auto
Message Property DMN_SkyshardsConfigMenuMisc Auto
Message Property DMN_SkyshardsConfigMenuMiscPerkPoints Auto
Message Property DMN_SkyshardsConfigMenuMiscSkyshardsCap Auto
Message Property DMN_SkyshardsConfigMenuQuestSystem Auto
Message Property DMN_SkyshardsConfigMenuStatics Auto
Message Property DMN_SkyshardsPerkPointDistribution Auto

Event OnActivate(ObjectReference actor)
	; If the player activates a configurator that was not in their inventory,
	; then disable it, show the player a message, and then destroy it.
	Self.Disable()
	closeBookMenu()
	MessageBox("To prevent outdated property and/or script issues, and to " + \
	"ensure proper mod operation, this configurator used directly from the " + \
	"world was deleted. In the future please use the configurator that is " + \
	"in your inventory directly.")
	Self.Delete()
	; Afterwards, check if a new configurator needs to be given.
	DMN_SC.checkConfigurator()
EndEvent

Event OnRead()
	closeBookMenu()
	; Check if the configurator version the player is running is up to date.
	If (DMN_SC.skyshardsConfiguratorVersion != DMN_SC.skyshardsVersion)
		; If it isn't, update it.
		DMN_SC.checkConfigurator()
		MessageBox("This configurator is outdated and has been removed in " + \
		"order to update any scripts necessary for the configurator " + \
		"options to function correctly. Please check your inventory for an " + \
		"updated one.")
	Else
		; Otherwise continue with configuring the mod.
		Wait(0.1)
		configureMod()
	EndIf
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
			DMN_SkyshardsShowMapMarkers.SetValue(1 as Int)
			showSkyshardMapMarkers(DMN_SkyshardsMapMarkersList, True)
			Wait(0.1)
			Notification("Skyshards: Map markers have been enabled!")
		ElseIf (choice00 == 1)
		; Disable Map Markers.
			Wait(0.1)
			Notification("Skyshards: Disabling map markers...")
			DMN_SkyshardsShowMapMarkers.SetValue(0 as Int)
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
			DMN_SkyshardsShowBeacons.SetValue(1 as Int)
			showSkyshardBeacons(DMN_SkyshardsBeaconList, DMN_SkyshardsBeaconListMCM, DMN_SkyshardsDebug, True)
			Wait(0.1)
			Notification("Skyshards: Skyshard beacons have been enabled!")
		ElseIf (choice01 == 1)
		; Disable Beacons.
			Wait(0.1)
			Notification("Skyshards: Disabling Skyshard beacons...")
			DMN_SkyshardsShowBeacons.SetValue(0 as Int)
			showSkyshardBeacons(DMN_SkyshardsBeaconList, DMN_SkyshardsBeaconListMCM, DMN_SkyshardsDebug, False)
			Wait(0.1)
			Notification("Skyshards: Skyshard beacons have been disabled!")
		ElseIf (choice01 == 2)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	;-----------------
	; SKYSHARD STATICS
	;=================
	ElseIf (choice == 2)
		Int choice02 = DMN_SkyshardsConfigMenuStatics.Show()
		If (choice02 == 0)
		; Enable Statics.
			Wait(0.1)
			Notification("Skyshards: Enabling Skyshard statics...")
			DMN_SkyshardsShowStaticSkyshards.SetValue(1 as Int)
			showSkyshardStatics(DMN_SkyshardsAbsorbedStaticList, True)
			Wait(0.1)
			Notification("Skyshards: Skyshard statics have been enabled!")
		ElseIf (choice02 == 1)
		; Disable Statics.
			Wait(0.1)
			Notification("Skyshards: Disabling Skyshard statics...")
			DMN_SkyshardsShowStaticSkyshards.SetValue(0 as Int)
			showSkyshardStatics(DMN_SkyshardsAbsorbedStaticList, False)
			Wait(0.1)
			Notification("Skyshards: Skyshard statics have been disabled!")
		ElseIf (choice02 == 2)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	;-------------
	; QUEST SYSTEM
	;=============
	ElseIf (choice == 3)
		Int choice03 = DMN_SkyshardsConfigMenuQuestSystem.Show()
		If (choice03 == 0)
		; Full Quest System.
			If (DMN_SkyshardsQuestSystem.GetValue() as Int == 1)
			; Skip switching the quest system if the choice is
			; the same as the currently running quest system.
				Notification("Skyshards: The full quest system is already " + \
				"being used.")
			Else
				Wait(0.1)
				Notification("Skyshards: Switching to the full quest system...")
				DMN_SQD.switchQuestSystem(1)
				Wait(0.1)
				Notification("Skyshards: Successfully switched to the full " + \
				"quest system!")
			EndIf
		ElseIf (choice03 == 1)
		; Lite Quest System.
			If (DMN_SkyshardsQuestSystem.GetValue() as Int == 0)
			; Skip switching the quest system if the choice is
			; the same as the currently running quest system.
				Notification("Skyshards: The lite quest system is already " + \
				"being used.")
				GoToState("postConfig")
				configureMod()
			Else
				Wait(0.1)
				Notification("Skyshards: Switching to the lite quest system...")
				DMN_SQD.switchQuestSystem(0)
				Wait(0.1)
				Notification("Skyshards: Successfully switched to the lite " + \
				"quest system!")
			EndIf
		ElseIf (choice03 == 2)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	;-----
	; MISC
	;=====
	ElseIf (choice == 4)
		Int choice04 = DMN_SkyshardsConfigMenuMisc.Show()
	; Adjust Skyshards Cap.
		If (choice04 == 0)
			Int choice040 = DMN_SkyshardsConfigMenuMiscSkyshardsCap.Show()
		; Default - 3 Skyshards.
			If (choice040 == 0)
				Wait(0.1)
				DMN_SkyshardsCountCap.SetValue(3 as Int)
				Notification("Skyshards: Set required Skyshards absorbed cap to 3.")
				GoToState("postConfig")
				configureMod()
		; 6 Skyshards.
			ElseIf (choice040 == 1)
				Wait(0.1)
				DMN_SkyshardsCountCap.SetValue(6 as Int)
				Notification("Skyshards: Set required Skyshards absorbed cap to 6.")
				GoToState("postConfig")
				configureMod()
		; 9 Skyshards.
			ElseIf (choice040 == 2)
				Wait(0.1)
				DMN_SkyshardsCountCap.SetValue(9 as Int)
				Notification("Skyshards: Set required Skyshards absorbed cap to 9.")
				GoToState("postConfig")
				configureMod()
		; 12 Skyshards.
			ElseIf (choice040 == 3)
				Wait(0.1)
				DMN_SkyshardsCountCap.SetValue(12 as Int)
				Notification("Skyshards: Set required Skyshards absorbed cap to 12.")
				GoToState("postConfig")
				configureMod()
		; Check Current.
			ElseIf (choice040 == 4)
				Wait(0.1)
				Notification("Skyshards: Required Skyshards absorbed: " + DMN_SkyshardsCountCap.GetValue() as Int + ".")
				GoToState("postConfig")
				configureMod()
		; Return To Main Config Menu.
			ElseIf (choice040 == 5)
				GoToState("postConfig")
				configureMod()
			EndIf
	; Adjust Perk Points Given.
		ElseIf (choice04 == 1)
			Int choice041 = DMN_SkyshardsConfigMenuMiscPerkPoints.Show()
		; 0 Perk Points.
			If (choice041 == 0)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(0 as Int)
				Notification("Skyshards: Disabled perk point distribution.")
				GoToState("postConfig")
				configureMod()
		; Default - 1 Perk Point.
			ElseIf (choice041 == 1)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(1 as Int)
				Notification("Skyshards: Set perk points given to 1.")
				calculatePerkPoints(DMN_SkyshardsCountCurrent, DMN_SkyshardsCountCap, DMN_SkyshardsPerkPoints, DMN_SkyshardsPerkPointDistribution, DMN_SkyshardsDebug)
				GoToState("postConfig")
				configureMod()
		; 2 Perk Points.
			ElseIf (choice041 == 2)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(2 as Int)
				Notification("Skyshards: Set perk points given to 2.")
				calculatePerkPoints(DMN_SkyshardsCountCurrent, DMN_SkyshardsCountCap, DMN_SkyshardsPerkPoints, DMN_SkyshardsPerkPointDistribution, DMN_SkyshardsDebug)
				GoToState("postConfig")
				configureMod()
		; 3 Perk Points.
			ElseIf (choice041 == 3)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(3 as Int)
				Notification("Skyshards: Set perk points given to 3.")
				calculatePerkPoints(DMN_SkyshardsCountCurrent, DMN_SkyshardsCountCap, DMN_SkyshardsPerkPoints, DMN_SkyshardsPerkPointDistribution, DMN_SkyshardsDebug)
				GoToState("postConfig")
				configureMod()
		; 4 Perk Points.
			ElseIf (choice041 == 4)
				Wait(0.1)
				DMN_SkyshardsPerkPoints.SetValue(4 as Int)
				Notification("Skyshards: Set perk points given to 4.")
				calculatePerkPoints(DMN_SkyshardsCountCurrent, DMN_SkyshardsCountCap, DMN_SkyshardsPerkPoints, DMN_SkyshardsPerkPointDistribution, DMN_SkyshardsDebug)
				GoToState("postConfig")
				configureMod()
		; Check Current.
			ElseIf (choice041 == 5)
				Wait(0.1)
				Notification("Skyshards: Perk points given per absorb cap: " + DMN_SkyshardsPerkPoints.GetValue() as Int + ".")
				GoToState("postConfig")
				configureMod()
		; Return To Main Config Menu.
			ElseIf (choice041 == 6)
				GoToState("postConfig")
				configureMod()
			EndIf
	; Persist God Mode.
		ElseIf (choice04 == 2)
			Wait(0.1)
			If (DMN_SkyshardsPersistGodMode.GetValue() as Int == 0)
				Notification("Skyshards: Persisting god mode state...")
				DMN_SkyshardsPersistGodMode.SetValue(1 as Int)
				Wait(0.1)
				Notification("Skyshards: Successfully persisted god mode!")
			EndIf
			GoToState("postConfig")
			configureMod()
	; Unpersist God Mode.
		ElseIf (choice04 == 3)
			Wait(0.1)
			If (DMN_SkyshardsPersistGodMode.GetValue() as Int == 1)
				Notification("Skyshards: Unpersisting god mode...")
				DMN_SkyshardsPersistGodMode.SetValue(0 as Int)
				Wait(0.1)
				Notification("Skyshards: Successfully unpersisted god mode!")
			EndIf
			GoToState("postConfig")
			configureMod()
		ElseIf (choice04 == 4)
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
		ElseIf (choice04 == 5)
			; Reset Configurator.
				Wait(0.1)
				giveConfigurator(DMN_SkyshardsConfigurator)
				Notification("Skyshards: A new Skyshard configurator was placed in your inventory.")
		ElseIf (choice04 == 6)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	;-----------------
	; EXIT CONFIG MENU
	;=================
	ElseIf (choice == 5)
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

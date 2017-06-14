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

ScriptName DMN_SkyshardsConfig Extends Quest

{Skyshards - Configuration Script by Deadmano.}
;==============================================
; Version: 1.2.0
;===============

Import DMN_DeadmaniacFunctions
Import DMN_SkyshardsFunctions
Import Debug
Import Game
Import Utility

DMN_SkyshardsQuest Property DMN_SQN Auto
DMN_SkyshardsQuestData Property DMN_SQD Auto

Book Property DMN_SkyshardsConfigurator Auto
{Stores the temporary mod configurator. Auto-Fill.}

FormList Property DMN_SkyshardsMapMarkersList Auto
{Stores all the Skyshard map markers.}

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable.}

; --

; User's Installed Script Version as an Integer.
GlobalVariable Property DMN_iSkyshardsVersionInstalled Auto 
{Stores the users Skyshards version. Auto-Fill.}
; User's Installed Script Version as a string.
String DMN_sSkyshardsVersionInstalled 

; Current Script Version Being Run.
Int DMN_iSkyshardsVersionRunning
String DMN_sSkyshardsVersionRunning

; The following store the amount of Skyshards
; that each version of the mod contains.
Int DMN_iSkyshardsTotal_v1_0_0
Int DMN_iSkyshardsTotal_v1_1_0
Int DMN_iSkyshardsTotal_v1_2_0

; BEGIN Update Related Variables and Properties
;==============================================
;
; BEGIN v1.1.0
;-------------

Alias Property skyshardStatic Auto
{The alias on the Helper quest that fills with all found Skyshard statics. Auto-Fill.}

FormList Property DMN_SkyshardsAbsorbedList Auto
{Stores all absorbed Skyshards into this FormList. Auto-Fill.}

FormList Property DMN_SkyshardsAbsorbedStaticList Auto
{Stores all dynamically placed Skyshard Statics into this FormList. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim and other DLCs/Mods. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsSkyrimCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDLC01CountActivated Auto
{Tracks DLC01 Skyshard activations. Set on Skyshard object if in DLC01 worldspace. Auto-Fill.}

Message Property DMN_SkyshardsUpdateAnnouncement_v1_1_0 Auto
{The message that is shown to the player for the update to version 1.1.0. Auto-Fill.}

Quest Property DMN_SkyshardsHelper Auto
{The Quest that also handles the once-off removal of dynamically placed Skyshard Statics. Auto-Fill.}

Static Property DMN_SkyshardActivated Auto
{Static version of the Skyshard, switched out when the player activates and absorbs a Skyshard. Auto-Fill.}

; END v1.1.0
;-------------

; BEGIN v1.2.0
;-------------

GlobalVariable Property DMN_SkyshardsCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim and other DLCs/Mods. Auto-Fill.}
GlobalVariable Property DMN_SkyshardsSkyrimCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim. Auto-Fill.}

; END v1.2.0
;-------------

; END Update Related Variables and Properties
;==============================================

Event OnInit()
	preMaintenance() ; Function to run before the main script maintenance.
    Maintenance() ; Function to handle script maintenance.
EndEvent

Function preMaintenance()
	Int i = 0

; Set the total Skyshards found values to the total of each DLC/Mod + base game.
; Skipped if an existing value is found. Used to correct v1.0.0 saves only.
	If (i == 0 && DMN_SkyshardsCountActivated.GetValue() as Int == 0)
	i = (DMN_SkyshardsSkyrimCountActivated.GetValue() as Int) + (DMN_SkyshardsDLC01CountActivated.GetValue() as Int)
	DMN_SkyshardsCountActivated.SetValue(i as Int)
	i = 0
	EndIf
EndFunction
 
Function Maintenance()
; The latest (current) version of Skyshards. Update this to the version number.
	parseSkyshardsVersion("1", "2", "0") ; <--- CHANGE! No more than: "9e9", "99", "9".
; ---------------- UPDATE! ^^^^^^^^^^^

; Skyshards added per version.
	DMN_iSkyshardsTotal_v1_0_0 = 21	; v1.0.0
	DMN_iSkyshardsTotal_v1_1_0 = 21 ; v1.1.0
	DMN_iSkyshardsTotal_v1_2_0 = 43 ; v1.2.0

	If (DMN_SkyshardsDebug.GetValue() == 1)
		If (DMN_sSkyshardsVersionInstalled)
			Wait(0.1)
			Notification("Skyshards DEBUG: An existing install of Skyshards was detected on this save!")
			If (DMN_sSkyshardsVersionInstalled == "")
				Wait(0.1)
				Notification("Skyshards DEBUG: This save is referencing an unknown version of Skyshards' configuration script.")
			Else
				Wait(0.1)
				Notification("Skyshards DEBUG: This save is referencing version " + DMN_sSkyshardsVersionInstalled + " of Skyshards' configuration script.")
			EndIf
			Wait(0.1)
			Notification("Skyshards DEBUG: You are running Skyshards' version " + DMN_sSkyshardsVersionRunning + " configuration script.")
		EndIf
	EndIf

; Check to see if this is a new install.
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "0", "0"))
	
	; //Debug - Check if Skyshards reaches the new install check.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - New Install Check Reached.")
	
	; If it is, install Skyshards for the first time to this save.
		installSkyshards()

; Else check to see if the user's installed Skyshards version is less than this running version of Skyshards.
; Or if any Skyshards were absorbed, to detect a previous install from the legacy v1.0.0 version.
	ElseIf (DMN_iSkyshardsVersionInstalled.GetValue() as Int < DMN_iSkyshardsVersionRunning)

	; //Debug - Check if Skyshards reaches the update check.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Check Reached.")
	
	; If it is then we need to run the update on this save.
		updateSkyshards()

; Check to see if the user is loading a save with an existing Skyshards install but is using older Skyshards scripts than those saved with.
	ElseIf (DMN_iSkyshardsVersionInstalled.GetValue() as Int > DMN_iSkyshardsVersionRunning)
		Wait(0.1)
		MessageBox("Skyshards has detected that you are using one or more outdated scripts than those used when this save was created. This is just a warning and you may continue to play with unknown side-effects; though for best results it is advised that you update to the latest version.")

; Check to see if the user's installed Skyshards version matches this running version of Skyshards.
	ElseIf (DMN_iSkyshardsVersionInstalled.GetValue() as Int == DMN_iSkyshardsVersionRunning)
	
	; //Debug - Check if Skyshards reaches the versions match check.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Versions Match Check Reached.")
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: String Value: " + DMN_sSkyshardsVersionRunning)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Integer Value: " + DMN_iSkyshardsVersionRunning)

; No idea how the user got here, but good to grab just in case!
	Else
		Wait(0.1)
		MessageBox("WARNING: The version of Skyshards cannot be detected! Please inform Deadmano.")
	EndIf
EndFunction

Function parseSkyshardsVersion(String sMajorVer, String sMinorVer, String sReleaseVer)
	DMN_iSkyshardsVersionRunning = ver3ToInteger(sMajorVer, sMinorVer, sReleaseVer)
	DMN_sSkyshardsVersionRunning = ver3ToString(sMajorVer, sMinorVer, sReleaseVer)
EndFunction

Function installSkyshards()
; //Debug - Check if Skyshards reaches the install function.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Install Function Reached.")
	
; Check if previous Skyshards have been found from the legacy v1.0.0 version of Skyshards.
	If (DMN_SkyshardsCountActivated.GetValue() as Int > 0)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Unknown Previous Version Update.")
	; If any are found, we need to update this save's version of Skyshards.
		updateSkyshards()
; Otherwise treat this save as a clean install.
	Else
		Wait(0.1)
		Notification("Skyshards: Installation and configuration in progress.")
		
	; Set the default configuration settings.
		configurationDefaults()
		
	; Updates the user's installed Skyshards version to this running version of Skyshards.
		DMN_iSkyshardsVersionInstalled.SetValue(DMN_iSkyshardsVersionRunning as Int) ; Integer.
		DMN_sSkyshardsVersionInstalled = DMN_sSkyshardsVersionRunning ; String.
		Wait(0.1)
		Notification("Skyshards: You are now running version " + DMN_sSkyshardsVersionInstalled + ". Enjoy!")

	; //Debug - Check if Skyshards passes the install function.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Install Function Passed.")
	EndIf
EndFunction

Function updateSkyshards()
; //Debug - Check if Skyshards reaches the update function.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Function Reached.")

	If (DMN_sSkyshardsVersionInstalled == "")
		Wait(0.1)
		Notification("Skyshards: Updating from a previous unknown version.")
	Else
		Wait(0.1)
		Notification("Skyshards: Updating from version " + DMN_sSkyshardsVersionInstalled + ".")
	EndIf

	; // BEGIN UPDATE FOR CURRENT SCRIPT VERSION
	;-------------------------------------------
	
; BEGIN v1.0.0 FIXES/PATCHES
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "1", "0"))
	; Removal of all static (activated) Skyshards that were dynamically added and couldn't be directly referenced.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Removing dynamically placed Skyshard statics now...")
		removeDynamicSkyshardStatics(DMN_SkyshardsHelper, skyshardStatic)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: All dynamically placed Skyshard statics have been removed!")
	; Adding Skyshard Statics dynamically at the location of the Skyshard Activators.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Placing Skyshard statics at updated absorbed Skyshard locations now...")
		placeSkyshardStatics(DMN_SkyshardsAbsorbedList, DMN_SkyshardActivated, DMN_SkyshardsAbsorbedStaticList)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: All Skyshard statics have been placed!")
	; Start the main quest up to start tracking existing Skyshards and future ones as well.
		DMN_SQN.startMainQuest("Skyrim")
	; Update the quest progress of all previously found Skyshards.
		DMN_SQD.updateSideQuests()
	EndIf
; END v1.0.0 FIXES/PATCHES

	; // BEGIN VERSION SPECIFIC ANNOUNCEMENT MESSAGES
	;------------------------------------------------

; v1.1.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "1", "0") && \
		DMN_sSkyshardsVersionRunning == "1.1.0")
		DMN_SkyshardsUpdateAnnouncement_v1_1_0.Show()
	EndIf

	; // END VERSION SPECIFIC ANNOUNCEMENT MESSAGES
	;------------------------------------------------
	
	; // BEGIN VERSION SPECIFIC UPDATES
	;----------------------------------
	
; v1.2.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "2", "0") && \
		DMN_sSkyshardsVersionRunning == "1.2.0")
		DMN_SkyshardsCountTotal.SetValue(DMN_iSkyshardsTotal_v1_2_0 as Int)
		DMN_SkyshardsSkyrimCountTotal.SetValue(DMN_iSkyshardsTotal_v1_2_0 as Int)
		DMN_SQN.updateGlobals()
		Notification("Skyshards: Scholars confirm additional Skyshards have phased into existence! " + "(" + DMN_iSkyshardsTotal_v1_1_0 + " > " + DMN_iSkyshardsTotal_v1_2_0 + ").")
	EndIf
	
	; // END VERSION SPECIFIC UPDATES
	;----------------------------------

	; // END UPDATE FOR CURRENT SCRIPT VERSION
	;-------------------------------------------
	
; Set the default configuration settings.
	configurationDefaults()

; Updates the user's installed Skyshards version to this running version of Skyshards.
	DMN_iSkyshardsVersionInstalled.SetValue(DMN_iSkyshardsVersionRunning as Int) ; Integer.
	DMN_sSkyshardsVersionInstalled = DMN_sSkyshardsVersionRunning ; String.
	Wait(0.1)
	Notification("Skyshards: You are now running version " + DMN_sSkyshardsVersionInstalled + ". Enjoy!")

; //Debug - Check if Skyshards passes the update function.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Function Passed.")
EndFunction

Function configurationDefaults()
; Add (or update) the mod configurator to the player inventory silently.
	giveConfigurator(DMN_SkyshardsConfigurator)
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Gave the player the latest Skyshards Configurator!")
	
; Disable the Skyshard map markers.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Disabling Skyshard map markers...")
	showSkyshardMapMarkers(DMN_SkyshardsMapMarkersList, False)
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Skyshard map markers have been disabled!")
EndFunction

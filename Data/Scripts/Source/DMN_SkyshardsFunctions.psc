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

ScriptName DMN_SkyshardsFunctions

{A custom collection of functions by Deadmano
to enhance the Skyshards mod.}

Import Debug
Import Game
Import Math
Import Utility
Import DMN_DeadmaniacFunctions

Function removeDynamicSkyshardStatics(Quest qst, Alias als) Global
    qst.Start() ; Start the quest to fill the alias with the first match.
	If qst.IsStarting()
		Wait(0.1)
	EndIf
	ObjectReference ref = (als as ReferenceAlias).GetReference()
	While (ref != None) ; Stop looping once our alias cannot be found.
		If (qst.IsStopped())
			qst.Start() ; Start the quest in the loop.
		EndIf
		If qst.IsStarting()
			Wait(0.1)
		EndIf
		ref = (als as ReferenceAlias).GetReference()
		If (ref != None) ; Ensure we don't waste time performing actions on an empty reference.
		; Delete found references that are enabled or disabled.
			If (ref.IsEnabled() || ref.IsDisabled())
				ref.Delete() ; Destroy the reference.
				ref = None ; Set the reference instance to None to remove its persistence.
			EndIf
		EndIf
		If (qst.IsRunning())
			qst.Stop() ; Stop the quest in the loop.
		EndIf
	EndWhile
    qst.Stop() ; Once there are no more matches to fill the alias, we end the quest.
EndFunction

Function removeSkyshardStatics(FormList staticList) Global
	Int i = staticList.GetSize()
	While i
		i -= 1
		ObjectReference ref = staticList.GetAt(i) as ObjectReference
		If (staticList.GetAt(i) == ref)
			ref.Delete() ; Destroy the Skyshard Static reference.
			ref = None ; Set the Skyshard Static reference to None to remove its persistence.
		EndIf
	EndWhile
	staticList.Revert() ; Empty the FormList containing all the Skyshard Activators.
EndFunction

Function placeSkyshardStatics(FormList activatorList, Static staticObject, FormList staticList) Global
	Int i = activatorList.GetSize()
	While i
		i -= 1
		ObjectReference activatedSkyshard = activatorList.GetAt(i) as ObjectReference
		ObjectReference disabledSkyshardStatic = activatedSkyshard.PlaceAtMe(staticObject, 1, True, True)
		disabledSkyshardStatic.EnableNoWait() ; Used to enable the Skyshard Static WITHOUT a fade-in.
		staticList.AddForm(disabledSkyshardStatic) ; Add the Skyshard Static to a FormList for future use.
	EndWhile
EndFunction

Function showSkyshardMapMarkers(FormList mapMarkerList, Bool toggleState) Global
	Int i = mapMarkerList.GetSize() ; Get the count of Map Markers in the FormList.
	While (i) ; Stop looping if we can't find a Map Marker in our FormList.
		i -= 1
		ObjectReference ref = mapMarkerList.GetAt(i) as ObjectReference
	; Ensure our reference is a Map Marker in our FormList.
		If (mapMarkerList.GetAt(i) == ref)
		; Disable found references that are enabled.
			If (toggleState == False)
				If (ref.IsEnabled())
					ref.Disable()
				EndIf
		; Enable found references that are enabled.
			ElseIf (toggleState == True)
				If (ref.IsDisabled())
					ref.Enable()
				EndIf
			EndIf
		EndIf
	EndWhile
EndFunction

Function showSkyshardBeacons(Quest qst, FormList flt, Bool toggleState, GlobalVariable gVar, Alias als = None) Global
; Enable found references that are disabled and not part of a FormList.
	Int i = flt.GetSize() ; Get the number of items in the FormList.
	If (toggleState)
		int j
		While (i > 0) ; Stop looping once we have gone through each record in our FormList.
			i -= 1
			ObjectReference beacon = flt.GetAt(i) as ObjectReference
			beacon.Enable()
			j += 1
		EndWhile
		debugNotification(gVar, "Skyshards DEBUG: " + (j-i) + "/" + j + " Skyshard beacons enabled.")
		flt.Revert() ; Empty out the FormList once we are done enabling all records therein.
	ElseIf (!toggleState)
		qst.Start() ; Start the quest to fill the alias with the first match.
		If qst.IsStarting()
			Wait(0.1)
		EndIf
		Int k
		ObjectReference ref = (als as ReferenceAlias).GetReference()
		While (ref != None) ; Stop looping once our alias cannot be found.
			If (qst.IsStopped())
				qst.Start() ; Start the quest in the loop.
				If (qst.IsStarting())
					Wait(0.1)
				EndIf
			EndIf
			ref = (als as ReferenceAlias).GetReference()
			If (ref && ref.IsEnabled()) ; Ensure we don't waste time performing actions on an empty reference.
				flt.AddForm(ref) ; Add the disabled Skyshard Beacon to a FormList for future use.
				ref.Disable(); Disable found references that are enabled.
				k += 1
			EndIf
			If (qst.IsRunning())
				qst.Stop() ; Stop the quest in the loop.
			EndIf
		EndWhile
		qst.Stop() ; Once there are no more matches to fill the alias, we end the quest.
		debugNotification(gVar, "Skyshards DEBUG: " + (k-i) + "/" + k + " Skyshard beacons disabled.")
	EndIf
EndFunction

Int Function checkSkyshardQuestAlias(Quest qst)
	Int i = 0
	Int j
	qst.Start() ; Start the quest to fill the alias with the first match.
	If qst.IsStarting()
		Wait(0.1)
	EndIf
	While (qst.GetAlias(i)) ; Stop looping once our alias cannot be found.
		ObjectReference ref = (qst.GetAlias(i) as ReferenceAlias).GetReference()
		If (ref && ref.IsDisabled())
			j += 1
		EndIf
		i += 1
	EndWhile
	qst.Stop() ; Once there are no more matches to fill the alias, we end the quest.
	Return j ; The amount of Skyshards absorbed, to update quest objectives.
EndFunction

Function giveConfigurator(Book configurator) Global
; Save the amount of configurators the player has in their inventory.
	Actor ref = GetPlayer()
	Int i = ref.GetItemCount(configurator)
	If (i == 0)
; If the player has none, add a single configurator to their inventory, silently.
		ref.AddItem(configurator, 1, True)
	ElseIf (i >= 1)
; Else remove every configurator in the player inventory and add one, silently.
		ref.RemoveItem(configurator, i, True)
		ref.AddItem(configurator, 1, True)
	EndIf
EndFunction

Function calculatePerkPoints(GlobalVariable countCurrent, GlobalVariable countCap, GlobalVariable perkPoints, Message msg, GlobalVariable gVar) Global
	Int i = countCurrent.GetValue() as Int
	Int j = countCap.GetValue() as Int
	Int k = perkPoints.GetValue() as Int
	If (i > j)
		Float x = i as Float / j as Float
		Int l = Floor(x)
		Int m = l * k
		Float y = x - l
		Float z = y * j
		Int n = round(z)
		Int choice = msg.Show(i, k, j, m)
		If (choice == 0)
			Wait(0.1)
		; Perk Points to give the player.
			AddPerkPoints(m)
		; Remainder of the Skyshards found as current.
			countCurrent.SetValue(n)
			Notification("Skyshards: I have absorbed enough Skyshards to advance my skills!")
			debugNotification(gVar, "Skyshards DEBUG: Detected a higher Skyshards absorbed count over the cap! Distributing perk points...")
			debugNotification(gVar, "Skyshards DEBUG: Skyshards absorbed since last distribution: " + i + ". Current cap value per perk point: " + j + ".")
			debugNotification(gVar, "Skyshards DEBUG: Perk points given: " + m + ". Remainder under cap: " + n + ".")
		ElseIf (choice == 1)
			countCurrent.SetValue(0)
			debugNotification(gVar, "Skyshards DEBUG: Reset skyshards absorbed counter to 0.")
		EndIf
	EndIf
EndFunction

Function updateQuestProgress(Quest qst, Quest qstHelper, GlobalVariable gVar, String holdName, Int skyshardsActivated, Int skyshardsTotal) Global
	startQuestSafe(qstHelper) ; Start the helper quest to perform checks on.
	Bool startQuest
	Int i = 0
	Int j
	Int k
	Int l = 0
	While (qstHelper.GetAlias(i)) ; Loop through each alias attached to the helper quest. 
		ObjectReference ref = getQuestAlias(qstHelper, i)
	 ; If we find a reference that exists and is disabled, do the following...
		If (ref && ref.IsDisabled())
			k += 1
			startQuest = True
		 ; If we found a valid reference and the quest isn't running, do the following...
			If (startQuest && !qst.IsRunning())
				startQuestSafeSetStage(qst) ; Start the quest up and set its initial stage.
			EndIf
		EndIf
		i += 1
	EndWhile
	While (qstHelper.GetAlias(l)) ; Loop through each alias attached to the helper quest.
		ObjectReference ref = getQuestAlias(qstHelper, l)
		If (qst.IsRunning()) ; So long as the quest is running, do the following...
		; Set and display the objective for each Skyshard.
			setQuestObjectiveDisplayed(ref, qst, l, j, gVar, holdName)
		; Mark specific objectives as complete for any found Skyshards.
			setQuestObjectiveCompleted(ref, qst, l, j, gVar, holdName)
		EndIf
		l += 1
	EndWhile
	startQuest = False
	skyshardsActivated = k ; The value of activated Skyshards, based on each reference found that is disabled.
	skyshardsTotal = i ; The total value of Skyshards, based on each reference found.
	debugNotification(gVar, "Skyshards DEBUG: The amount of " + holdName + " Skyshards found: " + skyshardsActivated + "/" + skyshardsTotal)
	setQuestStage(qst, k, gVar, holdName)
	stopQuestSafe(qstHelper)
EndFunction

Function hideQuestObjective(Quest qst, Quest qstHelper, GlobalVariable gVar, String holdName) Global
	startQuestSafe(qstHelper) ; Start the helper quest to perform checks on.
	Int i = 0
	Int j
	While (qstHelper.GetAlias(i)) ; Loop through each alias attached to the helper quest. 
		ObjectReference ref = getQuestAlias(qstHelper, i)
	 ; If we find a reference that exists, do the following...
		If (ref)
			j = 10 * (1+i)
			If (qst.IsObjectiveDisplayed(j))
			; Hide the quest objective that is displayed.
				qst.SetObjectiveDisplayed(j, False, True)
				debugNotification(gvar, "Skyshards DEBUG: Set " + holdName + " quest objective index (" + j + ") to hidden.")
			EndIf
		EndIf
		j = 0
		i += 1
	EndWhile
	stopQuestSafe(qstHelper)
EndFunction

Function startQuestSafe(Quest qst) Global
	If (!qst.IsRunning())
		qst.Start()
		If qst.IsStarting()
			Wait(0.1)
		EndIf
	EndIf
EndFunction

Function startQuestSafeSetStage(Quest qst) Global
	startQuestSafe(qst)
	qst.SetStage(10)
EndFunction

Function stopQuestSafe(Quest qst) Global
	If (qst.IsRunning())
		qst.Stop()
		If qst.IsStopping()
			Wait(0.1)
		EndIf
	EndIf
EndFunction

ObjectReference Function getQuestAlias(Quest qst, Int enum) Global
	ObjectReference ref = (qst.GetAlias(enum) as ReferenceAlias).GetReference()
	Return ref
EndFunction

Function setQuestObjectiveDisplayed(ObjectReference ref, Quest qst, Int enum1, Int enum2, GlobalVariable gVar, String holdName) Global
	If (ref)	
		enum2 = 10 * (1+enum1)
		If (!qst.IsObjectiveDisplayed(enum2))
			qst.SetObjectiveDisplayed(enum2, True, True)
			debugNotification(gvar, "Skyshards DEBUG: Set " + holdName + " quest objective index (" + enum2 + ") to displayed.")
		EndIf
	EndIf
EndFunction

Function setQuestObjectiveCompleted(ObjectReference ref, Quest qst, Int enum1, Int enum2, GlobalVariable gVar, String holdName) Global
	If (ref && ref.IsDisabled())
		enum2 = 10 * (1+enum1)
		If (!qst.IsObjectiveCompleted(enum2))
			qst.SetObjectiveCompleted(enum2)
			debugNotification(gVar, "Skyshards DEBUG: Set " + holdName + " quest objective index (" + enum2 + ") to completed.")
		EndIf
	EndIf
EndFunction

Function setQuestStage(Quest qst, Int enum, GlobalVariable gVar, String holdName) Global
	enum = 10 * enum
	If (qst.GetCurrentStageID() != enum)
		qst.SetStage(enum)
		debugNotification(gVar, "Skyshards DEBUG: Set " + holdName + " quest stage index to (" + enum + ").")
	EndIf
EndFunction

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

ScriptName DMN_DeadmaniacFunctions

{A custom collection of functions by Deadmano
to enhance Papyrus scripting.}

;============================================
; Version: 0.3.0
; Updated: 2017/06/20
;--------------------
; VERSION HISTORY:
;====================
; 0.3.0 | 2017/06/20
;	+Added round.
;
; 0.2.0 | 2017/03/13
;	+Added updateAliasRef.
;
; 0.1.0 | 2017/01/28:
;	+Added debugNotification.
; 	+Added ver3ToString.
;	+Added ver3ToInteger.
;	-Removed StrVer3ToInt.
;	-->	Replaced by ver3ToInteger and ver3ToString.
;
; 0.0.1 | 2017/01/17:
; 	+Added StrVer3ToInt.
;--------------------
; FUNCTIONS:
;	[debugNotification]: Takes a [GlobalVariable] which handles if the debug notifcations are shown and a [String] that displays the notification message.
;	[round]: Takes a [Float] value and rounds it to the nearest whole [Integer].
; 	[updateAliasRef]: Takes the provided [Alias] reference from the specified [Quest] and performs an action on it for each matching reference the alias fills.
;	[ver3ToInteger]: Takes a [String] in the format of Major/Minor/Release versioning ("X", "Y", "Z") (direct or variable) and outputs it into a plain number [Integer].
;	[ver3ToString]: Takes a [String] in the format of Major/Minor/Release versioning ("X", "Y", "Z") (direct or variable) and outputs it into a formatted [String].
;===============

Import Debug
Import Math
Import Utility

; debugNotification:
; ------------------
; Takes the provided GlobalVariable which decides if the provided String
; message is shown as a notification or not. It expects that your global variable is set to
; 1 for debug notifications to be shown. If the variable is 0 then no notifications are shown.
; 
; EXAMPLE USAGE:
; GlobalVariable Property gDebugVariable Auto ; The global variable that handles your debug state.
; debugNotification(gDebugVariable, "This is my debug notification.") ; OUTPUT: This is my debug notification.

Function debugNotification(GlobalVariable gDebugVariable, String sDebugMessage) Global
	If (gDebugVariable.GetValue() == 1)
		Wait(0.1)
		Notification(sDebugMessage)
	EndIf
EndFunction

; ver3ToString:
; -------------
; Takes the provided string input in Major/Minor/Release versioning format, seperated by
; commas ("X", "Y", "Z") and outputs it into a formatted string for displaying purposes.

; EXAMPLE USAGE:
; ver3ToString("1", "2", "3") ; OUTPUT: 1.2.3
; ver3ToString("99", "99", "9") ; OUTPUT: 99.99.9
; LIMIT: "9e9", "99", "9".

String Function ver3ToString(String sMajorVer, String sMinorVer, String sReleaseVer) Global
	String sVersion = sMajorVer + "." + sMinorVer + "." + sReleaseVer
	Return sVersion as String
EndFunction

; ver3ToInteger:
; --------------
; Takes the provided string input in Major/Minor/Release versioning format, seperated by
; commas ("X", "Y", "Z") and outputs it into a plain number integer for calculation purposes.

; EXAMPLE USAGE:
; ver3ToInteger("1", "2", "3") ; OUTPUT: 1203
; ver3ToInteger("99", "99", "9") ; OUTPUT: 99999
; LIMIT: "9e9", "99", "9".

Int Function ver3ToInteger(String sMajorVer, String sMinorVer, String sReleaseVer) Global
	Int iMajorVer = sMajorVer as Int
	Int iMinorVer = sMinorVer as Int
	Int iReleaseVer = sReleaseVer as Int
	Int iVersion = (iMajorVer * 1000) + (iMinorVer * 100) + iReleaseVer
	Return iVersion as Int
EndFunction

; updateAliasRef:
; --------------
; Takes the provided Alias reference from the specified Quest and performs
; an action on it for each matching reference the alias fills.
; Use a GetIsID condition on a parent reference to fill the alias.

; OPTIONS:
;	1 = Delete the found reference and set it to None.
;	2 = Disable the found reference.
;	3 = Enable the found reference. (Use "GetDisabled") with an alias flagged with "Allow Disabled".

; EXAMPLE USAGE:
; updateAliasRef(questName, aliasName, 1) ; Will find all references filled into aliasName on the questName quest and delete them.

Function updateAliasRef(Quest qst, Alias als, Int opt) Global
    qst.Start()
	If qst.IsStarting()
		Wait(0.1)
	EndIf
	ObjectReference ref = (als as ReferenceAlias).GetReference()
    While (ref != None) ; Stop looping once our alias cannot be found.
        ref = (als as ReferenceAlias).GetReference()
        If (ref && opt == 1)
            ref.Delete() ; Destroy the reference.
            ref = None ; Set the reference instance to None to remove its persistence.
        ElseIf (ref && opt == 2)
            ref.Disable() ; Disable the reference.
		ElseIf (ref && opt == 3)
			ref.Enable() ; Enable the disabled reference.
        EndIf
        qst.Stop() ; Stop the quest in the loop.
        qst.Start() ; Start the quest to fill the alias with the first match.
    EndWhile
    qst.Stop() ; Once there are no more matches to fill the alias, we end the quest.
EndFunction

; round:
; -----
; Takes a provided Float value and rounds it to the nearest whole integer.
; This was done as Bethesda seems to not have included a native function.

; EXAMPLE USAGE:
; round(13.49) ; OUTPUT: 13
; round(13.5) ; OUTPUT: 14

Int Function round(Float x) Global
	Int i
	If (x - Floor(x) >= 0.5)
		i = Ceiling(x)
	Else
		i = Floor(x)
	EndIf
	Return i
EndFunction

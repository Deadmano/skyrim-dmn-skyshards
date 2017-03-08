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
; Version: 0.1.0
; Updated: 2017/01/28
;--------------------
; VERSION HISTORY:
;====================
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
;	[ver3ToInteger]: Takes a [String] in the format of Major/Minor/Release versioning ("X", "Y", "Z") (direct or variable) and outputs it into a plain number [Integer].
;	[ver3ToString]: Takes a [String] in the format of Major/Minor/Release versioning ("X", "Y", "Z") (direct or variable) and outputs it into a formatted [String].
;===============

Import Debug
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
; LIMIT: "infinite", "99", "9".

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
; LIMIT: "infinite", "99", "9".

Int Function ver3ToInteger(String sMajorVer, String sMinorVer, String sReleaseVer) Global
	Int iMajorVer = sMajorVer as Int
	Int iMinorVer = sMinorVer as Int
	Int iReleaseVer = sReleaseVer as Int
	Int iVersion = (iMajorVer * 1000) + (iMinorVer * 100) + iReleaseVer
	Return iVersion as Int
EndFunction

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

ScriptName DMN_SkyshardsQuestsWhiterun Extends DMN_SkyshardsQuestManager
{Helper for Whiterun side quest.}

Int Property holdIndex Hidden
; HOLDS:
; --
; 0 - Eastmarch
; 1 - Falkreath
; 2 - Haafingar
; 3 - Hjaalmarch
; 4 - The Pale
; 5 - The Reach
; 6 - The Rift
; 7 - Whiterun
; 8 - Winterhold
; --
	Int Function get()
	; Set this to the index of the specific hold.
		Return 7
	EndFunction
EndProperty
	
Bool isSideQuestUpdated

Bool Property sideQuestStatus Hidden
	Bool Function get()
		Return isSideQuestUpdated
		EndFunction
EndProperty

Event OnInit()
	If (DMN_SQD.updateStatus)
		updateHoldProgress()
	EndIf
EndEvent

Function updateHoldProgress()
	updateSideQuestProgress(holdIndex)
	isSideQuestUpdated = True
EndFunction
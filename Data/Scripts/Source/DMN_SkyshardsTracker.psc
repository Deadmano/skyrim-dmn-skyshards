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

ScriptName DMN_SkyshardsTracker Extends ObjectReference
{Handles the tracking of Skyshards across Skyrim + DLCs/Mods.
Temporary placeholder until the quest system is implemented.
}

Import Game
Import Debug

FormList Property DMN_SkyshardsAbsorbedList Auto

; TO DO: Add option for uninstallation to remove things
; like FormLists when quest system comes out!

Form[] skyshardsEastmarch
Form[] skyshardsFalkreath
Form[] skyshardsHaafingar
Form[] skyshardsMorthal
Form[] skyshardsThePale
Form[] skyshardsTheReach
Form[] skyshardsTheRift
Form[] skyshardsWhiterun
Form[] skyshardsWinterhold

Event OnRead()
	isSkyshardActivated(DMN_SkyshardsAbsorbedList)
EndEvent

Function isSkyshardActivated(FormList Skyshards)
	skyshardsEastmarch = new Form[2]
	skyshardsEastmarch[0] = GetFormFromFile(0x01A7E4, "Skyshards.esp") as Form ; Eastmarch 01
	skyshardsEastmarch[1] = GetFormFromFile(0x01A7E7, "Skyshards.esp") as Form ; Eastmarch 02
	
	skyshardsFalkreath = new Form[2]
	skyshardsFalkreath[0] = GetFormFromFile(0x0197AF, "Skyshards.esp") as Form ; Falkreath 01
	skyshardsFalkreath[1] = GetFormFromFile(0x0197B2, "Skyshards.esp") as Form ; Falkreath 02
	
	skyshardsHaafingar = new Form[1]
	skyshardsHaafingar[0] = GetFormFromFile(0x01A7FC, "Skyshards.esp") as Form ; Haafingar 01
	
	skyshardsMorthal = new Form[3]
	skyshardsMorthal[0] = GetFormFromFile(0x01A7F3, "Skyshards.esp") as Form ; Morthal 01
	skyshardsMorthal[1] = GetFormFromFile(0x01A7F6, "Skyshards.esp") as Form ; Morthal 02
	skyshardsMorthal[2] = GetFormFromFile(0x01A7F9, "Skyshards.esp") as Form ; Morthal 03
	
	skyshardsThePale = new Form[2]
	skyshardsThePale[0] = GetFormFromFile(0x01A7ED, "Skyshards.esp") as Form ; The Pale 01
	skyshardsThePale[1] = GetFormFromFile(0x01A7F0, "Skyshards.esp") as Form ; The Pale 02
	
	skyshardsTheReach = new Form[3]
	skyshardsTheReach[0] = GetFormFromFile(0x01A278, "Skyshards.esp") as Form ; The Reach 01
	skyshardsTheReach[1] = GetFormFromFile(0x01A27B, "Skyshards.esp") as Form ; The Reach 02
	skyshardsTheReach[2] = GetFormFromFile(0x01A27E, "Skyshards.esp") as Form ; The Reach 03
	
	skyshardsTheRift = new Form[3]
	skyshardsTheRift[0] = GetFormFromFile(0x01A801, "Skyshards.esp") as Form ; The Rift 01
	skyshardsTheRift[1] = GetFormFromFile(0x01A804, "Skyshards.esp") as Form ; The Rift 02
	skyshardsTheRift[2] = GetFormFromFile(0x01A807, "Skyshards.esp") as Form ; The Rift 03
	
	skyshardsWhiterun = new Form[4]
	skyshardsWhiterun[0] = GetFormFromFile(0x01979F, "Skyshards.esp") as Form ; Whiterun 01
	skyshardsWhiterun[1] = GetFormFromFile(0x0197A3, "Skyshards.esp") as Form ; Whiterun 02
	skyshardsWhiterun[2] = GetFormFromFile(0x0197A5, "Skyshards.esp") as Form ; Whiterun 03
	skyshardsWhiterun[3] = GetFormFromFile(0x0197A7, "Skyshards.esp") as Form ; Whiterun 04
	
	skyshardsWinterhold = new Form[1]
	skyshardsWinterhold[0] = GetFormFromFile(0x01A7EA, "Skyshards.esp") as Form ; Winterhold 01
	
	findSkyshard(skyshardsEastmarch[0], "Skyshard: Eastmarch 01!")
	findSkyshard(skyshardsEastmarch[1], "Skyshard: Eastmarch 02!")
	
	findSkyshard(skyshardsFalkreath[0], "Skyshard: Falkreath 01!")
	findSkyshard(skyshardsFalkreath[1], "Skyshard: Falkreath 02!")
	
	findSkyshard(skyshardsHaafingar[0], "Skyshard: Haafingar 01!")
	
	findSkyshard(skyshardsMorthal[0], "Skyshard: Morthal 01!")
	findSkyshard(skyshardsMorthal[1], "Skyshard: Morthal 02!")
	findSkyshard(skyshardsMorthal[2], "Skyshard: Morthal 03!")

	findSkyshard(skyshardsThePale[0], "Skyshard: The Pale 01!")
	findSkyshard(skyshardsThePale[1], "Skyshard: The Pale 02!")
	
	findSkyshard(skyshardsTheReach[0], "Skyshard: The Reach 01!")
	findSkyshard(skyshardsTheReach[1], "Skyshard: The Reach 02!")
	findSkyshard(skyshardsTheReach[2], "Skyshard: The Reach 03!")
	
	findSkyshard(skyshardsTheRift[0], "Skyshard: The Rift 01!")
	findSkyshard(skyshardsTheRift[1], "Skyshard: The Rift 02!")
	findSkyshard(skyshardsTheRift[2], "Skyshard: The Rift 03!")
	
	findSkyshard(skyshardsWhiterun[0], "Skyshard: Whiterun 01!")
	findSkyshard(skyshardsWhiterun[1], "Skyshard: Whiterun 02!")
	findSkyshard(skyshardsWhiterun[2], "Skyshard: Whiterun 03!")
	findSkyshard(skyshardsWhiterun[3], "Skyshard: Whiterun 04!")
	
	findSkyshard(skyshardsWinterhold[0], "Skyshard: Winterhold 01!")
EndFunction

Function findSkyshard(Form skyshard, String foundMessage)
	Int skyshardIndex = DMN_SkyshardsAbsorbedList.GetSize()
	While skyshardIndex
		skyshardIndex -= 1

		If DMN_SkyshardsAbsorbedList.GetAt(skyshardIndex) == skyshard
			Trace(foundMessage)
			Notification(foundMessage)
		EndIf
	EndWhile
EndFunction

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

ScriptName DMN_SkyshardsPlayerAlias Extends ReferenceAlias

{Allows the maintenance functions in the Skyshards
Config script to run on each save game load.
}
 
DMN_SkyshardsConfig Property DMN_SC Auto

Event OnPlayerLoadGame()
	DMN_SC.preMaintenance()
	DMN_SC.Maintenance()
EndEvent

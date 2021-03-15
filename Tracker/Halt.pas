{ --- START LICENSE BLOCK ---
BRO-Tracker
Halt routines



(c) Jeroen P. Broks, 1995, 2021

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Please note that some references to data like pictures or audio, do not automatically
fall under this licenses. Mostly this is noted in the respective files.

Version: 21.03.15
--- END LICENSE BLOCK --- }
{****** Halt 1.0 ******}
{For BROTRACKER ONLY NOW}
(*
This source file will be handy to intercept run-time errors.
Read the HALT.DOC file for more information

(C) JBC Soft 1995, Jeroen Broks.
*)

Var OExit:Pointer;

{$F+}
Procedure FatalError;
Var e:Byte;
Begin
ExitProc:=OExit;
{Under this line may be placed eventual own specifications for own purposes}

{Until here}
If ErrorAddr<>nil Then
   Begin
   Color(7,0);
   If NOt(DBG) then ClrScr;
   E:=Exitcode;
   If NOt(DBG) then WriteLn('Fatal error! Probarly caused by a bug in the program');
   Write(E,':');
   Case E Of
        1:WriteLn('Invalid function number');
        2:WriteLn('File not found');
        3:WriteLn('Path not found');
        4:WriteLn('Too many open files');
        5:WriteLn('File access denied');
        6:WriteLn('Invalid file handle');
        12:WriteLn('Invalid file access code');
        15:WriteLn('Invalid drive number');
        16:WriteLn('Cannot remove current directory');
        17:WriteLn('Cannot rename acros drives');
        18:WriteLn('No more files');
        100:WriteLn('Disk read error');
        101:WriteLn('Disk write error');
        102:WriteLn('File not assigned');
        104:WriteLn('File not open for input');
        103:WriteLn('File not open');
        105:WriteLn('File not open for output');
        106:WriteLn('Invalid numeric format');
        150:WriteLn('Disk is write-protected');
        151:WriteLn('Bad drive request struct length');
        152:WriteLn('Drive not ready');
        154:WriteLn('CRC error in data');
        156:WriteLn('Disk seek error');
        157:WriteLn('Media type unknown');
        158:WriteLn('Sector not found');
        159:WriteLn('Out of paper');
        160:WriteLn('Device write fault');
        161:WriteLn('Device read fault');
        162:WriteLn('Hardware failure');
        200:WriteLn('Division by zero');
        201:WriteLn('Range Check Error');
        202:WriteLn('Stack overflow');
        203:WriteLn('Heap overflow');
        204:WriteLn('Invalid pointer operation');
        205:WriteLn('Floating point overflow');
        206:WriteLn('Floating point underflow');
        207:WriteLn('Invalid floating point operation');
        208:WriteLn('Overlay manager not installed');
        209:WriteLn('Overlay file read error');
        210:WriteLn('Object not initialized');
        211:WriteLn('Call to abstract method');
        212:WriteLn('Stream registration error');
        213:WriteLn('Collection index out of range');
        214:WriteLn('Collection overflow');
        215:WriteLn('Arithmetic overflow');
        216:WriteLn('General protection fault');
        Else WriteLn('Unpritable error');
        End;
   If NOt(DBG) then WriteLn('Please contact the author of this program');
   If Not(DBG) Then Halt(E);
   End;
End;
{$F-}

Procedure InitHalt;
Begin
OExit:=ExitProc;
ExitProc:=@FatalError;
End;

Procedure DoneHalt;
Begin
ExitProc:=OExit;
End;
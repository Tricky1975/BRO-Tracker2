{ --- START LICENSE BLOCK ---
Tracker/Muis.pas
Quick Mouse functions
version: 21.03.15
Copyright (C) ????, 2021 Jeroen P. Broks
This software is provided 'as-is', without any express or implied
warranty.  In no event will the authors be held liable for any damages
arising from the use of this software.
Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:
1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software
in a product, an acknowledgment in the product documentation would be
appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
--- END LICENSE BLOCK --- }
UNIT MUIS;

INTERFACE
USES DRIVERS,DOS;
VAR MY,MX:INTEGER;
    MWORK,ML,MR,MD:BOOLEAN;

PROCEDURE INITMUIS;
PROCEDURE DONEMUIS;
PROCEDURE GETMUIS;
PROCEDURE SM;
PROCEDURE HM;
Function MouseInstalled:Boolean;

IMPLEMENTATION

Function MouseInstalled:Boolean;
Var INT33h:Pointer;
Begin
GetIntVec($33,INT33h);
IF (BYTE(INT33h^)=$CF) OR (LONGINT(INT33h)=0) THEN MouseInstalled:=FALSE Else
MouseInstalled:=True;
End;

PROCEDURE INITMUIS;
BEGIN
INITEVENTS;
END;

PROCEDURE DONEMUIS;
BEGIN
DONEEVENTS;
END;

PROCEDURE GETMUIS;
VAR E:TEVENT;
BEGIN
GETMOUSEEVENT(E);
IF E.WHAT<>EVNOTHING THEN
   BEGIN
   MX:=E.WHERE.X;
   MY:=E.WHERE.Y
   END;
ML:=(E.BUTTONS=MBLEFTBUTTON);
MR:=E.BUTTONS=MBRIGHTBUTTON;
MD:=E.DOUBLE;
MWORK:=E.WHAT<>EVNOTHING;
END;


PROCEDURE HM;
BEGIN
HIDEMOUSE;
END;

PROCEDURE SM;
BEGIN
SHOWMOUSE;
END;

BEGIN
INITMUIS;
GETMUIS;
DONEMUIS;
END.
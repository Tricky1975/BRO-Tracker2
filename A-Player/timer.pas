{ --- START LICENSE BLOCK ---
Tracker/Timer.pas
Timer
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
Unit Timer;

Interface
Uses DOS;
Var Debug:Boolean;
Procedure SetTimer(A:Byte);
Procedure InstallWait;
Procedure Wait;

Implementation
Var Hour1,Hour2,Minute1,Minute2,Second2,Second1,Hnd1,Hnd2:Word;
    W:Byte;
    Installed,Setted:Boolean;

Procedure SetTimer(A:Byte);
Begin
W:=A;
If A>98 Then
   Begin
   WriteLn('Setting overflow');
   Halt(3);
   End;
Setted:=True;
End;

Procedure InstallWait;
Begin
If Not(Setted) Then
   Begin
   WriteLn('Timer not set!');
   Halt(2);
   End;
GetTime(Hour1,Minute1,Second1,Hnd1);
Installed:=True;
End;

Procedure Wait;
Var W1,W2:Integer;
Begin
If Not(Installed) Then
   Begin
   WriteLn('Wait not installed');
   Halt(1);
   End;
Repeat
GetTime(Hour2,Minute2,Second2,Hnd2);
W1:=Hnd1;
W2:=Hnd2;
If W2<W1 Then
   Begin
   W2:=W2+100;
   If (Minute1=Minute2) And (Hour1=Hour2) And (Second1=Second2) Then
      Begin
      WriteLn('Clock error');
      Halt;
      End;
   End;
If Debug Then Write(Hour2:2,':',Minute2:2,':',Second2:2,':',Hnd2:2,' Tick ',W2-W1:6,#13);
Until W2-W1>=W;
GetTime(Hour1,Minute1,Second1,Hnd1);
If Debug Then WriteLn;
If Debug Then WriteLn(Hour1,':',Minute1,':',Second1,':',Hnd1,' From now');
End;

Begin
Installed:=False;
Setted:=False;
Debug:=False;
End.
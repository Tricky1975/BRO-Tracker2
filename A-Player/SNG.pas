{ --- START LICENSE BLOCK ---
  SNG.PAS
  
  version: 19.02.09
  Copyright (C) 1995, 2019 Jeroen P. Broks
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
{$O+}
Unit Sng;

Interface
Uses Epu,Crt;

Const BBB=$388;
      ChM:Array[1..9] of Byte = ($00,$01,$02,$08,$09,$0A,$10,$11,$12);
      ChC:Array[1..9] of Byte = ($03,$04,$05,$0B,$0C,$0D,$13,$14,$15);

Var Bt:EpText;
    X:Char;
    Adlib:Boolean;
    Sp,Spd:Byte;
    Playing:Boolean;

Procedure StartMusic(AA:String);
Procedure Track;
Procedure StopSong;

Implementation
Var Pos,Channel,Ak,Al:Longint;

Procedure WriteLn(A:String);
Begin
End;

Procedure Write(A:String);
Begin
End;

procedure SetMixerReg(base : word; index, value : byte);
Var Loze_en_onzinnige_variable_maar_ja_ik_had_hem_nodig,Nog_een:Byte;
begin
  Port[base + 0] := index; {+4}
  For Nog_een:=1 to 6 Do Loze_en_onzinnige_variable_maar_ja_ik_had_hem_nodig:=Port[$388];
  Port[base + 1] := value; {+5}
  For Nog_een:=1 to 35 Do Loze_en_onzinnige_variable_maar_ja_ik_had_hem_nodig:=Port[$388];
end;

Procedure Reg(A,B:Byte);
Begin
If Adlib Then SetMixerReg(BBB,A,B);
End;

Function DetectAdlib:Boolean;
Var Status1,Status2:Byte;
Begin
Adlib:=True;
Reg(4,$60);
Reg(4,$80);
Status1:=Port[$388];
Reg(2,$FF);
Reg(4,$21);
Delay(80);
Status2:=Port[$388];
Reg(4,$60);
Reg(4,$80);
{WriteLn(Hex(Status1),Hex(Status2));}
DetectAdlib:=(Status1=$00) And (Status2=$C0);
If ParamStr(1)='NOADLIB' Then DetectAdlib:=False;
End;

Procedure StartMusic(AA:String);
Begin
For Ak:=1 to $F5 Do Reg(Ak,0);
Spd:=2;
OpenFile(Bt,AA);
Playing:=True;
End;

Procedure Color(A,B:Byte);
Begin
End;

Procedure GOTOXY(A,B:Byte);
Begin
End;

Procedure Track;
Begin
If Not(Playing) then Exit;
For Sp:=1 to Spd*25 Do Delay(2);
For Ak:=1 to 9 Do
    Begin
    Color(10,1);
    ReadChar(Bt,X);
    If EpuError<>0 Then Exit;
    If X=#0 Then
       Begin
       End;
    If X=#1 Then
       Begin
       Color(12,1);
       ReadChar(Bt,X);
       Reg($Af+Ak,$0);
       Reg($9f+ak,Ord(X));
       ReadChar(Bt,X);
       Reg($Af+ak,Ord(X));
       X:=#$FF;
       End;
    If X=#2 Then
       Begin
       ReadChar(Bt,X);
       Color(13,1);
       Spd:=Ord(X);
       X:=#$FF;
       End;
    If X=#4 Then
       Begin
       ReadChar(Bt,X);
       Reg($20+ChC[Ak],Ord(X)); {AM Carrier}
       ReadChar(Bt,X);
       Reg($20+ChM[Ak],Ord(X)); {AM Modulator}
       ReadChar(Bt,X);
       Reg($40+ChC[Ak],Ord(X)); {KSL Carrier}
       ReadChar(Bt,X);
       Reg($40+ChM[Ak],Ord(X)); {KSL Modulator}
       ReadChar(Bt,X);
       Reg($60+ChC[Ak],Ord(X)); {Att Carrier}
       ReadChar(Bt,X);
       Reg($60+ChM[Ak],Ord(X)); {Att Modulator}
       ReadChar(Bt,X);
       Reg($80+ChM[Ak],Ord(X)); {Sus Modulator}
       ReadChar(Bt,X);
       Reg($80+ChC[Ak],Ord(X)); {Sus Carrier}
       ReadChar(Bt,X);
       Reg($BF+Ak,ord(X));       {Feedback}
       ReadChar(Bt,X);
       Reg($E0+ChC[Ak],Ord(X)); {Wav Carrier}
       ReadChar(Bt,X);
       Reg($E0+ChM[Ak],Ord(X)); {Wav Modulator}
       X:=#$FF;
       End;
    If X=#3 Then
       Begin
       StopSong;
       End;
    End;
Pos:=Pos+1;
End;

Procedure StopSong;
Begin
If Playing then CloseFile(Bt);
Playing:=False;
For Ak:=1 to $F5 Do Reg(Ak,0);
End;

Begin
Adlib:=DetectAdlib;
Playing:=False;
End.

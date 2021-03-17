{ --- START LICENSE BLOCK ---
BRO-Tracker 2.0
Main program



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
{$M $8000,0,$8000}
{$UNDEF REGISTERED}
{$UNDEF PACK}

Uses {$IFDEF PACK} Compression, {$ENDIF} Jeroen,Crt,MUIS,DOS,EPU,Timer;

{$I HALT}
Const Nt:Array[1..12] Of String[2] =
                                ('C-','C#','D-','D#','E-','F-',
                                 'F#','G-','G#','A-','A#','B-');
      Fq:Array[1..12] Of Byte = ($AE,$6B,$81,$98,$B0,$CA,$E5,$02,
                                 $20,$41,$63,$87);
      Fo:Array[1..12] Of Byte = ($02,$01,$01,$01,$01,$01,$01,$02,
                                 $02,$02,$02,$02);
      ChM:Array[1..9] of Byte = ($00,$01,$02,$08,$09,$0A,$10,$11,$12);
      ChC:Array[1..9] of Byte = ($03,$04,$05,$0B,$0C,$0D,$13,$14,$15);
      BBB=$388;
      BRT=$222;
      BLT=$220;

{$IFDEF PACK}
{$ELSE}
Type FileOfByte = File Of Byte;
{$ENDIF}
Var Tr:Array[1..9,0..63,1..$31] Of Byte; {NEED}
    Tr2:Array[1..9,0..63,1..$31] Of Byte; {NEED}
    Pat:Array[1..70] Of Byte;           {NEED}
    Ci:Array[1..9] Of Byte;
    Ip,Ipm:Byte;
    ToDo:1..3; {In track is that or --- for Note Or the 0 for formula of 0 for the value}
    Ak,Al:Longint;
    Spd,Rs,Sd,Pce,Oc,Pt,Pc,Ppp,Lg:Byte;            {NEED Pt,Ppp,Rs,Lg,Sd,Spd}
    EqB,Eq:Array[1..9] Of $0..$F;           {NEED For equalizer only}
    X:Char;
    I:Array[1..$7F,1..11] Of Byte;        {NEED!!}
    {Track:Array[0..63,1..20] Of String[38];}
    Tmp:String;                         {NEED 2 bytes}
    Bt:text;                            {NEED}
    Btb:FileOfByte;
    Param,IEdit:Boolean;
    Bst,Song:String;
    Inst:Array[1..$7F] Of String[20];
    Playing,Adlib:Boolean;
    BBBB:Word;
    Box:Array[1..9] Of 1..3;


Function H(A:Char):Byte;
Begin
Case A Of
     '0':H:=$0;
     '1':H:=$1;
     '2':H:=$2;
     '3':H:=$3;
     '4':H:=$4;
     '5':H:=$5;
     '6':H:=$6;
     '7':H:=$7;
     '8':H:=$8;
     '9':H:=$9;
     'A':H:=$A;
     'B':H:=$B;
     'C':H:=$C;
     'D':H:=$D;
     'E':H:=$E;
     'F':H:=$F;
     End;
End;

procedure SetMixerReg(base : word; index, value : byte);
Var Loze_en_onzinnige_variable_maar_ja_ik_had_hem_nodig,Nog_een:Byte;
begin
  Port[base + 0] := index; {+4}
  For Nog_een:=1 to 6 Do Loze_en_onzinnige_variable_maar_ja_ik_had_hem_nodig:=Port[$388];
  Port[base + 1] := value; {+5}
  For Nog_een:=1 to 35 Do Loze_en_onzinnige_variable_maar_ja_ik_had_hem_nodig:=Port[$388];
end;

Procedure Message(AA:String);
Begin
Hm;
Color(15,0); GotoXY(1,25); Delline;
Write(AA);
Sm;
End;

Procedure Reg(A,B:Byte);
Begin
If Adlib Then SetMixerReg(BBBB,A,B);
{If DBG THen Message(JbStr(BBBB));}
End;

Function DetectAdlib:Boolean;
Var Status1,Status2:Byte;
Begin
BBBB:=BBB;
Reg(4,$60);
Reg(4,$80);
Status1:=Port[$388];
Reg(2,$FF);
Reg(4,$21);
Delay(80);
Status2:=Port[$388];
Reg(4,$60);
Reg(4,$80);
DetectAdlib:=(Status1=$00) And (Status2=$C0);
If ParamStr(1)='NOADLIB' Then DetectAdlib:=False;
End;

Procedure UserInput(AA:String; Var BB:String);
Begin
Hm;
BB:='';
Color(15,0); GotoXY(1,25); Delline;
Write(AA); Edit(40,BB); Color(0,0); Delline;
Sm;
End;

Procedure UserEdit(AA:String; Var BB:String);
Begin
Hm;
Color(15,0); GotoXY(1,25); Delline;
Write(AA); Edit(40,BB); Color(0,0); Delline;
Sm;
End;

Procedure ESongName;
Begin
UserEdit('Enter songname:',Song);
End;

Procedure HSCLoad(Tmp:String);
Var An:Byte;
    Count,Size:Longint;
    Bt:EpText;
{Procedure Read(Var T:Text; Var Ch:Char);
Begin
Count:=Count+1;
If Count<=Size Then Read(T,Ch) Else Ch:=#$1A;
End;}

Begin
Song:='HSC '+Name(Tmp);
Inst[1]:='This song';
Inst[2]:='is written in';
Inst[3]:='HSC-Tracker';
Inst[4]:='';
Inst[5]:='';
Inst[6]:='Yet loaded';
Inst[7]:='in BRO-Tracker';
Inst[8]:='2.0';
Inst[9]:='';
Inst[10]:='Written by:';
Inst[11]:='Jeroen P. Broks';
Count:=0;
Size:=FSize(Tmp);
For Ak:=1 to 9 Do Ci[Ak]:=Ak;
If Tmp='' Then Exit;
{Assign(Bt,Tmp);
Reset(Bt);}
OpenFile(Bt,Tmp);
Ppp:=1;
If Bt.Compressed Then Message('Decrunching HSC:'+TMP+'....') Else Message('Loading HSC:'+TMP+'...');
For Ak:=1 to $7F Do
    For Al:=1 to 12 Do
        Begin
        ReadChar(Bt,X);
        If Al<>12 Then I[Ak,Al]:=Ord(X);
        End;
    For Al:=1 to 12 Do
        Begin
        ReadChar(Bt,X);
        End;
An:=0;
For Ak:=0 to $32 Do
    Begin
    ReadChar(Bt,X);
    If X<#$32 Then
    Pat[Ak+1]:=Ord(X)+1;
    If (X=#$FF) And (An=0) Then An:=Ak;
    End;
If An=0 Then An:=32;
Spd:=2;
Lg:=An;
Rs:=1;
For Ak:=1 to $31 Do
    Begin
    {Write('Pattern:',Hex(Ak),#13);}
    For Al:=0 to 63 Do
        Begin
        For An:=1 to 9 Do
            Begin
            {WriteLn(Hex(Ak)+Hex(Al)+Hex(An));}
            ReadChar(Bt,X); Tr[An,Al,Ak]:=Ord(X);
            ReadChar(Bt,X); Tr2[An,Al,Ak]:=Ord(X);
            Case Tr[An,Al,Ak] Of
                 $00:Tr[An,Al,Ak]:=($00);
                 $01:Tr[An,Al,Ak]:=($11);
                 $02:Tr[An,Al,Ak]:=($21);
                 $03:Tr[An,Al,Ak]:=($31);
                 $04:Tr[An,Al,Ak]:=($41);
                 $05:Tr[An,Al,Ak]:=($51);
                 $06:Tr[An,Al,Ak]:=($61);
                 $07:Tr[An,Al,Ak]:=($71);
                 $08:Tr[An,Al,Ak]:=($81);
                 $09:Tr[An,Al,Ak]:=($91);
                 $0A:Tr[An,Al,Ak]:=($A1);
                 $0B:Tr[An,Al,Ak]:=($B1);
                 $0C:Tr[An,Al,Ak]:=($C1);
                 $0D:Tr[An,Al,Ak]:=($12);
                 $0E:Tr[An,Al,Ak]:=($22);
                 $0F:Tr[An,Al,Ak]:=($32);
                 $10:Tr[An,Al,Ak]:=($42);
                 $11:Tr[An,Al,Ak]:=($52);
                 $12:Tr[An,Al,Ak]:=($62);
                 $13:Tr[An,Al,Ak]:=($72);
                 $14:Tr[An,Al,Ak]:=($82);
                 $15:Tr[An,Al,Ak]:=($92);
                 $16:Tr[An,Al,Ak]:=($A2);
                 $17:Tr[An,Al,Ak]:=($B2);
                 $18:Tr[An,Al,Ak]:=($C2);
                 $19:Tr[An,Al,Ak]:=($13);
                 $1A:Tr[An,Al,Ak]:=($23);
                 $1B:Tr[An,Al,Ak]:=($33);
                 $1C:Tr[An,Al,Ak]:=($43);
                 $1D:Tr[An,Al,Ak]:=($53);
                 $1E:Tr[An,Al,Ak]:=($63);
                 $1F:Tr[An,Al,Ak]:=($73);
                 $20:Tr[An,Al,Ak]:=($83);
                 $21:Tr[An,Al,Ak]:=($93);
                 $22:Tr[An,Al,Ak]:=($A3);
                 $23:Tr[An,Al,Ak]:=($B3);
                 $24:Tr[An,Al,Ak]:=($C3);
                 $25:Tr[An,Al,Ak]:=($14);
                 $26:Tr[An,Al,Ak]:=($24);
                 $27:Tr[An,Al,Ak]:=($34);
                 $28:Tr[An,Al,Ak]:=($44);
                 $29:Tr[An,Al,Ak]:=($54);
                 $2A:Tr[An,Al,Ak]:=($64);
                 $2B:Tr[An,Al,Ak]:=($74);
                 $2C:Tr[An,Al,Ak]:=($84);
                 $2D:Tr[An,Al,Ak]:=($94);
                 $2E:Tr[An,Al,Ak]:=($A4);
                 $2F:Tr[An,Al,Ak]:=($B4);
                 $30:Tr[An,Al,Ak]:=($C4);
                 $31:Tr[An,Al,Ak]:=($15);
                 $32:Tr[An,Al,Ak]:=($25);
                 $33:Tr[An,Al,Ak]:=($35);
                 $34:Tr[An,Al,Ak]:=($45);
                 $35:Tr[An,Al,Ak]:=($55);
                 $36:Tr[An,Al,Ak]:=($65);
                 $37:Tr[An,Al,Ak]:=($75);
                 $38:Tr[An,Al,Ak]:=($85);
                 $39:Tr[An,Al,Ak]:=($95);
                 $3A:Tr[An,Al,Ak]:=($A5);
                 $3B:Tr[An,Al,Ak]:=($B5);
                 $3C:Tr[An,Al,Ak]:=($C5);
                 $3D:Tr[An,Al,Ak]:=($16);
                 $3E:Tr[An,Al,Ak]:=($26);
                 $3F:Tr[An,Al,Ak]:=($36);
         $40:Tr[An,Al,Ak]:=($46);
         $41:Tr[An,Al,Ak]:=($56);
         $42:Tr[An,Al,Ak]:=($66);
         $43:Tr[An,Al,Ak]:=($76);
         $44:Tr[An,Al,Ak]:=($86);
         $45:Tr[An,Al,Ak]:=($96);
         $46:Tr[An,Al,Ak]:=($A6);
         $47:Tr[An,Al,Ak]:=($B6);
         $48:Tr[An,Al,Ak]:=($C6);
         $49:Tr[An,Al,Ak]:=($17);
         $4A:Tr[An,Al,Ak]:=($27);
         $4B:Tr[An,Al,Ak]:=($37);
         $4C:Tr[An,Al,Ak]:=($47);
         $4D:Tr[An,Al,Ak]:=($57);
         $4E:Tr[An,Al,Ak]:=($67);
         $4F:Tr[An,Al,Ak]:=($77);
         $50:Tr[An,Al,Ak]:=($87);
         $51:Tr[An,Al,Ak]:=($97);
         $52:Tr[An,Al,Ak]:=($A7);
         $53:Tr[An,Al,Ak]:=($B7);
         $54:Tr[An,Al,Ak]:=($C7);
                 $7F:Tr[An,Al,Ak]:=($D0); {Trm}
                 $80:Begin
                     Tr[An,Al,Ak]:=($D3); {Ins}
                     Tr2[An,Al,Ak]:=Tr2[An,Al,Ak]+1;
                     End;
                 Else
                 Tr[An,Al,Ak]:=($00);
                 End;
            If (Tr2[An,Al,Ak]=($01)) And (Tr[An,Al,Ak]<>($D3)) Then Tr2[An,Al,Ak]:=($D0);
            If Tr2[An,Al,Ak]=$FF Then Tr2[An,Al,Ak]:=$FE;
            IF (Tr2[An,Al,Ak]>($EF)) And (Tr[An,Al,Ak]<>($D3)) And (Tr2[An,Ak,Ak]<$FF) Then
               Begin
               If DBG THen Message('DEBUG: TRANAKAL 2: '+Hex(An)+Hex(Ak)+Hex(Al)+':'+Hex(Tr2[An,Al,Ak]));
               Tr2[An,Al,Ak]:=Tr2[An,Al,Ak]+$1;
               End;
            End;
        Color(7,0);
        End;
    End;
CloseFile(Bt);
Ppp:=1;
Pt:=0;
End;


Function TrackN(A,PP:Integer):String;
Var B:Byte;
    T:String;
Begin
If (A<0) Or (A>63) Then
   Begin
   TrackN:=SS(65,' ');
   Exit;
   End;
T:='';
T:=Hex(A);
For B:=1 to 9 DO
    Begin
    If Tr[B,A,Pp]=0 Then T:=T+' ---' Else
    If (Tr[B,A,Pp]>$10) And (Tr[B,A,Pp]<$D0) Then
       Begin
       T:=T+' ';
       {T:=T+Nt[H2D('0'+COPY(HEX(TR[B,A,Pp]),1,1))];
       T:=T+COPY(HEX(TR[B,A,Pp]),2,1);}
       Tmp:=Hex(Tr[B,A,Pp]);
       If (H(TMP[1])>12) Or (H(TMP[1])<1) Then
          Begin
          Color(7,0);
          ClrScr;
          WriteLn('Error in file');
          If DBG Then
             Begin
             WriteLn(TMP,'  '+HEX(B)+','+HEX(A)+','+HEX(PP));
             End;
          Halt;
          End;
       T:=T+Nt[H(TMP[1])];
       T:=T+TMP[2];
       End Else
    If Tr[B,A,Pp]=$D0 Then T:=T+' Trm' Else
    If Tr[B,A,Pp]=$D1 Then T:=T+' Brk' Else
    If Tr[B,A,Pp]=$D2 Then T:=T+' Bth' Else
    If Tr[B,A,Pp]=$D3 Then T:=T+' Ins' Else
    If Tr[B,A,Pp]=$D4 Then T:=T+' Rgt' Else
    If Tr[B,A,Pp]=$D5 Then T:=T+' Lft' Else
    If Tr[B,A,Pp]>$EF Then
       Begin
       T:=T+' Sp';
       T:=T+COPY(HEX(TR[B,A,Pp]),2,1);
       End Else
    T:=T+' ???';
    T:=T+' '+Hex(Tr2[B,A,Pp]);
    End;
TrackN:=T;
End;

Procedure Update;
Begin
{For AK:=0 to 63 DO For Al:=1 to 20 Do Track[Ak,Al]:=TrackN(Ak,Al);}
End;

Function Pp:Byte;
Begin
If Ppp>70 Then Write(Ppp,'!!!');
If Ppp<$1 Then Write(Ppp,'!!!');
Pp:=Pat[Ppp];
End;


Procedure Pattern;
Var Ak:Byte;
Begin
Hm;
Color(15,1);
For Ak:=1 to 5 Do
    Begin
    GotoXY(2,AK+18); If Ak=3 Then Color(14,4) Else Color(15,1);
    If (Pt-3)+AK<0 Then Write(SS(65,' ')) Else
    Write(TrackN((Pt-3)+Ak,Pp));
    End;
Color(14,2);
GotoXY(55,3); Write(Hex(Lg));
GotoXY(55,4); Write(Hex(Ppp));
GotoXY(55,5); Write(Hex(Pp));
GotoXY(55,6); Write(Hex(Rs));
GotoXY(55,7); Write(Oc);
GotoXY(55,8); Write(Hex(Pt));
GotoXY(55,9); Write(Hex(Pc));
Color(14,5);
For Ak:=1 to 5 Do
    Begin
    GotoXY(71,Ak+18);
    If Ak=3 Then Begin Color(13,5); Write(#8#8,'> ') End Else Color(14,5);
    If ((Ppp-3)+ak>0) And ((Ppp-3)+ak<$46) Then Write(Hex((Ppp-3)+Ak),' -> ',Hex((Pat[(Ppp-3)+Ak]))) Else
    Write('         ');
    End;
Color(11,0);
If ToDo=1 Then
   Begin
   GotoXY((Pc*7)-2,21);
   If Not(Playing) Then Write(Copy(TrackN(Pt,PP),(Pc*7)-3,3));
   End;
If ToDo=2 Then
   Begin
   GotoXY((Pc*7)+2,21);
   If Not(Playing) Then Write(Copy(TrackN(Pt,PP),(Pc*7)+1,1));
   End;
If ToDo=3 Then
   Begin
   GotoXY((Pc*7)+3,21);
   If Not(Playing) Then Write(Copy(TrackN(Pt,PP),(Pc*7)+2,1));
   End;
Sm;
End;

Procedure Teken;
Begin
Hm;
{$IFDEF REGISTERED}
If IEdit Then
   Begin
   Message('Instrument Editor');
   Window(1,2,80,24);
   Color(11,3); ClrScr;
   Window(1,1,80,25);
   GotoXY(5,05); WriteLn('SongName:         ',Song);
   GotoXY(5,06); WriteLn('Instrument number:');
   GotoXY(5,07); WriteLn('Instrument name:');
   GotoXY(5,08); WriteLn('AM/VIB/EG/KSR/Multi Carrier ............ ');
   GotoXY(5,09); WriteLn('AM/VIB/EG/KSR/Multi Modulator .......... ');
   GotoXY(5,10); WriteLn('KSL/Volume Carrier ..................... ');
   GotoXY(5,11); WriteLn('KSL/Volume Modulator ................... ');
   GotoXY(5,12); WriteLn('Attack/Decay Carrier ................... ');
   GotoXY(5,13); WriteLn('Attack/Decay Modulator ................. ');
   GotoXY(5,14); WriteLn('Sustain/Release Carrier ................ ');
   GotoXY(5,15); WriteLn('Sustain/Release Modulator .............. ');
   GotoXY(5,16); WriteLn('Feedback ............................... ');
   GotoXY(5,17); WriteLn('WaveForm Carrier ....................... ');
   GotoXY(5,18); WriteLn('WaveForm Modulator ..................... ');
   Color(12,4);        {         1         2         3         4         5         6         7         8}
                       {12345678901234567890123456789012345678901234567890123456789012345678901234567890}
   GotoXY(1,22); Write('????????????????????????????????????????????????????????????????????????????????');
   GotoXY(1,23); Write('? Jam ? Load Instrument ? Save Instrument ? Next ? Previous ? Go Back          ?');
   GotoXY(1,24); Write('????????????????????????????????????????????????????????????????????????????????');
   Sm;
   Exit;
   End;
{$ENDIF}
GotoXY(1,2);
{WriteLn('????????????????????????????????????????');
WriteLn('?  ?C.1?C.2?C.3?C.4?C.5?C.6?C.7?C.8?C.9?');
WriteLn('????????????????????????????????????????');
For Ak:=1 to 5 Do
WriteLn('?                                      ?');
WriteLn('????????????????????????????????????????');
Write('?'); Color(14,4); Write('                                      ');
Color(15,1); WriteLn('?');
WriteLn('????????????????????????????????????????');
For Ak:=1 to 5 Do
WriteLn('?                                      ?');
WriteLn('????????????????????????????????????????');}
Color(11,3);
WriteLn('ษออออออออออออออออออออออออออออออออออออออป');
WriteLn('บ Songname:                            บ'); For Ak:=4 to 16 Do
WriteLn('บ                                      บ');
WriteLn('ศออออออออออออออออออออออออออออออออออออออผ');
GotoXY(15,3); Write(Song);GotoXY(15,3); Write(Song);
For Ak:=4 to 16 Do
    Begin
    GotoXY(3,Ak); Color(11,3); If Ip=(Ak+Ipm)-4 Then Color(12,4);
    Write(Hex((Ak-4)+Ipm),' - ',Copy(Inst[(Ak-4)+Ipm]+SS(20,' '),1,20));
    Color(14,11); Write('  '); If (AK=6) And (DBG) Then Write(Hex(IP),':',Hex(Ipm));
    End;
Color(15,1);
GotoXY(1,18); Write('ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
For Ak:=1 to 5 Do Begin GotoXY(1,18+Ak);
              Write('บ                                                                 บ');
GotoXY(1,24); Write('ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ'); End;
Color(14,2);
GotoXY(41,2); Write('ษออออออออออออออออออออป');
GotoXY(41,3); Write('บ Length:        + - บ');
GotoXY(41,4); Write('บ Position:      + - บ');
GotoXY(41,5); Write('บ Pattern:       + - บ');
GotoXY(41,6); Write('บ Restart:       + - บ');
GotoXY(41,7); Write('บ Octave:        + - บ');
GotoXY(41,8); Write('บ Track:             บ');
GotoXY(41,9); Write('บ Channel:           บ');
GotoXY(41,10); Write('ศออออออออออออออออออออผ'); Color(12,4);
GotoXY(41,11); Write('ษออออออหอออออออออหอออออออออออออออออออออป');
GotoXY(41,12); Write('บ Play บ Pattern บ Clear Pattern       บ');
GotoXY(41,13); Write('ฬออออออสออออหออออสอหออออออหออออออออออออน');
GotoXY(41,14); Write('บ Clear all บ Save บ Load บ Instrument บ');
GotoXY(41,15); Write('ฬอออออออออออฮออออออสหอออออสออออออออออออน');
GotoXY(41,16); Write('บ DOS Shell บ Print บ Exit             บ');
GotoXY(41,17); Write('ศอออออออออออสอออออออสออออออออออออออออออผ'); Color(11,3);
Color(14,5);
GotoXY(68,18);    Write('ษอออออออออออป'); For Ak:=1 to 5 Do Begin
GotoXY(68,Ak+18); Write('บ           บ'); End;
GotoXY(68,24);    Write('ศอออออออออออผ');
Sm;
Pattern;
End;

Function YES(AA:String):Boolean;
Var AAA:Byte;
Begin
Hm;
{$IFDEF REGISTERED}
Yes:=False;
Message('Click on answer or press "Y" of "Enter" for yes');
AAA:=20;
If Length(AA)>20 Then AAA:=Length(AA)+1;
Color(14,6);
GotoXY(10,10); WriteLn('??',SS(AAA,'?'),'??');
GotoXY(10,11); WriteLn('? ',SS(AAA,' '),' ?');
GotoXY(10,12); WriteLn('? ',SS(AAA,' '),' ?');
GotoXY(10,13); WriteLn('??',SS(AAA,'?'),'??');
GotoXY(12,11); Write(AA,'?');
Color(15,1);
GotoXY(13,12); Write(' Yes ');
GotoXY(23,12); Write(' No ');
Repeat
GetMuis;
Until Not(Ml);
Sm;
Repeat
AAA:=0;
GetMuis;
If (Mr) And (Dbg) Then
   Begin
   Message('X='+JBstr(MX)+' Y='+JbSTR(My));
   End;
If (Mx>11) And (Mx<17) And (My=11) And (Ml) Then
   Begin
   Yes:=True;
   Message('Yes!');
   AAA:=1;
   End;
If (Mx>21) And (Mx<26) And (My=11) And (Ml) Then
   Begin
   Message('No!');
   AAA:=1;
   End;
X:=#255;
If KeyPressed Then
   Begin
   X:=ReadKey;
   AAA:=1;
   Message('No!');
   End;
If (Cap(X)='Y') Or (X=#13) Then
   Begin
   AAA:=1;
   Yes:=True;
   Message('Yes!');
   End;
Until AAA=1;
Teken;
Delay(100);
Message('');
Hm;
{$ELSE}
Color(15,0); GotoXY(1,25); Delline;
Write(AA,' ? (Y/N) ');
Yes:=UpCase(ReadKey)='Y';
Color(0,0);
Delline;
{$ENDIF}
Sm;
End;


Procedure Clear;
Begin
Song:='';
Playing:=False;
Pce:=1;
Ip:=1;
For Al:=1 to $7F Do Inst[Al]:='';
Spd:=2;
Lg:=1;
Rs:=0;
Pt:=0;
Ppp:=1;
Pc:=1;
For Ak:=1 to 9 Do FOr Al:=1 to $31 Do For Oc:=0 to 63 Do Tr[Ak,Oc,Al]:=$00;
For Ak:=1 to 9 Do FOr Al:=1 to $31 Do For Oc:=0 to 63 Do Tr2[Ak,Oc,Al]:=$00;
Oc:=1;
For Ak:=1 to 70 DO Pat[Ak]:=$01;
{For AK:=0 to 63 DO For Al:=1 to 20 Do Track[Ak,Al]:=TrackN(Ak,Al);}
For Ak:=1 to 9 Do For Al:=1 to 10 Do I[Ak,Al]:=0;
End;

Procedure ClearPattern;
Begin
If Yes('Clear Pattern '+Hex(Pp)) Then
   Begin
   For Ak:=0 to 63 Do For Al:=1 to 9 Do
       Begin
       Tr[Al,Ak,Pp]:=$00;
       Tr2[Al,Ak,Pp]:=$00;
       End;
   Pattern;
   End;
End;

Procedure C(A:Byte);
Begin
{WriteLn(A*$10);}
If A=0 Then Tr[Pc,Pt,Pp]:=$00 Else
If A=13 Then Tr[Pc,Pt,Pp]:=$D0 Else
If A=14 Then Tr[Pc,Pt,Pp]:=$D1 Else
If A=16 Then Tr[Pc,Pt,Pp]:=$D5 Else
If A=17 Then Tr[Pc,Pt,Pp]:=$D4 Else
If A=18 Then Tr[Pc,Pt,Pp]:=$D2 Else
If A=19 Then Tr[Pc,Pt,Pp]:=$D3 Else
If A=15 Then Tr[Pc,Pt,Pp]:=$F0+Oc Else
   Begin
    Begin
    Reg($20+ChM[Pc],I[Pc,2]); {AM Modulator}
    Reg($20+ChC[Pc],I[Pc,1]); {AM Carrier}
    Reg($40+ChM[Pc],I[Pc,4]); {KSL Modulator}
    Reg($40+ChC[Pc],I[Pc,3]); {KSL Carrier}
    Reg($60+ChM[Pc],I[Pc,6]); {Att Modulator}
    Reg($60+ChC[Pc],I[Pc,5]); {Att Carrier}
    Reg($80+ChM[Pc],I[Pc,8]); {Sus Modulator}
    Reg($80+ChC[Pc],I[Pc,7]); {Sus Carrier}
    Reg($BF+Pc,I[Pc,9]);       {Feedback}
    Reg($E0+ChM[Pc],I[Pc,11]); {Wav Modulator}
    Reg($E0+ChC[Pc],I[Pc,10]); {Wav Carrier}
    End;
   Tr[Pc,Pt,Pp]:=(A*$10)+Oc;
   Tmp:=Hex(Tr[Pc,Pt,Pp]);
   If Tmp[1]='1' Then Tmp[2]:=Chr(Ord(Tmp[2])-1);
   If Tmp[2]='@' Then Tmp[2]:='9';
   Reg($AF+Pc,$00);
   Reg($9F+Pc,Fq[H(Tmp[1])]);
   Reg($AF+Pc,FO[H(Tmp[1])]+((H(Tmp[2])+3)*$4)+$10);
   End;
{Track[Pt,Pp]:=TrackN(Pt,Pp);}
Pt:=Pt+1;
If Pt=64 Then Pt:=0;
Pattern;
End;

Function Dec2Bin(A:Byte):String;
Var B:Byte;
    C:String;
Begin
C:='';
B:=A;
If B>127 Then Begin C:=C+'1'; B:=B-128 End Else C:=C+'0';
If B>063 Then Begin C:=C+'1'; B:=B-064 End Else C:=C+'0';
If B>031 Then Begin C:=C+'1'; B:=B-032 End Else C:=C+'0';
If B>015 Then Begin C:=C+'1'; B:=B-016 End Else C:=C+'0';
If B>007 Then Begin C:=C+'1'; B:=B-008 End Else C:=C+'0';
If B>003 Then Begin C:=C+'1'; B:=B-004 End Else C:=C+'0';
If B>001 Then Begin C:=C+'1'; B:=B-002 End Else C:=C+'0';
If B>000 Then Begin C:=C+'1'; B:=B-001 End Else C:=C+'0';
Dec2Bin:=C;
End;

Function Bin2Dec(A:String):Byte;
Var B:Byte;
Begin
{If Length(A)<>8 Then Error('Binary length error');}
{For B:=1 to 8 Do
    Begin
    If (A[B]<>'1') And (A[B]<>'0') Then Error('Binary value not binary');
    End;}
B:=0;
If A[1]='1' Then B:=128;
If A[2]='1' Then B:=B+64;
If A[3]='1' Then B:=B+32;
If A[4]='1' Then B:=B+16;
If A[5]='1' Then B:=B+8;
If A[6]='1' Then B:=B+4;
If A[7]='1' Then B:=B+2;
If A[8]='1' Then B:=B+1;
Bin2Dec:=B;
End;

Procedure ModVol(Ch,II:Byte; V:Char);
Var KSL,Val,Vol:Byte;
    Tmp:String;
Begin
Val:=H(V);
Tmp:=Dec2Bin(I[II,4]);
KSL:=Bin2Dec('000000'+Copy(Tmp,1,2));
Vol:=Bin2Dec('00'+Copy(Tmp,3,6));
If ($f-Val<0) Or ($f-Val>$FF) Then
   Begin
   Write(V,' -> ',Val,' -> ',$f-Val);
   End;
{Val:=$F-Val;}
Vol:=63-Vol;
Vol:=Round((VAL/$F)*31);
{Vol:=31-Vol;}
Tmp:='00000000';
Mid(Tmp,1,Copy(Dec2Bin(KSL),7,2));
Mid(Tmp,3,Copy(Dec2Bin(Vol),3,6));
{WriteLn(Tmp);}
{Write(' ',Vol,',');}
Reg($40+
    ChM[Ch],
    Bin2Dec(Tmp));
End;

Procedure CarVol(Ch,II:Byte; V:Char);
Var KSL,Val,Vol:Byte;
    Tmp:String;
Begin
Val:=H(V);
Tmp:=Dec2Bin(I[II,3]);
KSL:=Bin2Dec('000000'+Copy(Tmp,1,2));
Vol:=Bin2Dec('00'+Copy(Tmp,3,6));
{Val:=$F-Val;}
Vol:=64-Vol;
Vol:=Round((Val/$f)*31);
{Vol:=31-Vol;}
Tmp:='00000000';
Mid(Tmp,1,Copy(Dec2Bin(KSL),7,2));
Mid(Tmp,3,Copy(Dec2Bin(Vol),3,6));
{Write(' ',Vol,',');}
Reg($40+ChC[Ch],Bin2Dec(Tmp));
{Message(JbStr(15-(Vol Div 2)));}
If 15-(Vol Div 2)<1 Then EqB[Ch]:=1 Else EqB[Ch]:=15-(Vol Div 2);
End;

Procedure EquaBar(Ch,II:Byte);
Var KSL,Val,Vol:Byte;
    Tmp:String;
Begin
Tmp:=Dec2Bin(I[II,3]);
KSL:=Bin2Dec('000000'+Copy(Tmp,1,2));
Vol:=Bin2Dec('00'+Copy(Tmp,3,6));
EqB[Ch]:=15-(Vol Div 2);
End;

Procedure Play(Whole:Boolean);
Var Brk:Boolean;
    IntTemp:Byte;
    Sdd:Integer;
    Tp1:String;
Begin
BBBB:=BBB;
For Ak:=1 to 9 Do Box[Ak]:=1;
Playing:=True;
For AK:=1 to 9 Do Ci[Ak]:=Ak;
For Ak:=1 to 9 Do EquaBar(Ak,Ci[Ak]);
Color(14,2);
GotoXY(41,9); Write('บ Speed:             บ');
BBBB:=BBB;
For Ak:=1 to $F5 Do Reg(Ak,$00);
BBBB:=BLT;
For Ak:=1 to $F5 Do Reg(Ak,$00);
BBBB:=BRT;
For Ak:=1 to $F5 Do Reg(Ak,$00);
BBBB:=BBB;
For AK:=1 to 9 Do
    Begin
    Reg($20+ChM[ak],I[Ak,2]); {AM Modulator}
    Reg($20+ChC[ak],I[Ak,1]); {AM Carrier}
    Reg($40+ChM[ak],I[Ak,4]); {KSL Modulator}
    Reg($40+ChC[ak],I[Ak,3]); {KSL Carrier}
    Reg($60+ChM[ak],I[Ak,6]); {Att Modulator}
    Reg($60+ChC[ak],I[Ak,5]); {Att Carrier}
    Reg($80+ChM[ak],I[Ak,8]); {Sus Modulator}
    Reg($80+ChC[ak],I[Ak,7]); {Sus Carrier}
    Reg($BF+Ak,I[Ak,9]);       {Feedback}
    Reg($E0+ChM[ak],I[Ak,11]); {Wav Modulator}
    Reg($E0+ChC[ak],I[Ak,10]); {Wav Carrier}
    End;
If Whole Then Message('Playing whole song') Else Message('Playing pattern:'+JbStr(Pp));
Sd:=0;
Ak:=Ppp;
Al:=Pt;
If Whole Then Ppp:=1;
Pt:=0;
For Sd:=1 to 9 Do Eq[Sd]:=0;
InstallWait;
Repeat
Brk:=False;
{For Sdd:=1 to Spd*20 Do
    Begin
    Delay(2);
    {If Spd=$F Then Message(JbStr(Sdd)+':'+JbStr(Spd*20));}{
    End;}
For Sdd:=1 to Spd Do Wait;
For Sd:=1 to 9 Do
    Begin
    Case Box[Sd] Of
         1:BBBB:=BBB;
         2:BBBB:=BLT;
         3:BBBB:=BRT;
         End;
    If Eq[Sd]<>0 Then Eq[Sd]:=Eq[Sd]-1;
    If (Tr[Sd,Pt,Pp]>$00) And (Tr[Sd,Pt,Pp]<$D0) Then Eq[Sd]:=EqB[Sd];
    If (Tr[Sd,Pt,Pp]=$D0) Then Eq[Sd]:=0;
    {Tmp:=Copy(SS(Eq[Sd],'?')+'                 ',1,16);}
    Tmp:=Copy('ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ',1,Eq[Sd])+'                            ';
    GotoXY(63,Sd+1);
    Color(9,0); Write(Hex(Ci[Sd]));
    Case Box[Sd] Of
         1:WRite(' ');
         2:Write(#17);
         3:Write(#16);
         End;
    Color(10,0); Write(Copy(Tmp,1,8));
    Color(14,0); Write(Copy(Tmp,9,4));
    Color(12,0); Write(Copy(Tmp,13,3));
    Tmp:=Hex(Tr[Sd,Pt,Pp])+Hex(Tr2[Sd,Pt,Pp]);
    If Tmp[1]='1' Then Tmp[2]:=Chr(Ord(Tmp[2])-1);
    If Tmp[2]='@' Then Tmp[2]:='9';
    GotoXY(70,1);
    Color(14,4);
    If Dbg Then Write(Spd,'-',Tmp);
    If (Tr[Sd,Pt,Pp]<>$00) ANd (Tr[Sd,Pt,Pp]<$D0) Then
       Begin
       Reg($AF+Sd,$00);
       {Reg($9F+Sd,Fq[H2D('0'+COPY(HEX(TR[Sd,Pt,Pp]),1,1))]);
       Reg($AF+Sd,FO[H2D('0'+COPY(HEX(TR[Sd,Pt,Pp]),1,1))]+(H2D('0'+COPY(HEX(TR[Sd,Pt,Pp]),2,1)))*$10);}
       Reg($9F+Sd,Fq[H(Tmp[1])]);
       Reg($AF+Sd,FO[H(Tmp[1])]+((H(Tmp[2])+3)*$4)+$10);
       End;
    If Tr[Sd,Pt,Pp]=$D0 Then Reg($AF+Sd,$00);
    If Tr[Sd,Pt,Pp]=$D1 Then Brk:=True;
    If Tr[Sd,Pt,Pp]=$D2 Then Box[Sd]:=1;
    If Tr[Sd,Pt,Pp]=$D5 Then Box[Sd]:=2;
    If Tr[Sd,Pt,Pp]=$D4 Then Box[Sd]:=3;
    If Tr2[Sd,Pt,Pp]=$D0 Then Brk:=True;
    If Tmp[3]='A' Then
       Begin
       Tp1:=Hex(I[Ci[Sd],3]);
       Tp1[2]:=Tmp[4];
       CarVol(Sd,Ci[Sd],Tmp[4]);
       {Reg($40+ChC[Sd],H2D(TP1)); {KSL Carrier}
       End;
    If Tmp[3]='B' Then
       Begin
       Tp1:=Hex(I[Ci[Sd],4]);
       Tp1[2]:=Tmp[4];
       ModVol(Sd,Ci[Sd],Tmp[4]);
       {Reg($40+ChM[Sd],H2D(TP1)); {KSL Modulator}
       End;
    If Tmp[3]='C' Then
       Begin
       Tp1:=Hex(I[Ci[Sd],4]);
       CarVol(Sd,Ci[Sd],Tmp[4]);
       End;
    If Tr[Sd,Pt,Pp]>$EF Then Spd:=H(Tmp[2]);
    If Tr2[Sd,Pt,Pp]>$EF Then Spd:=H(Tmp[4]);
    If (Tr[Sd,Pt,Pp]=$D3) And (Tr2[Sd,Pt,Pp]<$72) Then
       Begin
       IntTemp:=Ak;
       Ci[Sd]:=Tr2[Sd,Pt,Pp];
       {Reg($AF+Sd,$00);}
       If DBG Then Message('Change Instrument. Channel:'+Hex(Sd)+' Instrument: '+Hex(Ak)+'.');
       Reg($20+ChM[Sd],I[CI[Sd],2]); {AM Modulator}
       Reg($20+ChC[Sd],I[CI[Sd],1]); {AM Carrier}
       Reg($40+ChM[Sd],I[CI[Sd],4]); {KSL Modulator}
       Reg($40+ChC[Sd],I[CI[Sd],3]); {KSL Carrier}
       Reg($60+ChM[Sd],I[CI[Sd],6]); {Att Modulator}
       Reg($60+ChC[Sd],I[CI[Sd],5]); {Att Carrier}
       Reg($80+ChM[Sd],I[CI[Sd],8]); {Sus Modulator}
       Reg($80+ChC[Sd],I[CI[Sd],7]); {Sus Carrier}
       Reg($BF+Sd,I[Ci[Sd],9]);       {Feedback}
       Reg($E0+ChM[Sd],I[CI[Sd],11]); {Wav Modulator}
       Reg($E0+ChC[Sd],I[CI[Sd],10]); {Wav Carrier}
       EquaBar(Sd,Ci[Sd]);
       Ak:=IntTemp;
       End;
    End;
Pattern; Sd:=0;
Color(14,2);
GotoXY(55,9); Write(Hex(Spd));
Pt:=Pt+1;
If (Pt=64) Or (Brk) Then
   Begin
   Ppp:=Ppp+1;
   Pt:=0;
   End;
If (Ppp>Lg) And (Rs>0) Then Ppp:=Rs;
If KeyPressed Then X:=ReadKey;
Until (Ppp>Lg) Or (X=#27) Or ((Not(Whole)) And (Ppp<>Ak));
X:=' ';
Ppp:=Ak;
Pt:=Al;
Pattern;
For Sd:=1 to 9 Do
    Begin
    Color(0,0);
    GotoXY(63,Sd+1); Write(' ':17);
    End;
Message(''); Color(14,2);
GotoXY(41,9); Write('? Channel:           ?');
Playing:=False;
Pattern;
End;

{$IFDEF REGISTERED}
Procedure FSelect(Var D:String; B:String);
Var C:SearchRec;
    An,Am:Integer;
    Dir:String;
    A:String;
Label Again;
Begin
Again:
GetDir(0,DIR);
A:='';
Message('Scanning directory');
FindFirst('*.*',Directory,C);
For Ak:=1 to 10 Do For Al:=1 to 20 Do Track[Ak,Al]:=SS(14,' ');
Ak:=1; Al:=1;
While (C.Attr<>Directory) And (DOSERROR=0) Do FindNext(C);
While (DosError=0) And (Al<20) Do
      Begin
      Track[Ak,Al]:='\'+C.Name+'                        ';
      Ak:=Ak+1;
      If Ak=11 Then
         Begin
         Ak:=1;
         Al:=Al+1;
         End;
      FindNext(C);
      While (C.Attr<>Directory) And (DOSERROR=0) Do FindNext(C);
      End;
If B='Song' Then FindFirst('*.BRO',Directory,C) Else FindFirst('*.INS',Directory,C);
While (C.Attr=Directory) And (DOSERROR=0) Do FindNext(C);
While (DosError=0) And (Al<20) Do
      Begin
      If DBG Then Message('File:'+C.Name);
      Track[Ak,Al]:=' '+C.Name+SS(70,' ');
{     If B='Song' Then
         Begin
         Assign(Bt,C.Name);
         Reset(Bt);
         For An:=1 to 11695 Do Read(Bt,X);
         Read(Bt,X);
         If X<>#26 Then
            Begin
            Am:=Ord(X);
            For An:=1 to Am Do
                Begin
                Read(Bt,X); Track[Ak,Al,Am+14]:=X;
                End;
            End;
         Close(Bt);
         End;}
      Ak:=Ak+1;
      If Ak=11 Then
         Begin
         Ak:=1;
         Al:=Al+1;
         End;
      FindNext(C);
      While (C.Attr=Directory) And (DOSERROR=0) Do FindNext(C);
      End;
{$I-}
For X:='A' to 'Z' Do
    Begin
    ChDir(X+':');
    If IOResult=0 THen
      Begin
      Track[Ak,Al]:='<'+X+':>   Drive                        ';
      Ak:=Ak+1;
      If Ak=11 Then
         Begin
         Ak:=1;
         Al:=Al+1;
         End;
      End;
    End;
ChDir(Dir);
{$I+}
Color(14,5);        {  12345678.123}
Hm;
GotoXY(10,05); Write('??????????????????????????');
GotoXY(10,06); Write('?               ? Load   ?'); {01}
GotoXY(10,07); Write('?               ??????????'); {02}
GotoXY(10,08); Write('?               ? Jam    ?'); {03}
GotoXY(10,09); Write('?               ??????????'); {04}
GotoXY(10,10); Write('?               ? Next   ?'); {05}
GotoXY(10,11); Write('?               ??????????'); {06}
GotoXY(10,12); Write('?               ? Prev   ?'); {07}
GotoXY(10,13); Write('?               ??????????'); {08}
GotoXY(10,14); Write('?               ? Cancel ?'); {09}
GotoXY(10,15); Write('?               ?        ?'); {10}
GotoXY(10,16); Write('??????????????????????????');
Color(15,5);
GetMuis;
A:='';
While (Ml) Do GetMuis;
Sm;
X:=' '; An:=1; Am:=1;
While (Not(Ml)) And (Not(Mr)) And (X<>#13) And (X<>#27) Do
      Begin
      Hm;
      For Ak:=1 to 10 Do
          Begin
          Color(15,5);
          If An=Ak Then Color(15,0);
          GotoXY(11,Ak+5); Write(Copy(TrackN(Ak,Am],1,13));
          Color(15,5);
          End;
      Sm;
      Message(B+' to load. Page:'+JbStr(Am)+ ' '+TrackN(An,Am]+' '+A);
      GetMuis;
      While Not(KeyPressed) And (Not(Ml)) And (Not(MR)) Do GetMuis;
      If KeyPressed Then X:=ReadKey;
         Begin
         If X='H' Then An:=An-1;
         If X='P' Then An:=An+1;
         If X='I' Then Am:=Am-1;
         If X='Q' Then Am:=Am+1;
         End;
      If (Ml) Then
         Begin
         If (Mx>9) And (Mx<25) And (My>4) And (My<15) Then
            Begin
            An:=My-4;
            Ml:=False;
            If (MD) Then
               Begin
               A:=TrackN(An,Am];
               Ml:=True;
               {If DBG Then
                  Begin
                  Message('Chosen:'+JbStr(An)+':'+JbStr(Am)+', is '+Track[An,Am]);
                  Delay(2000);
                  End;}
               End;
            End;
         If (Mx>25) And (Mx<34) Then
            Begin
            Case My Of
                 5:A:=TrackN(An,Am];
                 7: ; {JAM}
                 9:Begin Am:=Am+1; Ml:=False; End;
                 11:Begin Am:=Am-1; Ml:=False; End;
                 13,14:Message('Cancel');
                 Else Ml:=False; End;
            End;
         End;
      If An=0 Then An:=10;
      If An=11 Then An:=1;
      If Am=0 Then Am:=20;
      If Am=21 Then Am:=1;
      If (Dbg) And (Mr) Then
         Begin
         GotoXY(1,1); Write('X=',MX:2,' Y=',MY:2);
         Mr:=False;
         End;

      End;
If (X=#27) Then A:='';
If (Mr) Then A:='';
If A='' Then Begin Update; Teken; Exit End;
If (X=#13) Then A:=TrackN(An,Am];
Message('');
{If (DBG) THen Message('1/3 = Name is:'+A);
If Dbg Then Delay(2000);}
A:=Copy(A,2,Length(A));
{If (DBG) THen Message('2/3 = Name is:'+A);
If Dbg Then Delay(2000);}
A:=Copy(A,1,Pos(' ',A));
{If (DBG) THen Message('3/3 = Name is:'+A);
If Dbg Then Delay(2000);}
If TrackN(An,Am,1]='\' Then
   Begin
   Message('Change dir '+A);
   Shell('CD '+A);
   Goto Again;
   End;
If TrackN(An,Am,1]='<' Then
   Begin
   ChDir(TrackN(An,Am,2]+':');
   Goto Again;
   End;
Message('');
Update;
Teken;
D:=A;
End;
{$ENDIF}

Procedure LInst;
Begin
{$IFDEF REGISTERED}
FSelect(Tmp,'Instrument');
{$ELSE}
UserInput('Filename for instrument '+HEX(Ip)+': ',TMP);
{$ENDIF}
IF Ext(TMP)='' Then TMP:=TMP+'.INS';
If Not(Exist(TMP)) Then
   Begin
   Message('File not found');
   Exit;
   End;
Assign(Bt,TMP);
Reset(Bt);
For Ak:=1 to 11 Do
    Begin
    Read(Bt,X);
    I[Ip,Ak]:=Ord(X);
    End;
X:=' ';
Inst[Ip]:=Tmp;
Close(Bt);
Teken;
End;

{$IFDEF REGISTERED}
Procedure Instruments;
Const II:Array[1..11] Of 1..11 = (2,1,4,3,6,5,8,7,9,11,10);
Var Pi:Byte;
Begin
Pi:=1;
IEdit:=True;
Teken;
Repeat
GetMuis;
Until (Not(Ml));
X:=#1;
While X<>#24 Do
      Begin
      GetMuis;
      If X<>#255 Then
         Begin
         Hm;
         Color(11,3);
         GotoXY(46,6); Write(Pc);
         GotoXY(46,7); Write(Inst[Pc],'                 ');
         For Ak:=1 to 11 Do
             Begin
             If Pi=Ak Then Color(12,4);
             GotoXY(46,7+Ak); Write(HEX(I[Pc,II[Ak]]));
             Color(11,3);
             End;
         Sm;
         End;
      X:=#255;
      If KeyPressed Then X:=ReadKey;
      If (My=4) And (Ml) Then
         Begin
         UserInput('Enter Songname:',Song);
         Song:=Copy(Song,1,20);
         Teken;
         End;
      If (My=6) And (Ml) Then
         Begin
         UserInput('Name Instrument '+Hex(Pc)+':',Tmp);
         Inst[Pc]:=Tmp;
         End;
      If X=#0 Then
         Begin
         X:=ReadKey;
         If X='I' Then Pc:=Pc-1;
         If X='Q' Then Pc:=Pc+1;
         If X='H' Then Pi:=Pi-1; If Pi=0 Then Pi:=11;
         If X='P' Then Pi:=Pi+1; If Pi=12 Then Pi:=1;
         X:=' ';
         End;
      If (Mr) And (Dbg) Then Message('X='+JBstr(MX)+' Y='+JbSTR(My));
      If (Ml) Then
         Begin
         X:=' ';
         If (My>6) And (My<18) Then Pi:=My-6;
         If (My>6) And (My<18) And (Md) Then X:=#13;
         If (My=22) Then
            Begin
            If (Mx>00) And (Mx<06) Then X:='J';
            If (Mx>06) And (Mx<24) Then X:='L';
            If (Mx>24) And (Mx<42) Then X:='S';
            If (Mx>42) And (Mx<49) Then Pc:=Pc+1;
            If (Mx>49) And (Mx<60) Then Pc:=Pc-1;
            If (Mx>60) And (Mx<79) Then X:=#24;
            End;
         End;
      If X='J' Then
         Begin
         Reg($20+ChM[Pc],I[Pc,2]); {AM Modulator}
         Reg($20+ChC[Pc],I[Pc,1]); {AM Carrier}
         Reg($40+ChM[Pc],I[Pc,4]); {KSL Modulator}
         Reg($40+ChC[Pc],I[Pc,3]); {KSL Carrier}
         Reg($60+ChM[Pc],I[Pc,6]); {Att Modulator}
         Reg($60+ChC[Pc],I[Pc,5]); {Att Carrier}
         Reg($80+ChM[Pc],I[Pc,8]); {Sus Modulator}
         Reg($80+ChC[Pc],I[Pc,7]); {Sus Carrier}
         Reg($BF+Pc,I[Pc,9]);       {Feedback}
         Reg($E0+ChM[Pc],I[Pc,11]); {Wav Modulator}
         Reg($E0+ChC[Pc],I[Pc,10]); {Wav Carrier}
         Tmp:='33';
         Reg($AF+Pc,$00);
         Reg($9F+Pc,Fq[H(Tmp[1])]);
         Reg($AF+Pc,FO[H(Tmp[1])]+((H(Tmp[2])+3)*$4)+$10);
         End;
      If X='L' Then LInst;
      If X='S' Then
         Begin
         UserInput('Instrument to save:',Tmp);
         If Ext(Tmp)='' Then Tmp:=Tmp+'.INS';
         Assign(Bt,Tmp);
         Rewrite(Bt);
         For Ak:=1 to 11 Do
             Begin
             Write(Bt,Chr(I[Pc,Ak]));
             End;
         Close(Bt);
         End;
      If X=#13 Then
         Begin
         UserInput('Enter Value:',TMP);
         I[Pc,II[Pi]]:=H2D(TMP);
         End;
      If Pc=10 Then Pc:=1; If Pc=0 Then Pc:=9;
      If X=#24 Then If Yes('Go back to the track Editor') Then X:=#24 Else X:=#1;
      End;
IEdit:=False;
Window(1,2,80,24);
Color(0,0); ClrScr;
Window(1,1,80,25);
Teken;
X:=' ';
End;
{$ENDIF}

Procedure BROSave(Tmp:String);
Var Ak,Al,An:Longint;
Begin
Assign(Bt,TMP);
Rewrite(Bt);
For Ak:=1 to 9 Do For Al:=1 to 11 Do Write(Bt,Chr(I[Ak,Al]));
Write(Bt,Chr(Lg),Chr(Rs),Chr(Ppp),Chr(Pt),Chr(Pc),Chr(Oc));
For Ak:=1 to 70 Do Write(Bt,Chr(Pat[Ak]));
For Ak:=1 to 9 Do FOr Al:=1 to 20 Do For An:=0 to 63 Do Write(Bt,CHR(Tr[Ak,An,Al]));
{$IFDEF REGISTERED}
Write(Bt,Chr(Length(Song)),Song);
For Ak:=1 to 9 Do Write(Bt,Chr(Length(Inst[Ak])),Inst[Ak]);
{$ENDIF}
Close(Bt);
Message('');
End;


Procedure Save;
Var An:Byte;
    Empty:Boolean;
Begin
Tmp:=Bst;
UserInput('File to save:',TMP);
If TMP='CON' Then Exit;
If TMP='' Then Exit;
IF Ext(TMP)='' Then TMP:=TMP+'.BT2';
If Exist(TMP) Then If Not(Yes('Overwrite existing file')) Then Exit;
Message('Saving:'+CAP(TMP));
Bst:=Cap(TMP);
If Ext(Bst)='.BRO' Then Begin BROSave(Tmp); Exit End;
If Ext(Bst)='.HSC' Then Begin Message('HSC not supported'); Exit End;
Assign(Bt,TMP);
Rewrite(Bt);
Write(Bt,'BRO-Tracker 2.0',#26);
For Ak:=1 to $72 Do For Al:=1 to 11 Do Write(Bt,Chr(I[Ak,Al]));
Write(Bt,Chr(Lg),Chr(Rs),Chr(Ppp),Chr(Pt),Chr(Pc),Chr(Oc));
For Ak:=1 to 70 Do Write(Bt,Chr(Pat[Ak]));
For Ak:=1 to 9 Do FOr Al:=1 to $31 Do
    Begin
    Empty:=True;
    For An:=0 to 63 Do If Tr[Ak,An,Al]<>0 Then Empty:=False;
    If Empty Then Write(Bt,#1) Else Write(Bt,#3);
    For An:=0 to 63 Do If Not(Empty) Then Write(Bt,Chr(Tr[Ak,An,Al]));
    End;
For Ak:=1 to 9 Do FOr Al:=1 to $31 Do
    Begin
    Empty:=True;
    For An:=0 to 63 Do If Tr2[Ak,An,Al]<>0 Then Empty:=False;
    If Empty Then Write(Bt,#1) Else Write(Bt,#3);
    For An:=0 to 63 Do If Not(Empty) Then Write(Bt,Chr(Tr2[Ak,An,Al]));
    End;
Write(Bt,Chr(Length(Song)),Song);
For Ak:=1 to $71 Do Write(Bt,Chr(Length(Inst[Ak])),Inst[Ak]);
Close(Bt);
Message('');
End;

Procedure BROLoad(Tmp:String);
Var Bt:EpText;
    An:Byte;
BEGIN
OpenFile(Bt,Tmp);
Message('Loading BRO:'+CAP(TMP));
If Bt.Compressed Then Message('Decrunching BRO:'+CAP(TMP));
Clear;
For Ak:=1 to 9 Do For Al:=1 to 11 Do
    Begin
    ReadChar(Bt,X);
    I[Ak,Al]:=Ord(X);
    End;
ReadChar(Bt,X); Lg:=Ord(X);
ReadChar(Bt,X); Rs:=Ord(X);
ReadChar(Bt,X); Ppp:=Ord(X);
ReadChar(Bt,X); Pt:=Ord(X);
ReadChar(Bt,X); Pc:=Ord(X);
ReadChar(Bt,X); Oc:=Ord(X);
For Ak:=1 to 70 Do
    Begin
    ReadChar(Bt,X);
    Pat[Ak]:=Ord(X);
    End;
For Ak:=1 to 9 Do FOr Al:=1 to 20 Do For An:=0 to 63 Do
    Begin
    ReadChar(Bt,X);
    Tr[Ak,An,Al]:=Ord(X);
    End;
ReadChar(Bt,X);
If X<>#26 Then
   Begin
   Song:='';
   For Ak:=1 to Ord(X) Do
       Begin
       ReadChar(Bt,X); Song:=Song+X;
       End;
   For Al:=1 to 9 DO
       Begin
       ReadChar(Bt,X); Inst[Al]:='';
       For Ak:=1 to Ord(X) Do
           Begin
           ReadChar(Bt,X); Inst[Al]:=Inst[Al]+X;
           End;
       End;
   End;
Bst:=TMP;
CloseFile(Bt);
Message('Updating memory');
{For AK:=0 to 63 DO For Al:=1 to 20 Do TrackN(Ak,Al):=TrackN(Ak,Al);}
Message(''); X:=' ';
Teken;
End;


Procedure Load;
Var An:Byte;
    Bt:EpText;

Const Header='BRO-Tracker 2.0'+#26;

Begin
If Param Then
   begin
   Param:=False;
   Tmp:=ParamStr(1);
   End Else
   Begin
   {$IFDEF REGISTERED}
   Tmp:='';
   FSelect(TMP,'Song');
   {$ELSE}
   UserInput('File to load:',TMP);
   {$ENDIF}
   End;
If Tmp='' Then Exit;
IF Ext(TMP)='' Then TMP:=TMP+'.BT2';
Message('Searching:'+CAP(TMP));
If Not(Exist(TMP)) Then
   Begin
   Message(#7+'File not found');
   Exit;
   End;
If TMP='CON' Then Exit;
If TMP='' Then Exit;
Message('Loading:'+CAP(TMP));
TMP:=CAP(TMP);
If Ext(TMP)='.HSC' Then
   Begin
   HSCLoad(Tmp);
   Teken;
   Exit;
   End;
If Ext(TMP)='.BRO' Then
   Begin
   BROLoad(Tmp);
   Teken;
   Exit;
   End;
Message('Loading BT2:'+CAP(TMP));
If Bt.Compressed Then Message('Decrunching BT2:'+CAP(TMP));
Clear;
OpenFile(Bt,Tmp);
For Ak:=1 to Length(Header) Do
    Begin
    ReadChar(Bt,X);
    If X<>Copy(Header,Ak,1) Then Begin Message('Not a BT2 file!'); CloseFile(Bt); End;
    End;
For Ak:=1 to $72 Do For Al:=1 to 11 Do
    Begin
    ReadChar(Bt,X);
    I[Ak,Al]:=Ord(X);
    End;
ReadChar(Bt,X); Lg:=Ord(X);
ReadChar(Bt,X); Rs:=Ord(X);
ReadChar(Bt,X); Ppp:=Ord(X);
ReadChar(Bt,X); Pt:=Ord(X);
ReadChar(Bt,X); Pc:=Ord(X);
ReadChar(Bt,X); Oc:=Ord(X);
For Ak:=1 to 70 Do
    Begin
    ReadChar(Bt,X);
    Pat[Ak]:=Ord(X);
    End;
For Ak:=1 to 9 Do FOr Al:=1 to $31 Do
 Begin
 ReadChar(Bt,X);
 If X=#3 Then For An:=0 to 63 Do
    Begin
    ReadChar(Bt,X);
    Tr[Ak,An,Al]:=Ord(X);
    End;
 End;
For Ak:=1 to 9 Do For Al:=1 to $31 Do
 Begin
 ReadChar(Bt,X);
 If X=#3 Then For An:=0 to 63 Do
    Begin
    ReadChar(Bt,X);
    Tr2[Ak,An,Al]:=Ord(X);
    End;
 End;
ReadChar(Bt,X);
If X<>#26 Then
   Begin
   Song:='';
   For Ak:=1 to Ord(X) Do
       Begin
       ReadChar(Bt,X); Song:=Song+X;
       End;
   For Al:=1 to $7F DO
       Begin
       ReadChar(Bt,X); Inst[Al]:='';
       For Ak:=1 to Ord(X) Do
           Begin
           ReadChar(Bt,X); Inst[Al]:=Inst[Al]+X;
           End;
       End;
   End;
Bst:=TMP;
CloseFile(Bt);
Message('Updating memory');
{For AK:=0 to 63 DO For Al:=1 to 20 Do TrackN(Ak,Al):=TrackN(Ak,Al);}
Message(''); X:=' ';
Teken;
End;

Procedure Print;
Var An:Byte;
Begin
If Not(Yes('Print the song')) Then Exit; Tmp:='';
Tmp:=Song;
If CAP(Paramstr(1))='PRINTTEST' Then Assign(Bt,'Print.doc') Else Assign(BT,'PRN');
ReWrite(Bt);
If IOResult<>0 Then
   Begin
   Message('Printer error');
   Exit;
   End;
Message('Printing......  Names and Instruments');
WriteLn(Bt,'A BRO-Tracker module. (C) JBC Soft ',JBN);
WriteLn(Bt);
If Tmp<>'' Then WriteLn(Bt,'***** ',Tmp,' *****');
WriteLn(Bt);
WriteLn(Bt,'** Length: ',Hex(Lg));
WriteLn(Bt);
WriteLn(Bt,'** Restart: ',Hex(Rs));
WriteLn(Bt);
WriteLn(Bt,'** Instruments:');
For Ak:=1 to $70 Do
    Begin
    If (Inst[Ak]<>'') Or
       (I[Ak,1]<>0) Or
       (I[Ak,2]<>0) Or
       (I[Ak,3]<>0) Or
       (I[Ak,4]<>0) Or
       (I[Ak,5]<>0) Or
       (I[Ak,6]<>0) Or
       (I[Ak,7]<>0) Or
       (I[Ak,8]<>0) Or
       (I[Ak,9]<>0) Or
       (I[Ak,10]<>0) Or
       (I[Ak,11]<>0) THen
       Begin
       WriteLn(Bt,'Instrument:',Hex(Ak),' - ',Inst[Ak]);
       WriteLn(Bt,'AM/VIB/EG/KSR/Multi Modulator  ..... ',Hex(I[Ak,2]));
       WriteLn(Bt,'AM/VIB/EG/KSR/Multi Carrier  ....... ',Hex(I[Ak,1]));
       WriteLn(Bt,'KSL/Volume Modulator  .............. ',Hex(I[Ak,4]));
       WriteLn(Bt,'KSL/Vulume Carrier  ................ ',Hex(I[Ak,3]));
       WriteLn(Bt,'Attack/Decay Modulator  ............ ',Hex(I[Ak,6]));
       WriteLn(Bt,'Attack/Decay Carrier  .............. ',Hex(I[Ak,5]));
       WriteLn(Bt,'Sustain/Release Modulator  ......... ',Hex(I[Ak,8]));
       WriteLn(Bt,'Sustain/Release Carrier  ........... ',Hex(I[Ak,7]));
       WriteLn(Bt,'Feedback ........................... ',Hex(I[Ak,9]));
       WriteLn(Bt,'Waveform Modulator  ................ ',Hex(I[Ak,11]));
       WriteLn(Bt,'Waveform Carrier  .................. ',Hex(I[Ak,10]));
       WriteLn(Bt);
       End;
    End;
WriteLn(Bt);
WriteLn(Bt,'** Pattern table');
For Ak:=1 to Lg Do
    Begin
    WriteLn(Bt,Hex(Ak),' -> ',Hex(Pat[Ak]));
    End;
WriteLn(Bt);
WriteLn(Bt,'** Patterns');
For Ak:=1 to $31 Do
    Begin
    An:=0;
    For Al:=1 to Lg Do If Pat[Al]=Ak Then An:=1;
    If An=1 Then
       Begin
       Message('Printing pattern '+Hex(Ak));
       WriteLn(Bt,'Pattern:',Hex(Ak));
       For Al:=0 to 63 Do WriteLn(Bt,TrackN(Al,Ak));
       End;
    End;
WriteLn(Bt);
WriteLn(Bt,'Printed in:');
WriteLn(Bt,'BRO-Tracker 2.0(os) - (C) ',JBN,', 1995, General Public License 3');
Close(Bt);
Message('');
End;

Begin
InitHalt;
Adlib:=True;
Adlib:=DetectAdlib;
ToDo:=1;
If Not(MouseInstalled) Then
   Begin
   WriteLn('I''m absolutly sorry, but I couldn''t detect a mouse.');
   WriteLn('Without a mouse you can''t use this program correctly!');
   Halt;
   End;
If Not(Adlib) Then
   Begin
   WriteLn('WARNING!!!!!!! There''s no adlib (or competible) card');
   WriteLn('detected!!!! You can still load/save and edit the');
   WriteLn('songs but you won''t be able to hear anything of it');
   WriteLn('What to do about this. Go to your local computer store and');
   WriteLn('and buy and Adlib or competible card.');
   WriteLn;
   WriteLn('What did you say? You got Adlib? Then you must contact me');
   WriteLn('Then I know something''s not normal. But I can assure you');
   WriteLn('I used the official Adlib detection routine');
   WriteLn;
   WriteLn('Press any key....');
   X:=ReadKey;
   End;
Color(7,0);
ClrScr;
Color(15,4);
GotoXY(1,1); Write('':80); GotoXY(1,1);
{WriteLn('BRO-Tracker 2.0? - (C) JBC Soft, ',JBN,', 1995, All rights reserved');}
WriteLn('BRO-Tracker 2.0(os) - (C) ',JBN,', 1995, 2021, General Public License 3');
InitMuis;
Message('Please wait....');
Clear;
If Not(Dbg) Then
   Begin
   Param:=True;
   Tmp:=ParamStr(1);
   Load;
   End;
Ipm:=1;
Teken;
SetTimer(3);
Message('Welcome to BRO-Tracker 2.0 open source version');
X:=' ';
While X<>#24 Do
      Begin
      {GotoXy(1,1); Write(keyPressed); Delay(10);}
      If X<>#255 Then
         begin
         GotoXY((Pc*4)+1,11);
         {Color(11,0);
         Write(Copy(TrackN(Pt,Pp),(Pc*4),3));}
         End;
      If KeyPressed Then X:=ReadKey Else X:=#255;
      If X<>#255 Then Message('');
      While (Ml) Do GetMuis;
      GetMuis;
      If (MR) And (Dbg) Then
         Begin
         Hm;
         GotoXY(60,1);
         Color(14,4);
         Write(Mx:2,':',My,' ');
         Sm;
         End;
      If (Ml) Then
         Begin
         If (Mx=57) Then
            Begin
            Case My Of
                 2:Begin
                   If Lg<70 Then Lg:=Lg+1;
                   Pattern;
                   End;
                 3:Begin
                   If Ppp<70 Then Ppp:=Ppp+1;
                   Pattern;
                   End;
                 4:Begin
                   If Pp<$31 Then Pat[Ppp]:=Pp+1;
                   Pattern;
                   End;
                 5:Begin
                   If Rs<70 Then Rs:=Rs+1;
                   Pattern;
                   End;
                 6:X:='+';
                 End;
            End;
         If (Mx=59) Then
            Begin
            Case My Of
                 2:Begin
                   If Lg>1 Then Lg:=Lg-1;
                   Pattern;
                   End;
                 3:Begin
                   If Ppp>1 Then Ppp:=Ppp-1;
                   Pattern;
                   End;
                 4:Begin
                   If Pp>1 Then Pat[Ppp]:=Pp-1;
                   Pattern;
                   End;
                 5:Begin
                   If Rs>0 Then Rs:=Rs-1;
                   Pattern;
                   End;
                 6:X:='-';
                 End;
            End;
         End;
      {$IFDEF REGISTERED}
      If (My=23) And (Ml) Then
         Begin
         UserInput('Enter Songname:',Song);
         Song:=Copy(Song,1,20);
         Teken;
         End;
      If (My<23) And (My>18) And (Ml) Then
         Begin
         Al:=0;
         If (Mx<25) Then Al:=My-18;
         If (Mx<50) And (Mx>25) Then Al:=(My-18)+3;
         If (Mx<75) And (Mx>50) Then Al:=(My-18)+6;
         If Al=0 Then Break;
         Tmp:=Inst[Al];
         UserInput('Name Instrument '+Hex(AL)+':',Tmp);
         Inst[Al]:=Tmp;
         Teken;
         End;
      {$ENDIF}
      {$IFDEF REGISTERED}
      If (Mx>67) And (My=13) And (Ml) Then Instruments;
      If X=#9 Then Instruments;
      {$ELSE}
      If (Mx>67) And (My=13) And (Ml) Then LInst;
      If X=#9 Then LInst;
      {$ENDIF}
      If (Mx>61) And (My=15) And (Ml) Then X:=#24;
      If (Mx>00) And (Mx<03) And (My=02) And (Ml) Then
         Begin
         Tmp:=Hex(Pp);
         UserInput('Pattern number:',Tmp);
         If (H2D(Tmp)>0) And (H2D(Tmp)<21) Then Pat[Ppp]:=H2D(Tmp);
         Pattern;
         End;
      If (Mx>03) And (Mx<39) And (My>01) And (Ml) And (My<16) Then
         Begin
         Tmp:=Inst[(My-3)+Ipm];
         UserInput('Instrument '+Hex((My-3)+Ipm)+' name:',Tmp);
         Inst[(My-3)+Ipm]:=Tmp;
         Teken;
         End;
      If (Mx>52) And (Mx<58) And (My=13) And (Ml) Then Save;
      If (Mx>59) And (Mx<66) And (My=13) And (Ml) Then Load;
      If (Mx>40) And (Mx<47) And (My=11) And (Ml) Then Play(True);
      If (Mx>46) And (Mx<56) And (My=11) And (Ml) Then Play(False);
      If (Mx>52) And (Mx<59) And (My=15) And (Ml) Then Print;
      If (Mx>40) And (Mx<52) And (My=13) And (Ml) Then
          Begin
          If Yes('Clear all! Are you sure') Then Clear;
          Teken;
          End;
      If (Mx>56) And (My=11) And (Ml) THen ClearPattern;
      If (Mx>40) And (Mx<52) And (My=15) And (Ml) Then
         Begin
         Color(7,0);
         ClrScr;
         Color(14,0);
         DoneMuis;
         WriteLn('Type "EXIT" to return to BRO-Tracker');
         Color(7,0);
         Shell('');
         Color(15,4);
         GotoXY(1,1); Write('':80); GotoXY(1,1);
         WriteLn('BRO-Tracker 2.0(os) - (C) ',JBN,', 1995, 2021; General Public License 3');
         InitMuis;
         Teken;
         Message('Welcome back...');
         End;
      If (Mx=0) And (My=0) And (Ml) And (Md) Then X:=#24;
      If (Mx>11) And (My=2) And (Mx<38) And (Ml) Then ESongName;
      IF X=#0 Then
         Begin
         X:=ReadKey;
         If (X='H') And (Pt=0) Then Pt:=64;
         If X='H' Then Begin Pt:=PT-1; End;
         If X='P' Then Begin Pt:=PT+1; End;
         If (X='P') And (Pt=64) Then Begin Pt:=0; End;
         {If (X='K') And (Pc=1) Then Pc:=10;}
         If X='K' Then
            Begin
            If ToDo=1 Then Begin Pc:=Pc-1; ToDo:=3 End Else ToDo:=ToDo-1;
            End;
         If X='M' Then
            Begin
            If ToDo=3 Then Begin Pc:=Pc+1; ToDo:=1 End Else ToDo:=ToDo+1;
            End;
         If (X='K') And (Pc=0) Then Pc:=9;
         If (X='M') And (Pc=10) Then Pc:=1;
         If X='S' Then C(0);
         If (X='I') And (Ppp>1) Then Ppp:=Ppp-1;
         If (X='Q') And (Ppp<70) Then Ppp:=Ppp+1;
         X:=#255;
         Pattern;
         {Color(11,0);
         GotoXY((Pc*4)+1,11);
         Color(11,0);
         Write(Copy(TrackN(Pt,Pp),(Pc*4),3));}
         End;
      If X='[' Then If Ip>1 Then Begin Ip:=Ip-1; Teken End;
      If X=']' Then If Ip<$70 Then Begin Ip:=Ip+1; Teken End;
      While Ip<Ipm Do Begin Ipm:=Ipm-1; Teken; End;
      While Ip>Ipm+12 Do Begin Ipm:=Ipm+1; Teken; End;
      If ToDo=1 Then
         Begin
         If X='z' Then C(1);
         If X='s' Then C(2);
         If X='x' Then C(3);
         If X='d' Then C(4);
         If X='c' Then C(5);
         If X='v' Then C(6);
         If X='g' Then C(7);
         If X='b' Then C(8);
         If X='h' Then C(9);
         If X='n' Then C(10);
         If X='j' Then C(11);
         If X='m' Then C(12);
         If X='t' Then C(13); {Terminate = Trm}
         If X=#2  Then C(14); {Break Pattern = Brk}
         If X=#19  Then C(15); {Speed = Sp%}
         If X='l' Then C(16); {Lft}
         If X='r' Then C(17); {Rgt}
         If X='B' Then C(18); {Bth}
         If X='i' Then C(19); (* Intrument *)
         End;
      If ToDo=2 Then
         Begin
         If ((X>='0') And (X<='9')) Or ((X>='a') And (X<='f')) Then
            Begin
            Tmp:=Hex(Tr2[Pc,Pt,Pp]);
            Tmp[1]:=Upcase(X);
            Tr2[Pc,Pt,Pp]:=H(Tmp[1])*$10+H(Tmp[2]);
            Pattern;
            End;
         End;
      If ToDo=3 Then
         Begin
         If ((X>='0') And (X<='9')) Or ((X>='a') And (X<='f')) Then
            Begin
            Tmp:=Hex(Tr2[Pc,Pt,Pp]);
            Tmp[2]:=UpCase(X);
            Tr2[Pc,Pt,Pp]:=H(Tmp[1])*$10+H(Tmp[2]); Pattern;
            End;
         End;
      If X='P' Then Play(True);
      If X='p' Then Play(False);
      If (X='+') And (Oc<7) Then Begin Oc:=Oc+1; Pattern; End;
      If (X='-') And (Oc>1) Then Begin Oc:=Oc-1; Pattern; End;
      If (X='L') Then Load;
      If (X='S') Then Save;
      If (X='K') And (DBG) Then
         Begin
         UserInput('Copy Pat '+JbStr(Pp)+' Chan '+Jbstr(Pc)+' to Pattern:',Tmp);
         Ak:=JbVal(Tmp);
         UserInput('Copy Pat '+JbStr(Pp)+' Chan '+Jbstr(Pc)+' to Channel:',Tmp);
         Message('Copying....'); Sd:=JbVal(Tmp);
         For Al:=0 to 63 Do
             Begin
             Message('Copying '+hex(Al)+Hex(Sd)+Hex(Ak)+Hex(Pp)+'....');
             Tr[Sd,Al,Ak]:=Tr[Sd,Al,Pp];
             {TrackN(Al,Sd):=TrackN(Al,pp];}
             End;
         Message('Wait....');
         {For AK:=0 to 63 DO For Al:=1 to 20 Do Track[Ak,Al]:=TrackN(Ak,Al);}
         Pattern;
         Message('');
         End;
      {Color(14,4);
      GotoXY(2,11); Write(Track[Pt));}
      If (X=#27) Then For Ak:=1 to $F5 Do Reg(Ak,$00);
      If (X=#24) And (NOT(DBG)) THEN
      If Not(Yes('Quit! Are you sure')) Then X:=#32 Else X:=#24;
      End;
DoneMuis;
Color(7,0);
ClrScr;
WriteLn('Thank you for using BRO-Tracker 2.0 - Open Source Version');
WriteLn('Please help me preserve this program ;-)');
ENd.

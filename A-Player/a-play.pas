Uses AniVGA,Timer,Jeroen,Crt,EPU,SNG;
Type PolyGon = Record
     X,Y:Array[1..30] Of Word;
     H:Byte;
     End;
     Stars = Record
     X,Y:Integer;
     End;
Const Fq:Array[1..12] Of Byte = ($AE,$6B,$81,$98,$B0,$CA,$E5,$02,
                                 $20,$41,$63,$87);
      Fo:Array[1..12] Of Byte = ($02,$01,$01,$01,$01,$01,$01,$02,
                                 $02,$02,$02,$02);
      ChM:Array[1..9] of Byte = ($00,$01,$02,$08,$09,$0A,$10,$11,$12);
      ChC:Array[1..9] of Byte = ($03,$04,$05,$0B,$0C,$0D,$13,$14,$15);
      BBB=$388;
      BRT=$222;
      BLT=$220;
      {BBBB=$388;}
Var PG:Polygon;
    BBBB:Word;
    ST:Array[1..50] Of Stars;
    Ak,Sddd:Longint;
    Adlib,Playing:Boolean;
    X:Char;
    Al:Byte;
    Tr:Array[1..9,0..63,1..20] Of Byte; {NEED}
    Tr2:Array[1..9,0..63,1..20] Of Byte; {NEED}
    Pat:Array[1..70] Of Byte;           {NEED}
    Ci:Array[1..9] Of Byte;
    Spd,Rs,Sd,Pce,Oc,Pt,Pc,Ppp,Lg:Byte;            {NEED Pt,Ppp,Rs,Lg,Sd,Spd}
    I:Array[1..$7F,1..11] Of Byte;        {NEED!!}
    EqB,Eq:Array[1..9] Of $0..$F;           {NEED For equalizer only}
    Statics:Boolean;
    Equalizer,Poly,Star:Boolean;
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

Procedure Reg(A,B:Byte);
Begin
If Adlib Then SetMixerReg(BBBB,A,B);
{If DBG THen Message(JbStr(BBBB));}
End;

Function DetectAdlib:Boolean;
Var Status1,Status2:Byte;
Begin
Adlib:=True;
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
Write(Hex(Status1),Hex(Status2),':');
If ParamStr(1)='NOADLIB' Then DetectAdlib:=False;
{If ParamStr(2)='FORCEADLIB' Then DetectAdlib:=True;}
End;

{Function DetectAdlib:Boolean;
Var Status1,Status2:Byte;
Begin
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
Write(Hex(Status1),Hex(Status2),':');
If ParamStr(1)='NOADLIB' Then DetectAdlib:=False;
If ParamStr(2)='FORCEADLIB' Then DetectAdlib:=True;
End;}

Function Pp:Byte;
Begin
If Ppp>70 Then Write(Ppp,'!!!');
If Ppp<$1 Then Write(Ppp,'!!!');
Pp:=Pat[Ppp];
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

Procedure EquaBar(Ch,II:Byte);
Var KSL,Val,Vol:Byte;
    Tmp:String;
Begin
Tmp:=Dec2Bin(I[II,3]);
KSL:=Bin2Dec('000000'+Copy(Tmp,1,2));
Vol:=Bin2Dec('00'+Copy(Tmp,3,6));
EqB[Ch]:=15-(Vol Div 2);
End;

Procedure ModVol(Ch,II:Byte; V:Char);
Var KSL,Val,Vol:Byte;
    Tmp:String;
Begin
If Not(Adlib) Then Exit;
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
If Not(Adlib) Then Exit;
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

Procedure StartMusic;
Var Ak:Longint;
Begin
Statics:=False;
Sddd:=0;
Spd:=2;
If Not(Adlib) Then Exit;
{For Ak:=1 to 9 Do Box[Ak]:=1;}
Playing:=True;
For AK:=1 to 9 Do Ci[Ak]:=Ak;
Pt:=0;
Ppp:=1;
For Ak:=1 to $F5 Do Reg(Ak,$00);
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
    Equabar(Ak,Ak);
    End;
End;

Procedure Play;
Var Brk:Boolean;
    IntTemp:Byte;
    Sdd:Integer;
    Tp1:String;
    Tmp:String;
    Ak:Longint;

Begin
If Not(Adlib) Then Exit;
Sddd:=Sddd+1; {OutTextXY(1,1,2,JbStr(Sddd)+','+JbStr(Spd));}
If Sddd<Spd Then Exit;
Sddd:=0;
(*
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
    End;*)
If Not(Playing) Then Exit;
Brk:=False;
{For Sdd:=1 to Spd*20 Do
    Begin
    Delay(2);
    {If Spd=$F Then Message(JbStr(Sdd)+':'+JbStr(Spd*20));}{
    End;}
For Sd:=1 to 9 Do
    Begin
    {Case Box[Sd] Of
         1:BBBB:=BBB;
         2:BBBB:=BLT;
         3:BBBB:=BRT;
         End;}
    Tmp:=Hex(Tr[Sd,Pt,Pp])+Hex(Tr2[Sd,Pt,Pp]);
    If Tmp[1]='1' Then Tmp[2]:=Chr(Ord(Tmp[2])-1);
    If Tmp[2]='@' Then Tmp[2]:='9';
    If (Tr[Sd,Pt,Pp]<>$00) ANd (Tr[Sd,Pt,Pp]<$D0) Then
       Begin
       Reg($AF+Sd,$00);
       {Reg($9F+Sd,Fq[H2D('0'+COPY(HEX(TR[Sd,Pt,Pp]),1,1))]);
       Reg($AF+Sd,FO[H2D('0'+COPY(HEX(TR[Sd,Pt,Pp]),1,1))]+(H2D('0'+COPY(HEX(TR[Sd,Pt,Pp]),2,1)))*$10);}
       Reg($9F+Sd,Fq[H(Tmp[1])]);
       Reg($AF+Sd,FO[H(Tmp[1])]+((H(Tmp[2])+3)*$4)+$10);
       Eq[Sd]:=EqB[Sd];
       End;
    If Tr[Sd,Pt,Pp]=$D0 Then Begin Reg($AF+Sd,$00); Eq[Sd]:=0; End;
    If Tr[Sd,Pt,Pp]=$D1 Then Brk:=True;
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
       Ak:=IntTemp;
       EquaBar(Sd,Ci[Sd]);
       End;
    If Eq[Sd]<>0 Then Eq[Sd]:=Eq[Sd]-1;
    End;
Sd:=0;
Pt:=Pt+1;
If (Pt=64) Or (Brk) Then
   Begin
   Ppp:=Ppp+1;
   Pt:=0;
   End;
If (Ppp>Lg) And (Rs>0) Then Ppp:=Rs;
{Until (Ppp>Lg) Or (X=#27) Or ((Not(Whole)) And (Ppp<>Ak));}
If (Ppp>Lg) THen
   Begin
   Playing:=False;
   End;
End;

Procedure GetMusic(Tmp:String);
Var Bt:EpText;
    An,Al:Byte;

Const Header='BRO-Tracker 2.0'+#26;

Begin
OpenFile(Bt,Tmp);
For Ak:=1 to Length(Header) Do
    Begin
    ReadChar(Bt,X);
    If X<>Copy(Header,Ak,1) Then Begin WriteLn('Not a BT2 file!'); CloseFile(Bt);  Halt End;
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
    If Al<21 Then Tr[Ak,An,Al]:=Ord(X);
    End;
 End;
For Ak:=1 to 9 Do For Al:=1 to $31 Do 
 Begin
 ReadChar(Bt,X);
 If X=#3 Then For An:=0 to 63 Do
    Begin
    ReadChar(Bt,X);
    If Al<21 Then Tr2[Ak,An,Al]:=Ord(X);
    End;
 End;
ReadChar(Bt,X);
CloseFile(Bt);
End;

Begin
Poly:=Pos('P',Cap(ParamStr(2)))=0;
Equalizer:=Pos('E',Cap(ParamStr(2)))=0;
Star:=Pos('S',CAP(ParamStr(2)))=0;
If (ParamStr(1)='') Or (Not(Exist(ParamStr(1)))) Then
   Begin
   WRiteLn('BRO-Tracker 2.0 player, 1.0');
   WriteLn('Usage: A-PLAY <file>.BT2');
   Halt;
   End;
   Begin
   Adlib:=DetectAdlib;
   If Not(Adlib) Then
      Begin
      WriteLn('Adlib not detected.');
      Halt;
      End;
   End;
GetMusic(ParamStr(1));
StartMusic;
SetTimer(3);
Randomize;
PG.X[1]:=Random(320);
PG.X[2]:=Random(320);
PG.X[3]:=Random(320);
PG.Y[1]:=Random(200);
PG.Y[2]:=Random(200);
PG.Y[3]:=Random(200);
PG.H:=3;
InitGraph;
GraphTextColor:=10;
GraphTextBackground:=10;
OutTextXY(100,100,3,'Adlib Play 1.0');
OutTextXY(100,108,3,'(C) JBC Soft, '+JBN+',');
OutTextXY(100,116,3,'1995, All rights reserved');
Installwait;
Repeat
Wait;
GetBackGroundFromPage(3);
If Statics Then
   Begin
   GraphTextColor:=Random(50)+1;
   GraphTextBackground:=GraphTextColor;
   OutTextXY(1,000,2,'Length:   '+Hex(Lg));
   OutTextXY(1,008,2,'Position: '+Hex(Ppp));
   OutTextXY(1,016,2,'Pattern:  '+Hex(Pp));
   OutTextXY(1,024,2,'Track:    '+Hex(Pt));
   OutTextXY(1,032,2,'Speed:    '+JbStr(Spd));
   End;
If Poly THen
   Begin
   AniVga.Color:=14;
   For Ak:=1 to PG.H-1 Do BackGroundLine(PG.X[Ak],PG.Y[AK],PG.X[Ak+1],Pg.Y[Ak+1]);
   BackGroundLine(Pg.X[Pg.H],Pg.Y[Pg.h],Pg.X[1],PG.Y[1]);
   For Ak:=1 to PG.H Do With Pg Do
    Begin
    Case Random(4)+1 Of
         1:If X[Ak]<319 THen X[Ak]:=X[Ak]+1;
         2:If Y[Ak]<199 THen Y[Ak]:=Y[Ak]+1;
         3:If X[Ak]>0 THen X[Ak]:=X[Ak]-1;
         4:If Y[Ak]>0 THen Y[Ak]:=Y[Ak]-1;
         End;
    End;
    If (Random(1000)=1) And (Pg.H<>30) Then With Pg DO
       Begin
       Pg.H:=Pg.H+1;
       X[H]:=X[H-1];
       Y[H]:=Y[H-1];
       End;
    End;
Anivga.Color:=15;
If Star Then For Ak:=1 to 50 DO With St[Ak] Do
    Begin
    If (Random(100)=1) And (X=0) Then Begin X:=320; Y:=Random(200); End;
    If X<>0 Then
       Begin
       X:=X-1;
       PagePutPixel(X,Y,15,2);
       End;
    End;
Play;
If Equalizer Then
For Ak:=1 to 9 Do For Al:=1 to 5 Do
    Begin
    AniVga.Color:=10;
    BackGroundLine((Ak*10)+al,199,(Ak*10)+al,199-Eq[Ak]);
    AniVGA.Color:=14;
    If Eq[Ak]>10 Then BackGroundLine((Ak*10)+al,189,(Ak*10)+al,199-Eq[Ak]);
    AniVGA.Color:=12;
    If Eq[Ak]>13 Then BackGroundLine((Ak*10)+al,186,(Ak*10)+al,199-Eq[Ak]);
    End;
Animate;
If Keypressed Then X:=ReadKey;
If X='s' THen Statics:=True;
If X='n' Then Statics:=False;
Until (X=#27) Or (Playing=False);
For Ak:=1 to $F5 Do Reg(Ak,$00);
CloseRoutines;
End.
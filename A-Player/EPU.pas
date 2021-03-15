{ --- START LICENSE BLOCK ---
Tracker/EPU.pas
Easy Pack Unit
version: 21.03.15
Copyright (C) 1995, 2021 Jeroen P. Broks
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
Unit EPU;

{Easy Pack Unit 1.0 - (C) JBC Soft, Jeroen Broks, 1995, All rights reserved}


Interface {What is important for the programmer?}

Uses DOS;    {Required units}

Type EpText = RECORD    {To create the file variable to work with}
     RSize:Longint;     {Will contain the real size of the file}
     FPos:Longint;      {Will contain the current position in the file}
     ReadF:Text;        {To access the files}
     Compressed:Boolean;{Compressed file or not?}
     Character:Char;    {Current Character}
     NumChar:Byte;      {Number of Characters}
     PosChar:Byte;      {Position of Characters}
     End;               {End of the record}

{About the variables shown above. All you got to do is to define}
{A variable of this type and use it in you own program.}
{Of course you may read them in you own programs but NEVER assign}
{something to it yourself. The results can be really shit}

Const EpuErrorMsg:Array[0..6] Of String[10] =(  {Error messages}
{000} 'No error',
{001} 'File not open',          {Trying to read a not open file?}
{002} 'Too many open files',    {Close forgotten or change FILES=}
{003} 'File not found',         {Clear?}
{004} 'File access denied',     {No acces to file}
{005} 'Unkown error',           {Look in SysError value and check the
                                 runtime error table to see what it is}
{006} 'Past file end');
Var EpuError,SysError:Byte;     {Will contain the error number. 0=No error}

Procedure OpenFile(Var Fl:EpText; Name:String); {To open a (compressed) file}
Procedure ReadChar(Var Fl:EpText; Var Ch:Char); {To read a char from the file}
Procedure ReadLine(Var Fl:EpText; Var Ln:String); {To read a line from the file}
Procedure CloseFile(Var Fl:EpText);             {To close the compressed file}
Function EndOfFile(Var Fl:EpText):Boolean;      {Same as EOF}

Implementation {How must I do it?}

Const Header='EP10'+#26;

Procedure FError; {Analyse the error}
Begin
If SysError=2   Then EpuError:=3 Else
If SysError=103 Then EpuError:=1 Else
If SysError=5   Then EpuError:=4 Else
If SysError=4   Then EpuError:=2 Else EpuError:=5;
End;

Procedure GetChar(Var E:EpText; Var Ch:Char); {Get a character}
Begin
SysError:=0;
EpuError:=0;
If EndOfFile(E) Then
   Begin
   EpuError:=6;
   SysError:=100;
   Exit;
   End;
{$I-}
Read(E.ReadF,Ch);
SysError:=IOResult;
{$I+}
FError;
End;

Procedure RError; {Reset error}
Begin
SysError:=0;
EpuError:=0;
End;

FUNCTION FSIZE(AAAA:STRING):LONGINT; {An old procedure of mine to get the size
                                      of a file}
VAR AAA:SEARCHREC;
BEGIN
FINDFIRST(AAAA,Directory,AAA);
FSIZE:=AAA.SIZE;
END;

Procedure OpenFile(Var Fl:EpText; Name:String); {To open a (compressed) file}
Var Tmp:String;   {To store temporary information}
    TmpC:Char;
    TmpI:Integer;

Begin
RError;
With Fl Do
     Begin
     FPos:=0;           {Reset position}
     RSize:=1;          {To fool the EOF checker}
     Character:=#0;     {Reset Character}
     NumChar:=0;        {Reset Number of Characters}
     PosChar:=0;        {Reset Position of Characters}
     {$I-}
     Assign(ReadF,Name);
     Reset(ReadF);      {Open the file}
     SysError:=IOResult;{Are there errors}
     FError;            {Handle the error}
     If SysError<>0 Then Exit; {Errors then get out}
     {$I+}
     Compressed:=True;
     For TmpI:=1 to 5 Do  {Check if the file is compressed}
         Begin
         GetChar(Fl,TmpC);
         If SysError<>0 Then Exit; {Errors then get out}
         If TmpC<>Copy(Header,TmpI,1) Then Compressed:=False;
         End;
     If Not(Compressed) Then
        Begin
        Close(ReadF);
        Assign(ReadF,Name);
        Reset(ReadF);
        RSize:=FSize(Name);
        End;
     Tmp:=''; {Get the real size of the file}
     If Compressed Then
        Begin
        Repeat
        GetChar(Fl,TmpC);
        If SysError<>0 Then Exit; {Errors then get out}
        If TmpC<>#1 Then Tmp:=Tmp+TmpC;
        Until TmpC=#1;
        Val(Tmp,RSize,TmpI);
        End;
     FPos:=FPos+1;
     End;
End;

Procedure ReadChar(Var Fl:EpText; Var Ch:Char); {To read a char from the file}
Var TmpC:Char; {To store needed temp info}
Begin
RError;
With Fl Do
     Begin
     If Compressed Then
        Begin
        If NumChar=PosChar Then {To get a new sequence if needed}
           Begin
           PosChar:=0;
           GetChar(Fl,TmpC); NumChar:=Ord(TmpC);
           GetChar(Fl,Character);
           End;
        PosChar:=PosChar+1;
        Ch:=Character;
        End Else
        Begin
        GetChar(Fl,Ch);
        End;
     FPos:=FPos+1;
     End;
End;

Procedure ReadLine(Var Fl:EpText; Var Ln:String); {To read a line from the file}
Var Eol:Boolean;
    TC:Char;
Begin
Eol:=False;
Ln:='';
If EndOfFile(Fl) Then
   Begin
   SysError:=100;
   EpuError:=6;
   Exit;
   End;
With Fl Do
     Repeat
     ReadChar(Fl,TC);
     If EndOfFile(Fl) Then Eol:=True;
     If TC=#10 Then
        Begin
        ReadChar(Fl,TC);
        Eol:=True;
        End Else
     If TC=#13 Then
        Begin
        ReadChar(Fl,TC);
        Eol:=True;
        End Else Ln:=Ln+Tc;
     Until Eol;
End;

Procedure CloseFile(Var Fl:EpText);             {To close the compressed file}
Begin
RError;
Close(Fl.ReadF);
If SysError<>0 Then Exit;
Fl.FPos:=0;
Fl.RSize:=1;
End;

Function EndOfFile(Var Fl:EpText):Boolean;      {Same as EOF}
Begin
EndOfFile:=Not(Fl.FPos<Fl.RSize);
End;

End.
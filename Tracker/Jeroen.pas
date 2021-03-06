{ --- START LICENSE BLOCK ---
Jeroen P. Broks
Personal routines used by many of my old Pascal programs



(c) Jeroen P. Broks, ????, 2021

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
Unit Jeroen;
INTERFACE
USES CRT,DOS;
TYPE STR7 = STRING[7];
VAR A:STRING;
    SHERR:INTEGER;

PROCEDURE JJENDWIN;
PROCEDURE ENDWIN;
PROCEDURE EGALINES;
PROCEDURE REMKEY;
PROCEDURE FILECOPY(AAA,BBB:STRING);
PROCEDURE BTINP(VAR BTT:TEXT; VAR AAAA:STRING);
PROCEDURE SH(AAA,BBB:STRING);
PROCEDURE FILEMOVE(AAA,BBB:STRING);
PROCEDURE VERW(AAA:STRING; VAR BBB:STRING);
PROCEDURE TITELSCHERM(A:STRING);
PROCEDURE TOETS;
PROCEDURE KLEURNORMAAL;
PROCEDURE INVOER(VAR A:STRING);
PROCEDURE ENDING;
PROCEDURE MID(VAR AAAA:STRING;BBBB:INTEGER;CCCC:STRING);
PROCEDURE MID7(VAR AAAA:STR7;BBBB:INTEGER;CCCC:STRING);
PROCEDURE DOSFOUT(VAR AAA:INTEGER);
PROCEDURE Shell(AAA:STRING);
PROCEDURE DIR(AAA:STRING);
PROCEDURE ENGTOETS;
PROCEDURE COLOR(AAA,BBB:INTEGER);
PROCEDURE EDIT(AAA:INTEGER; VAR BBB:STRING);
Function MouseInstalled:Boolean;
FUNCTION DOSERROR:INTEGER;
FUNCTION TAB(AAA:INTEGER):STRING;
FUNCTION FSIZE(AAAA:STRING):LONGINT;
FUNCTION JBN:STRING;
FUNCTION JBDATE:STRING;
FUNCTION JBTIME:STRING;
FUNCTION HEX(AA:BYTE):STRING;
FUNCTION DBG:BOOLEAN;
FUNCTION JBVAL(AAA:STRING):LONGINT;
FUNCTION JBSTR(AAA:LONGINT):STRING;
FUNCTION DIREXIST(AAAA:STRING):BOOLEAN;
Function EXIST(AAAA:STRING):BOOLEAN;
Function PEXIST(AAAA:STRING):BOOLEAN;
FUNCTION ASC(AAAA:STRING):INTEGER;
FUNCTION ASC2(AAAA:STRING):BYTE;
FUNCTION SS(AAA:LONGINT;BBB:STRING):STRING;
FUNCTION CAP(AAA:STRING):STRING;
FUNCTION UNCAP(AAA:STRING):STRING;
FUNCTION EXT(AAA:PATHSTR):STRING;
FUNCTION NAME(AAA:PATHSTR):STRING;
FUNCTION FDIR(AAA:PATHSTR):STRING;
FUNCTION H2D(AA:STRING):Byte;
ImPLementation

FUNCTION DOSERROR:INTEGER;
BEGIN
DOSERROR:=DOS.DOSERROR;
END;

FUNCTION JBVAL(AAA:STRING):LONGINT;
VAR A:LONGINT;
    B:INTEGER;
BEGIN
VAL(AAA,A,B);
JBVAL:=A;
END;

{FUNCTION H2D(AA:STRING):INTEGER;
BEGIN
H2D:=0;
IF HEX(001)=AA THEN H2D:=001;
IF HEX(002)=AA THEN H2D:=002;
IF HEX(003)=AA THEN H2D:=003;
IF HEX(004)=AA THEN H2D:=004;
IF HEX(005)=AA THEN H2D:=005;
IF HEX(006)=AA THEN H2D:=006;
IF HEX(007)=AA THEN H2D:=007;
IF HEX(008)=AA THEN H2D:=008;
IF HEX(009)=AA THEN H2D:=009;
IF HEX(010)=AA THEN H2D:=010;
IF HEX(011)=AA THEN H2D:=011;
IF HEX(012)=AA THEN H2D:=012;
IF HEX(013)=AA THEN H2D:=013;
IF HEX(014)=AA THEN H2D:=014;
IF HEX(015)=AA THEN H2D:=015;
IF HEX(016)=AA THEN H2D:=016;
IF HEX(017)=AA THEN H2D:=017;
IF HEX(018)=AA THEN H2D:=018;
IF HEX(019)=AA THEN H2D:=019;
IF HEX(020)=AA THEN H2D:=020;
IF HEX(021)=AA THEN H2D:=021;
IF HEX(022)=AA THEN H2D:=022;
IF HEX(023)=AA THEN H2D:=023;
IF HEX(024)=AA THEN H2D:=024;
IF HEX(025)=AA THEN H2D:=025;
IF HEX(026)=AA THEN H2D:=026;
IF HEX(027)=AA THEN H2D:=027;
IF HEX(028)=AA THEN H2D:=028;
IF HEX(029)=AA THEN H2D:=029;
IF HEX(030)=AA THEN H2D:=030;
IF HEX(031)=AA THEN H2D:=031;
IF HEX(032)=AA THEN H2D:=032;
IF HEX(033)=AA THEN H2D:=033;
IF HEX(034)=AA THEN H2D:=034;
IF HEX(035)=AA THEN H2D:=035;
IF HEX(036)=AA THEN H2D:=036;
IF HEX(037)=AA THEN H2D:=037;
IF HEX(038)=AA THEN H2D:=038;
IF HEX(039)=AA THEN H2D:=039;
IF HEX(040)=AA THEN H2D:=040;
IF HEX(041)=AA THEN H2D:=041;
IF HEX(042)=AA THEN H2D:=042;
IF HEX(043)=AA THEN H2D:=043;
IF HEX(044)=AA THEN H2D:=044;
IF HEX(045)=AA THEN H2D:=045;
IF HEX(046)=AA THEN H2D:=046;
IF HEX(047)=AA THEN H2D:=047;
IF HEX(048)=AA THEN H2D:=048;
IF HEX(049)=AA THEN H2D:=049;
IF HEX(050)=AA THEN H2D:=050;
IF HEX(051)=AA THEN H2D:=051;
IF HEX(052)=AA THEN H2D:=052;
IF HEX(053)=AA THEN H2D:=053;
IF HEX(054)=AA THEN H2D:=054;
IF HEX(055)=AA THEN H2D:=055;
IF HEX(056)=AA THEN H2D:=056;
IF HEX(057)=AA THEN H2D:=057;
IF HEX(058)=AA THEN H2D:=058;
IF HEX(059)=AA THEN H2D:=059;
IF HEX(060)=AA THEN H2D:=050;
IF HEX(061)=AA THEN H2D:=061;
IF HEX(062)=AA THEN H2D:=062;
IF HEX(063)=AA THEN H2D:=063;
IF HEX(064)=AA THEN H2D:=064;
IF HEX(065)=AA THEN H2D:=065;
IF HEX(066)=AA THEN H2D:=066;
IF HEX(067)=AA THEN H2D:=067;
IF HEX(068)=AA THEN H2D:=068;
IF HEX(069)=AA THEN H2D:=069;
IF HEX(070)=AA THEN H2D:=070;
IF HEX(071)=AA THEN H2D:=071;
IF HEX(072)=AA THEN H2D:=072;
IF HEX(073)=AA THEN H2D:=073;
IF HEX(074)=AA THEN H2D:=074;
IF HEX(075)=AA THEN H2D:=075;
IF HEX(076)=AA THEN H2D:=076;
IF HEX(077)=AA THEN H2D:=077;
IF HEX(078)=AA THEN H2D:=078;
IF HEX(079)=AA THEN H2D:=079;
IF HEX(080)=AA THEN H2D:=080;
IF HEX(081)=AA THEN H2D:=081;
IF HEX(082)=AA THEN H2D:=082;
IF HEX(083)=AA THEN H2D:=083;
IF HEX(084)=AA THEN H2D:=084;
IF HEX(085)=AA THEN H2D:=085;
IF HEX(086)=AA THEN H2D:=086;
IF HEX(087)=AA THEN H2D:=087;
IF HEX(088)=AA THEN H2D:=088;
IF HEX(089)=AA THEN H2D:=089;
IF HEX(090)=AA THEN H2D:=090;
IF HEX(091)=AA THEN H2D:=091;
IF HEX(092)=AA THEN H2D:=092;
IF HEX(093)=AA THEN H2D:=093;
IF HEX(094)=AA THEN H2D:=094;
IF HEX(095)=AA THEN H2D:=095;
IF HEX(096)=AA THEN H2D:=096;
IF HEX(097)=AA THEN H2D:=097;
IF HEX(098)=AA THEN H2D:=098;
IF HEX(099)=AA THEN H2D:=099;
IF HEX(100)=AA THEN H2D:=100;
IF HEX(101)=AA THEN H2D:=101;
IF HEX(102)=AA THEN H2D:=102;
IF HEX(103)=AA THEN H2D:=103;
IF HEX(104)=AA THEN H2D:=104;
IF HEX(105)=AA THEN H2D:=105;
IF HEX(106)=AA THEN H2D:=106;
IF HEX(107)=AA THEN H2D:=107;
IF HEX(108)=AA THEN H2D:=108;
IF HEX(109)=AA THEN H2D:=109;
IF HEX(110)=AA THEN H2D:=110;
IF HEX(111)=AA THEN H2D:=111;
IF HEX(112)=AA THEN H2D:=112;
IF HEX(113)=AA THEN H2D:=113;
IF HEX(114)=AA THEN H2D:=114;
IF HEX(115)=AA THEN H2D:=115;
IF HEX(116)=AA THEN H2D:=116;
IF HEX(117)=AA THEN H2D:=117;
IF HEX(118)=AA THEN H2D:=118;
IF HEX(119)=AA THEN H2D:=119;
IF HEX(120)=AA THEN H2D:=120;
IF HEX(121)=AA THEN H2D:=121;
IF HEX(122)=AA THEN H2D:=122;
IF HEX(123)=AA THEN H2D:=123;
IF HEX(124)=AA THEN H2D:=124;
IF HEX(125)=AA THEN H2D:=125;
IF HEX(126)=AA THEN H2D:=126;
IF HEX(127)=AA THEN H2D:=127;
IF HEX(128)=AA THEN H2D:=128;
IF HEX(129)=AA THEN H2D:=129;
IF HEX(130)=AA THEN H2D:=130;
IF HEX(131)=AA THEN H2D:=131;
IF HEX(132)=AA THEN H2D:=132;
IF HEX(133)=AA THEN H2D:=133;
IF HEX(134)=AA THEN H2D:=134;
IF HEX(135)=AA THEN H2D:=135;
IF HEX(136)=AA THEN H2D:=136;
IF HEX(137)=AA THEN H2D:=137;
IF HEX(138)=AA THEN H2D:=138;
IF HEX(139)=AA THEN H2D:=139;
IF HEX(140)=AA THEN H2D:=140;
IF HEX(141)=AA THEN H2D:=141;
IF HEX(142)=AA THEN H2D:=142;
IF HEX(143)=AA THEN H2D:=143;
IF HEX(144)=AA THEN H2D:=144;
IF HEX(145)=AA THEN H2D:=145;
IF HEX(146)=AA THEN H2D:=146;
IF HEX(147)=AA THEN H2D:=147;
IF HEX(148)=AA THEN H2D:=148;
IF HEX(149)=AA THEN H2D:=149;
IF HEX(150)=AA THEN H2D:=150;
IF HEX(151)=AA THEN H2D:=151;
IF HEX(152)=AA THEN H2D:=152;
IF HEX(153)=AA THEN H2D:=153;
IF HEX(154)=AA THEN H2D:=154;
IF HEX(155)=AA THEN H2D:=155;
IF HEX(156)=AA THEN H2D:=156;
IF HEX(157)=AA THEN H2D:=157;
IF HEX(158)=AA THEN H2D:=158;
IF HEX(159)=AA THEN H2D:=159;
IF HEX(160)=AA THEN H2D:=150;
IF HEX(161)=AA THEN H2D:=161;
IF HEX(162)=AA THEN H2D:=162;
IF HEX(163)=AA THEN H2D:=163;
IF HEX(164)=AA THEN H2D:=164;
IF HEX(165)=AA THEN H2D:=165;
IF HEX(166)=AA THEN H2D:=166;
IF HEX(167)=AA THEN H2D:=167;
IF HEX(168)=AA THEN H2D:=168;
IF HEX(169)=AA THEN H2D:=169;
IF HEX(170)=AA THEN H2D:=170;
IF HEX(171)=AA THEN H2D:=171;
IF HEX(172)=AA THEN H2D:=172;
IF HEX(173)=AA THEN H2D:=173;
IF HEX(174)=AA THEN H2D:=174;
IF HEX(175)=AA THEN H2D:=175;
IF HEX(176)=AA THEN H2D:=176;
IF HEX(177)=AA THEN H2D:=177;
IF HEX(178)=AA THEN H2D:=178;
IF HEX(179)=AA THEN H2D:=179;
IF HEX(180)=AA THEN H2D:=180;
IF HEX(181)=AA THEN H2D:=181;
IF HEX(182)=AA THEN H2D:=182;
IF HEX(183)=AA THEN H2D:=183;
IF HEX(184)=AA THEN H2D:=184;
IF HEX(185)=AA THEN H2D:=185;
IF HEX(186)=AA THEN H2D:=186;
IF HEX(187)=AA THEN H2D:=187;
IF HEX(188)=AA THEN H2D:=188;
IF HEX(189)=AA THEN H2D:=189;
IF HEX(190)=AA THEN H2D:=190;
IF HEX(191)=AA THEN H2D:=191;
IF HEX(192)=AA THEN H2D:=192;
IF HEX(193)=AA THEN H2D:=193;
IF HEX(194)=AA THEN H2D:=194;
IF HEX(195)=AA THEN H2D:=195;
IF HEX(196)=AA THEN H2D:=196;
IF HEX(197)=AA THEN H2D:=197;
IF HEX(198)=AA THEN H2D:=198;
IF HEX(199)=AA THEN H2D:=199;
IF HEX(200)=AA THEN H2D:=200;
IF HEX(200)=AA THEN H2D:=200;
IF HEX(201)=AA THEN H2D:=201;
IF HEX(202)=AA THEN H2D:=202;
IF HEX(203)=AA THEN H2D:=203;
IF HEX(204)=AA THEN H2D:=204;
IF HEX(205)=AA THEN H2D:=205;
IF HEX(206)=AA THEN H2D:=206;
IF HEX(207)=AA THEN H2D:=207;
IF HEX(208)=AA THEN H2D:=208;
IF HEX(209)=AA THEN H2D:=209;
IF HEX(210)=AA THEN H2D:=210;
IF HEX(211)=AA THEN H2D:=211;
IF HEX(212)=AA THEN H2D:=212;
IF HEX(213)=AA THEN H2D:=213;
IF HEX(214)=AA THEN H2D:=214;
IF HEX(215)=AA THEN H2D:=215;
IF HEX(216)=AA THEN H2D:=216;
IF HEX(217)=AA THEN H2D:=217;
IF HEX(218)=AA THEN H2D:=218;
IF HEX(219)=AA THEN H2D:=219;
IF HEX(220)=AA THEN H2D:=220;
IF HEX(221)=AA THEN H2D:=221;
IF HEX(222)=AA THEN H2D:=222;
IF HEX(223)=AA THEN H2D:=223;
IF HEX(224)=AA THEN H2D:=224;
IF HEX(225)=AA THEN H2D:=225;
IF HEX(226)=AA THEN H2D:=226;
IF HEX(227)=AA THEN H2D:=227;
IF HEX(228)=AA THEN H2D:=228;
IF HEX(229)=AA THEN H2D:=229;
IF HEX(230)=AA THEN H2D:=230;
IF HEX(231)=AA THEN H2D:=231;
IF HEX(232)=AA THEN H2D:=232;
IF HEX(233)=AA THEN H2D:=233;
IF HEX(234)=AA THEN H2D:=234;
IF HEX(235)=AA THEN H2D:=235;
IF HEX(236)=AA THEN H2D:=236;
IF HEX(237)=AA THEN H2D:=237;
IF HEX(238)=AA THEN H2D:=238;
IF HEX(239)=AA THEN H2D:=239;
IF HEX(240)=AA THEN H2D:=240;
IF HEX(241)=AA THEN H2D:=241;
IF HEX(242)=AA THEN H2D:=242;
IF HEX(243)=AA THEN H2D:=243;
IF HEX(244)=AA THEN H2D:=244;
IF HEX(245)=AA THEN H2D:=245;
IF HEX(246)=AA THEN H2D:=246;
IF HEX(247)=AA THEN H2D:=247;
IF HEX(248)=AA THEN H2D:=248;
IF HEX(249)=AA THEN H2D:=249;
IF HEX(250)=AA THEN H2D:=250;
IF HEX(251)=AA THEN H2D:=251;
IF HEX(252)=AA THEN H2D:=252;
IF HEX(253)=AA THEN H2D:=253;
IF HEX(254)=AA THEN H2D:=254;
IF HEX(255)=AA THEN H2D:=255;
END;}

Function H2D(AA:String):Byte;
Var T:Byte;
Begin
Case AA[1] Of
     '0':T:=$0*16;
     '1':T:=$1*16;
     '2':T:=$2*16;
     '3':T:=$3*16;
     '4':T:=$4*16 ;
     '5':T:=$5*16;
     '6':T:=$6*16  ;
     '7':T:=$7*16;
     '8':T:=$8*16   ;
     '9':T:=$9*16;
     'A':T:=$A*16    ;
     'B':T:=$B*16;
     'C':T:=$C*16     ;
     'D':T:=$D*16;
     'E':T:=$E*16      ;
     'F':T:=$F*16;
     End;
Case AA[2] Of
     '0':T:=T+$0;
     '1':T:=T+$1;
     '2':T:=T+$2;
     '3':T:=T+$3;
     '4':T:=T+$4 ;
     '5':T:=T+$5;
     '6':T:=T+$6  ;
     '7':T:=T+$7;
     '8':T:=T+$8   ;
     '9':T:=T+$9;
     'A':T:=T+$A    ;
     'B':T:=T+$B;
     'C':T:=T+$C     ;
     'D':T:=T+$D;
     'E':T:=T+$E      ;
     'F':T:=T+$F;
     End;
H2D:=T;
End;

PROCEDURE REMKEY;
VAR XXXX:CHAR;
BEGIN
WHILE KEYPRESSED DO XXXX:=READKEY;
END;

PROCEDURE TITELSCHERM(A:STRING);
BEGIN
TEXTBACKGROUND(0); TEXTCOLOR(7);
CLRSCR;
WRITELN('   ???????????????');
WRITELN('    ?????????????       ???????????????????????');
WRITELN('    ?   ???   ???       ???????????????????????');
WRITELN('    ?   ???   ???       ???????????????????????');
WRITELN(' ???????????????????        ?????');
WRITELN(' ?  .   ?????      ?   ???????');
WRITELN(' ?      ?????      ?  ??');
WRITELN(' ?  ??         ??  ?');
WRITELN(' ?    ?????????    ?');
WRITELN('  ?????????????????');
GOTOXY(27,3); TEXTCOLOR(0); TEXTBACKGROUND(7); WRITE('Jeroen Broks'); DELAY(900);
GOTOXY(27,3); WRITE('PRESENTEERT:   '); DELAY(900);
GOTOXY(27,3); WRITE('               '); GOTOXY(27,3); WRITE(A); DELAY(900);
TEXTCOLOR(7); TEXTBACKGROUND(0); CLRSCR;
END;

Function PEXIST(AAAA:STRING):BOOLEAN;
VAR A:PATHSTR;
BEGIN
A:=FSEARCH(AAAA,GETENV('PATH'));
PEXIST:=A<>''
END;

FUNCTION JBSTR(AAA:LONGINT):STRING;
VAR EEE:STRING;
BEGIN
STR(AAA,EEE);
JBSTR:=EEE;
END;

FUNCTION DIREXIST(AAAA:STRING):BOOLEAN;
VAR DDD:BOOLEAN;
    EEE:SEARCHREC;
BEGIN
FINDFIRST('*.*',DIRECTORY,EEE);
WHILE (DOSERROR<>0) AND (EEE.ATTR<>DIRECTORY) DO FINDNEXT(EEE);
DDD:=(DOSERROR=0);
DIREXIST:=DDD;
END;

FUNCTION TAB(AAA:INTEGER):STRING;
BEGIN
TAB:=SS(AAA-WHEREX,' ');
END;

PROCEDURE ENDWIN;
VAR AK,AL:INTEGER;
BEGIN
COLOR(7,0);
CLRSCR;
COLOR(14,1);
FOR AK:=1 to 24 DO
    BEGIN
    GOTOXY(1,AK);
    FOR AL:=1 to 9 DO
        BEGIN
        WRITE('JBC Soft ');
        END;
    END;
COLOR(0,7);
WINDOW(5,3,76,22);
CLRSCR;
WINDOW(1,1,80,25); COLOR(6,0);
FOR AK:=4 to 23 DO BEGIN GOTOXY(77,AK); WRITE('So'); END;
GOTOXY(7,23); WRITE('ft JBC Soft JBC Soft JBC Soft JBC Soft JBC Soft JBC Soft JBC Soft JBC ');
WINDOW(5,3,76,22);
GOTOXY(1,1); COLOR(0,7);
END;

PROCEDURE JJENDWIN;
VAR AK,AL:INTEGER;
BEGIN
COLOR(7,0);
CLRSCR;
COLOR(14,1);
FOR AK:=1 to 24 DO
    BEGIN
    GOTOXY(1,AK);
    FOR AL:=1 to 9 DO
        BEGIN
        WRITE('J&J Soft ');
        END;
    END;
COLOR(0,7);
WINDOW(5,3,76,22);
CLRSCR;
WINDOW(1,1,80,25); COLOR(6,0);
FOR AK:=4 to 23 DO BEGIN GOTOXY(77,AK); WRITE('So'); END;
GOTOXY(7,23); WRITE('ft J&J Soft J&J Soft J&J Soft J&J Soft J&J Soft J&J Soft J&J Soft J&J ');
WINDOW(5,3,76,22);
GOTOXY(1,1); COLOR(0,7);
END;

PROCEDURE ENDING;
BEGIN
WINDOW(1,1,80,25);
GOTOXY(1,25); COLOR(7,0); WRITE(' '); GOTOXY(1,24);
If ParamStr(0)='C:\TP\BIN\TURBO.EXE' Then WriteLn;
HALT;
END;

PROCEDURE TOETS;
VAR TOETSIIIIIIIII:CHAR;
    AKKKKKK:INTEGER;
BEGIN
WRITE('Druk op een toets. . .');
TOETSIIIIIIIII:=READKEY;
While Keypressed Do ReadKey;
FOR AKKKKKK:=1 TO 22 DO WRITE(CHR(8),' ',CHR(8));
END;

PROCEDURE ENGTOETS;
VAR TOETSIIIIIIIII:CHAR;
    AKKKKKK:INTEGER;
BEGIN
WRITE('Press any key. . .');
TOETSIIIIIIIII:=READKEY;
FOR AKKKKKK:=1 TO 22 DO WRITE(CHR(8),' ',CHR(8));
END;

PROCEDURE KLEURNORMAAL;
BEGIN
TEXTCOLOR(7);
TEXTBACKGROUND(0);
END;

PROCEDURE EGALINES;
BEGIN
TextMode(Lo(LastMode)+Font8x8);
END;

PROCEDURE INVOER(VAR A:STRING);
VAR QQQQQQQ:STRING;
    XXXXXXX:CHAR;
BEGIN
XXXXXXX:=CHR(1);
QQQQQQQ:='';
WHILE XXXXXXX<>CHR(13) DO
      BEGIN
      XXXXXXX:=READKEY;
      IF ORD(XXXXXXX)>31 THEN BEGIN QQQQQQQ:=QQQQQQQ+XXXXXXX; WRITE(XXXXXXX) END;
      IF XXXXXXX=CHR(8) THEN BEGIN DELETE(QQQQQQQ,LENGTH(QQQQQQQ),1); WRITE(CHR(8),' ',CHR(8)) END;
      END;
A:=''+QQQQQQQ;
END;

PROCEDURE MID(VAR AAAA:STRING;BBBB:INTEGER;CCCC:STRING);
BEGIN
DELETE(AAAA,BBBB,LENGTH(CCCC));
INSERT(CCCC,AAAA,BBBB);
END;

PROCEDURE MID7(VAR AAAA:STR7;BBBB:INTEGER;CCCC:STRING);
BEGIN
DELETE(AAAA,BBBB,LENGTH(CCCC));
INSERT(CCCC,AAAA,BBBB);
END;

FUNCTION EXIST(AAAA:STRING):BOOLEAN;
VAR AAA:SEARCHREC;
BEGIN
FINDFIRST(AAAA,Directory,AAA);
IF AAA.NAME='.' THEN FINDNEXT(AAA);
IF AAA.NAME='..' THEN FINDNEXT(AAA);
EXIST:=DOSERROR=0
END;

FUNCTION FSIZE(AAAA:STRING):LONGINT;
VAR AAA:SEARCHREC;
BEGIN
FINDFIRST(AAAA,Directory,AAA);
FSIZE:=AAA.SIZE;
END;

FUNCTION EXT(AAA:PATHSTR):STRING;
VAR A:DIRSTR;
    B:NAMESTR;
    C:EXTSTR;
BEGIN
FSPLIT(AAA,A,B,C);
EXT:=C;
END;

FUNCTION NAME(AAA:PATHSTR):STRING;
VAR A:DIRSTR;
    B:NAMESTR;
    C:EXTSTR;
BEGIN
FSPLIT(AAA,A,B,C);
NAME:=B;
END;

FUNCTION FDIR(AAA:PATHSTR):STRING;
VAR A:DIRSTR;
    B:NAMESTR;
    C:EXTSTR;
BEGIN
FSPLIT(AAA,A,B,C);
FDIR:=A;
END;

PROCEDURE DOSFOUT(VAR AAA:INTEGER);
BEGIN
AAA:=DOSERROR
END;

PROCEDURE VERW(AAA:STRING; VAR BBB:STRING);
BEGIN
IF POS(AAA,BBB)<>0 THEN
   BEGIN
   DELETE(BBB,POS(AAA,BBB),LENGTH(AAA));
   END;
END;

PROCEDURE Shell(AAA:STRING);
BEGIN
Swapvectors;
IF AAA='' THEN EXEC(GETENV('COMSPEC'),'') ELSE EXEC(GETENV('COMSPEC'),'/C '+AAA);
Swapvectors;
END;

PROCEDURE DIR(AAA:STRING);
VAR DIRINFO:SEARCHREC;
    D:STRING;
BEGIN
GETDIR(0,D);
WRITE('Directory van:',D);
FINDFIRST(AAA,ARCHIVE,DIRINFO);
WHILE DOSERROR=0 DO
      BEGIN
      WRITELN(DIRINFO.NAME,' ':14,DIRINFO.SIZE:6);
      FINDNEXT(DIRINFO);
      END;
WRITELN(DISKSIZE(0),'Bytes in gebruik en ',DISKFREE(0),' bytes vrij');
END;

PROCEDURE FILECOPY(AAA,BBB:STRING);
VAR BTT,BT2:FILE OF BYTE;
    XXX:BYTE;
    AA,BB:LONGINT;
BEGIN
ASSIGN(BTT,AAA); RESET(BTT); WRITE(SS(20,'.'),SS(20,CHR(8)));
ASSIGN(BT2,BBB); REWRITE(BT2); BB:=FILESIZE(BTT);
FOR AA:=1 to BB DO
    BEGIN
    WRITE(SS(ROUND((AA/BB)*20),'?'),SS(ROUND((AA/BB)*20),CHR(8)));
    READ(BTT,XXX);
    WRITE(BT2,XXX);
    END;
CLOSE(BTT);
CLOSE(BT2);
END;

PROCEDURE FILEMOVE(AAA,BBB:STRING);
VAR BTT,BT2:FILE OF BYTE;
    XXX:BYTE;
    AA,BB:LONGINT;
BEGIN
ASSIGN(BTT,AAA); RESET(BTT); WRITE(SS(20,'.'),SS(20,CHR(8)));
ASSIGN(BT2,BBB); REWRITE(BT2); BB:=FILESIZE(BTT);
FOR AA:=1 to BB DO
    BEGIN
    WRITE(SS(ROUND((AA/BB)*20),'?'),SS(ROUND((AA/BB)*20),CHR(8)));
    READ(BTT,XXX); {IF IORESULT<>0 THEN JBERROR:=IORESULT;}
    WRITE(BT2,XXX); {IF IORESULT<>0 THEN JBERROR:=IORESULT;}
    END;
CLOSE(BTT);
CLOSE(BT2);
ASSIGN(BTT,AAA); ERASE(BTT);
END;

FUNCTION JBDATE;
VAR UJBD,UJBM,UJBY,UJBW:WORD;
    BBB,CCC:STRING;
    DDD:INTEGER;
BEGIN
GETDATE(UJBY,UJBM,UJBD,UJBW);
DDD:=UJBD;
STR(DDD,BBB);
CCC:=BBB;
DDD:=UJBM;
STR(DDD,BBB);
CCC:=CCC+'-'+BBB+'-';
DDD:=UJBY;
STR(DDD,BBB);
CCC:=CCC+BBB+' ';
CASE UJBW OF
     0:BBB:='(Zondag)';
     1:BBB:='(Maandag)';
     2:BBB:='(Dinsdag)';
     3:BBB:='(Woendsdag)';
     4:BBB:='(Donderdag)';
     5:BBB:='(Vrijdag)';
     6:BBB:='(Zaterdag)';
     END;
JBDATE:=CCC+BBB;
END;

FUNCTION JBTIME;
VAR UJBH,UJBM,UJBS,UJBHND:WORD;
    BBB:STRING[2];
    CCC:STRING;
BEGIN
GETTIME(UJBH,UJBM,UJBS,UJBHND);
STR(UJBH,BBB);
IF LENGTH(BBB)=1 THEN BBB:='0'+BBB;
CCC:=BBB+':';
STR(UJBM,BBB);
IF LENGTH(BBB)=1 THEN BBB:='0'+BBB;
CCC:=CCC+BBB+':';
STR(UJBS,BBB);
IF LENGTH(BBB)=1 THEN BBB:='0'+BBB;
CCC:=CCC+BBB+'.';
STR(UJBHND,BBB);
IF LENGTH(BBB)=1 THEN BBB:='0'+BBB;
CCC:=CCC+BBB;
JBTIME:=CCC;
END;

Function ASC(AAAA:STRING):INTEGER;
VAR ABA:INTEGER;
BEGIN
ABA:=0;
WHILE (COPY(AAAA,1,1)<>CHR(ABA)) AND (ABA<255) DO ABA:=ABA+1;
ASC:=ABA;
END;

Function ASC2(AAAA:STRING):byte;
VAR ABA:byte;
BEGIN
ABA:=0;
WHILE (COPY(AAAA,1,1)<>CHR(ABA)) AND (ABA<255) DO ABA:=ABA+1;
ASC2:=ABA;
END;

Function Ss(AAA:LONGINT; BBB:STRING):STRING;
VAR RRR:STRING; AKKK:INTEGER;
BEGIN
RRR:='';
FOR AKKK:=1 TO AAA DO RRR:=RRR+BBB;
SS:=RRR;
END;

FUNCTION CAP(AAA:STRING):STRING;
VAR AKKK:INTEGER;
    CC:STRING;
BEGIN
CC:=AAA;
FOR AKKK:=1 to LENGTH(AAA) DO
    {IF (ASC(COPY(AAA,AKKK,1))>96) AND (ASC(COPY(AAA,AKKK,1))<123) THEN
    CC:=CC+CHR(ASC(COPY(AAA,AKKK,1))-32) ELSE CC:=CC+COPY(AAA,AkKK,1);}
    CC[Akkk]:=UpCase(CC[Akkk]);
CAP:=CC;
END;

FUNCTION UNCAP(AAA:STRING):STRING;
VAR AKKK:INTEGER;
    CC:STRING;
BEGIN
CC:='';
FOR AKKK:=1 to LENGTH(AAA) DO IF (ASC(COPY(AAA,AKKK,1))>64) AND (ASC(COPY(AAA,AKKK,1))<91) THEN
    CC:=CC+CHR(ASC(COPY(AAA,AKKK,1))+32) ELSE CC:=CC+COPY(AAA,AkKK,1);
UNCAP:=CC;
END;

PROCEDURE COLOR(AAA,BBB:INTEGER);
BEGIN
IF (AAA>-1) AND (AAA<32) THEN TEXTCOLOR(AAA);
IF (BBB>-1) AND (BBB<16) THEN TEXTBACKGROUND(BBB);
END;

PROCEDURE SH(AAA,BBB:STRING);
BEGIN
SWAPVECTORS;
EXEC(FEXPAND(FSEARCH(AAA,GETENV('PATH'))),BBB);
SHERR:=DOSEXITCODE;
SWAPVECTORS;
END;

FUNCTION JBN:STRING;
VAR JBNA:STRING;
BEGIN{
JBNA:=CHR(ROUND(ARCTAN(20)+SIN(10)*COS(77))+72);
JBNA:=JBNA+'e'+CHR(112+2)+CHR(109+2)+'e'+CHR(11*10);
JBNA:=JBNA+' B'+CHR(112+2)+CHR(ORD('p')-1)+CHR(100+7)+CHR(110+5);
JBN:=JBNA;}
JBN:='Jeroen P. Broks'
END;

PROCEDURE EDIT(AAA:INTEGER; VAR BBB:STRING);
VAR CCC,AKKK,PX,PY:INTEGER;
    XXX:CHAR;
BEGIN
PX:=WHEREX;
PY:=WHEREY;
CCC:=LENGTH(BBB)+1;
XXX:=#255;
WHILE XXX<>CHR(13) DO
      BEGIN
      GOTOXY(PX,PY);
      WRITE(BBB,' '); GOTOXY((PX+CCC)-1,PY);
      XXX:=READKEY;
      IF XXX=CHR(0) THEN
         BEGIN
         XXX:=READKEY;
         IF (XXX='K') AND (CCC>1) THEN BEGIN WRITE(CHR(8)); CCC:=CCC-1 END;
         IF (XXX='M') AND (CCC<LENGTH(BBB)+1) THEN BEGIN WRITE(COPY(BBB,CCC,1)); CCC:=CCC+1 END;
         IF (XXX='S') THEN DELETE(BBB,CCC,1);
         XXX:=CHR(1);
         END;
      IF (XXX=CHR(8)) AND (CCC>1) THEN BEGIN CCC:=CCC-1; DELETE(BBB,CCC,1) END;
      IF (ORD(XXX)>13) AND (CCC<AAA) THEN BEGIN INSERT(XXX,BBB,CCC); CCC:=CCC+1 END;
      END;
END;

FUNCTION DBG:BOOLEAN;
BEGIN
IF (PARAMSTR(1)='TESTING') AND (PARAMSTR(2)='DEBUG') AND (PARAMSTR(3)='OF') AND (PARAMSTR(4)='JEROEN') AND
(PARAMSTR(5)='BROKS') AND (PARAMSTR(6)='PROGRAMMING') AND (PARAMCOUNT=6) THEN DBG:=TRUE ELSE DBG:=FALSE;
END;

PROCEDURE BTINP(VAR BTT:TEXT; VAR AAAA:STRING);
VAR XXXXXXX:CHAR;
BEGIN XXXXXXX:=CHR(255); AAAA:='';
REPEAT
READ(BTT,XXXXXXX);
IF XXXXXXX<>CHR(1) THEN AAAA:=AAAA+XXXXXXX;
UNTIL XXXXXXX=CHR(1);
END;

FUNCTION HEX(AA:BYTE):STRING;
VAR RR:STRING[2];
BEGIN
CASE AA OF
     0:RR:='00';
     1:RR:='01';
     2:RR:='02';
     3:RR:='03';
     4:RR:='04';
     5:RR:='05';
     6:RR:='06';
     7:RR:='07';
     8:RR:='08';
     9:RR:='09';
    10:RR:='0A';
    11:RR:='0B';
    12:RR:='0C';
    13:RR:='0D';
    14:RR:='0E';
    15:RR:='0F';
    16:RR:='10';
    17:RR:='11';
    18:RR:='12';
    19:RR:='13';
    20:RR:='14';
    21:RR:='15';
    22:RR:='16';
    23:RR:='17';
    24:RR:='18';
    25:RR:='19';
    26:RR:='1A';
    27:RR:='1B';
    28:RR:='1C';
    29:RR:='1D';
    30:RR:='1E';
    31:RR:='1F';
    32:RR:='20';
    33:RR:='21';
    34:RR:='22';
    35:RR:='23';
    36:RR:='24';
    37:RR:='25';
    38:RR:='26';
    39:RR:='27';
    40:RR:='28';
    41:RR:='29';
    42:RR:='2A';
    43:RR:='2B';
    44:RR:='2C';
    45:RR:='2D';
    46:RR:='2E';
    47:RR:='2F';
    48:RR:='30';
    49:RR:='31';
    50:RR:='32';
    51:RR:='33';
    52:RR:='34';
    53:RR:='35';
    54:RR:='36';
    55:RR:='37';
    56:RR:='38';
    57:RR:='39';
    58:RR:='3A';
    59:RR:='3B';
    60:RR:='3C';
    61:RR:='3D';
    62:RR:='3E';
    63:RR:='3F';
    64:RR:='40';
    65:RR:='41';
    66:RR:='42';
    67:RR:='43';
    68:RR:='44';
    69:RR:='45';
    70:RR:='46';
    71:RR:='47';
    72:RR:='48';
    73:RR:='49';
    74:RR:='4A';
    75:RR:='4B';
    76:RR:='4C';
    77:RR:='4D';
    78:RR:='4E';
    79:RR:='4F';
    80:RR:='50';
    81:RR:='51';
    82:RR:='52';
    83:RR:='53';
    84:RR:='54';
    85:RR:='55';
    86:RR:='56';
    87:RR:='57';
    88:RR:='58';
    89:RR:='59';
    90:RR:='5A';
    91:RR:='5B';
    92:RR:='5C';
    93:RR:='5D';
    94:RR:='5E';
    95:RR:='5F';
    96:RR:='60';
    97:RR:='61';
    98:RR:='62';
    99:RR:='63';
   100:RR:='64';
   101:RR:='65';
   102:RR:='66';
   103:RR:='67';
   104:RR:='68';
   105:RR:='69';
   106:RR:='6A';
   107:RR:='6B';
   108:RR:='6C';
   109:RR:='6D';
   110:RR:='6E';
   111:RR:='6F';
   112:RR:='70';
   113:RR:='71';
   114:RR:='72';
   115:RR:='73';
   116:RR:='74';
   117:RR:='75';
   118:RR:='76';
   119:RR:='77';
   120:RR:='78';
   121:RR:='79';
   122:RR:='7A';
   123:RR:='7B';
   124:RR:='7C';
   125:RR:='7D';
   126:RR:='7E';
   127:RR:='7F';
   128:RR:='80';
   129:RR:='81';
   130:RR:='82';
   131:RR:='83';
   132:RR:='84';
   133:RR:='85';
   134:RR:='86';
   135:RR:='87';
   136:RR:='88';
   137:RR:='89';
   138:RR:='8A';
   139:RR:='8B';
   140:RR:='8C';
   141:RR:='8D';
   142:RR:='8E';
   143:RR:='8F';
   144:RR:='90';
   145:RR:='91';
   146:RR:='92';
   147:RR:='93';
   148:RR:='94';
   149:RR:='95';
   150:RR:='96';
   151:RR:='97';
   152:RR:='98';
   153:RR:='99';
   154:RR:='9A';
   155:RR:='9B';
   156:RR:='9C';
   157:RR:='9D';
   158:RR:='9E';
   159:RR:='9F';
   160:RR:='A0';
   161:RR:='A1';
   162:RR:='A2';
   163:RR:='A3';
   164:RR:='A4';
   165:RR:='A5';
   166:RR:='A6';
   167:RR:='A7';
   168:RR:='A8';
   169:RR:='A9';
   170:RR:='AA';
   171:RR:='AB';
   172:RR:='AC';
   173:RR:='AD';
   174:RR:='AE';
   175:RR:='AF';
   176:RR:='B0';
   177:RR:='B1';
   178:RR:='B2';
   179:RR:='B3';
   180:RR:='B4';
   181:RR:='B5';
   182:RR:='B6';
   183:RR:='B7';
   184:RR:='B8';
   185:RR:='B9';
   186:RR:='BA';
   187:RR:='BB';
   188:RR:='BC';
   189:RR:='BD';
   190:RR:='BE';
   191:RR:='BF';
   192:RR:='C0';
   193:RR:='C1';
   194:RR:='C2';
   195:RR:='C3';
   196:RR:='C4';
   197:RR:='C5';
   198:RR:='C6';
   199:RR:='C7';
   200:RR:='C8';
   201:RR:='C9';
   202:RR:='CA';
   203:RR:='CB';
   204:RR:='CC';
   205:RR:='CD';
   206:RR:='CE';
   207:RR:='CF';
   208:RR:='D0';
   209:RR:='D1';
   210:RR:='D2';
   211:RR:='D3';
   212:RR:='D4';
   213:RR:='D5';
   214:RR:='D6';
   215:RR:='D7';
   216:RR:='D8';
   217:RR:='D9';
   218:RR:='DA';
   219:RR:='DB';
   220:RR:='DC';
   221:RR:='DD';
   222:RR:='DE';
   223:RR:='DF';
   224:RR:='E0';
   225:RR:='E1';
   226:RR:='E2';
   227:RR:='E3';
   228:RR:='E4';
   229:RR:='E5';
   230:RR:='E6';
   231:RR:='E7';
   232:RR:='E8';
   233:RR:='E9';
   234:RR:='EA';
   235:RR:='EB';
   236:RR:='EC';
   237:RR:='ED';
   238:RR:='EE';
   239:RR:='EF';
   240:RR:='F0';
   241:RR:='F1';
   242:RR:='F2';
   243:RR:='F3';
   244:RR:='F4';
   245:RR:='F5';
   246:RR:='F6';
   247:RR:='F7';
   248:RR:='F8';
   249:RR:='F9';
   250:RR:='FA';
   251:RR:='FB';
   252:RR:='FC';
   253:RR:='FD';
   254:RR:='FE';
   255:RR:='FF';
    END;
hex:=rr;
END;

Function MouseInstalled:Boolean;
Var INT33h:Pointer;
Begin
GetIntVec($33,INT33h);
IF (BYTE(INT33h^)=$CF) OR (LONGINT(INT33h)=0) THEN MouseInstalled:=FALSE Else
MouseInstalled:=True;
End;

END.

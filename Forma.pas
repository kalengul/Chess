unit Forma;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls,
  UDoska, UFigyre,UIntel, Spin;

const
  Kletka : array[1..8] of char = ('a','b','c','d','e','f','g','h');

type
  TForm1 = class(TForm)
    DgPole: TDrawGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    RgWhite: TRadioGroup;
    RgBlack: TRadioGroup;
    RgRastanovka: TRadioGroup;
    BtBeginGame: TButton;
    MTest: TMemo;
    Panel3: TPanel;
    DgKill: TDrawGrid;
    RgDoskKill: TRadioGroup;
    LbProc: TLabel;
    LbHax: TLabel;
    BtHod: TButton;
    BtHodProt: TButton;
    RgBlackWhite: TRadioGroup;
    MTest1: TMemo;
    MTest2: TMemo;
    RgHod: TRadioGroup;
    Mtest3: TMemo;
    Mtest4: TMemo;
    MMaxHod: TMemo;
    SeKol: TSpinEdit;
    SeZnat: TSpinEdit;
    LbKol: TLabel;
    LbZnat: TLabel;
    RgViborHoda: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure RgRastanovkaClick(Sender: TObject);
    procedure BtBeginGameClick(Sender: TObject);
    procedure RgDoskKillClick(Sender: TObject);
    procedure DgPoleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtHodClick(Sender: TObject);
    procedure BtHodProtClick(Sender: TObject);
    procedure RgBlackWhiteClick(Sender: TObject);
    procedure SeZnatChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ProverkaNaShah(FigyraList:TFigyraList; Hod:THod):boolean;
Procedure PeremeshenieFigyri(TrebDosk:TDoska; FigyraHod:TFigyra; PosX,PosY:byte; flag:boolean);
procedure CopyDosk(Dosk:TDoska; var NewDosk:TDoska);
procedure DestroyDosk(NewDosk:TDoska);
Function ProverkaHod(Hod:THod):boolean;

var
  Form1: TForm1;
  Hod:THod;     {������ �����}
  FigyraHod:TFigyra; {������ ������� �����}
  komand:byte; {�������, ������� �����}
  Shah:Byte; {���}
  FigyraListWhite,FigyraListBlack:TFigyraList; {������ ����� ��� ��������� �����������}
  NulHod:Boolean;
  NewHod:THodTree;

implementation

uses UFigyraNew;

{$R *.dfm}

Procedure VivodTree(Head:THodTree; Memo:TMemo);
  var
  CurTree:THodTree;
  X,Y,Nap:Byte;
  F:TFigyra;
  St,St1:String;
  begin
  Memo.Clear;
  CurTree:=Head;
  While CurTree<>nil do
    begin
    Str(CurTree.YNat,St);
    Str(CurTree.Y,St1);
    St:=CurTree.Tip+' '+Kletka[CurTree.xNat]+St+' - '+Kletka[CurTree.x]+St1;
    Str(CurTree.KachYroven,St1);
    St:=St+' = '+st1;
    Memo.Lines.Add(st);
    CurTree:=CurTree.Brother;
    end;
  end;

Procedure DrawPole(Canvas:TCanvas);
Var
ACol,ARow:Byte;
Rect:TRect;
St:String[1];
begin
  Form1.DgPole.Color:=ClBtnFace;
  Form1.DgPole.Font.Color:=ClBlack;
  Form1.DgPole.Canvas.TextOut(45,3,'A');
  Form1.DgPole.Canvas.TextOut(45+61,3,'B');
  Form1.DgPole.Canvas.TextOut(45+61*2,3,'C');
  Form1.DgPole.Canvas.TextOut(45+61*3,3,'D');
  Form1.DgPole.Canvas.TextOut(45+61*4,3,'E');
  Form1.DgPole.Canvas.TextOut(45+61*5,3,'F');
  Form1.DgPole.Canvas.TextOut(45+61*6,3,'G');
  Form1.DgPole.Canvas.TextOut(45+61*7,3,'H');
  For ARow:=1 to 8 do
    begin
    Str(ARow,st);
    Form1.DgPole.Canvas.TextOut(6,((ARow-1)*61)+35+10,st);
    end;
  For ACol:=1 to 8 do
    For ARow:=1 to 8 do
      begin
      Rect:=Form1.DgPole.CellRect(ACol,ARow);
      Dosk.Draw(ACol,ARow,Rect,Canvas);
      end;
end;

procedure NewStandartFigyra(var NewFigyra:TFigyra; i:byte; komand:byte);
  var
    line:byte;
    simv:Char;
  begin
    case komand of
      1:line:=1;
      2:line:=8;
      end;
    If i<=8 then
      begin
     {������� ����� �����}
      NewFigyra:= TFigyra.Create('p',komand);
      if line=1 then
        NewFigyra.Ystanovit(i,line+1)
      else
        NewFigyra.Ystanovit(i,line-1);
      end
    Else
      begin
     {������� ����� ������}
      Case i-8 of
        1,8:Simv:='l';
        2,7:Simv:='k';
        3,6:Simv:='s';
        4:  Simv:='f';
        5:  Simv:='q';
        end;
      NewFigyra:= TFigyra.Create(simv,komand);
      NewFigyra.Ystanovit(i-8,line);
      end;
   end;

Procedure YstanovitFigyra(Figyra:TFigyra);
  var
    CurFigyraList,NewFigyraList:TFigyraList;
  begin
  if Form1.RgBlackWhite.ItemIndex=0 then
    begin
    CurFigyraList:=FigyraListWhite;
    While CurFigyraList.NextFigyra<>nil do
      CurFigyraList:=CurFigyraList.NextFigyra;
    NewFigyraList:=TFigyraList.CreateElList(Figyra);
    CurFigyraList.NextFigyra:=NewFigyraList;
    end
  else
    begin
    CurFigyraList:=FigyraListBlack;
    While CurFigyraList.NextFigyra<>nil do
      CurFigyraList:=CurFigyraList.NextFigyra;
    NewFigyraList:=TFigyraList.CreateElList(Figyra);
    CurFigyraList.NextFigyra:=NewFigyraList;
    end
  end;

Procedure NewAllStandart(komand:byte);
  var
    i:byte;
    NewFigyra:TFigyra;
    NewFigyraList:TFigyraList;
  begin
    HeadFigyraList:=nil;
    For i:=1 to 16 do
      begin
      NewStandartFigyra(NewFigyra,i,komand);
      NewFigyraList:=TFigyraList.CreateElList(NewFigyra);  {������� ����� ������� ������ �����}
      If HeadFigyraList<> nil then
        begin
        TopFigyraList.NextFigyra:=NewFigyraList;  {����������� ����� ������ � ����� ������ �����}
        TopFigyraList:=NewFigyraList;  {�������� ����� ������ �����}
        end
      Else
        begin
        HeadFigyralist:=NewFigyraList;
        TopFigyraList:=NewFigyraList;
        end;
      end;
  end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  Dosk:=TDoska.Create;
  Hod:=nil;
  DgPole.ColWidths[0]:=20;
  DgPole.RowHeights[0]:=20;
  DgPole.Canvas.Pen.Color:=ClBlack;
  DgKill.Visible:=false;
  DgKill.ColWidths[0]:=20;
  DgKill.RowHeights[0]:=20;
  RgDoskKill.ItemIndex:=0;
  FigyraListWhite:=nil;
  FigyraListBlack:=Nil;
  komand:=1;
end;

procedure TForm1.RgRastanovkaClick(Sender: TObject);
var
  NewSop:TSoperniki;
begin
  if RgRastanovka.ItemIndex=0 then
    begin
    DestroyDosk(Dosk);
    RgBlackWhite.Enabled:=False;
    RgBlackWhite.Visible:=False;
    BtBeginGame.Visible:=True; {���������� ������ �����}
    BtBeginGame.Enabled:=True;
    {������� ������ ����� �����}
    NewAllStandart(1);
    NewSop:=TSoperniki.CreateList(HeadFigyraList);
    Dosk.Sop:=NewSop;
    dosk.Sop.Rokirovka:=3;
    {������� ������ ����� ������}
    NewAllStandart(2);
    NewSop:=TSoperniki.CreateList(HeadFigyraList);
    Dosk.Sop.NextSop:=NewSop;
    dosk.Sop.NextSop.Rokirovka:=3;
    komand:=1;
    Dosk.HodShah(Dosk.Sop.FigyraList,Dosk.Sop.NextSop.FigyraList,Dosk.Sop.HodList);
    Dosk.HodShah(Dosk.Sop.NextSop.FigyraList,Dosk.Sop.FigyraList,Dosk.Sop.NextSop.HodList);
    end;    
  If RgRastanovka.ItemIndex=1 then
    begin
    DestroyDosk(Dosk);
    DrawPole(DgPole.Canvas);
    LbProc.Caption:='�������� ������� ������ �����';
    RgBlackWhite.Enabled:=true;
    RgBlackWhite.Visible:=true;
    RgHod.Visible:=true;   
    end;
end;

procedure TForm1.SeZnatChange(Sender: TObject);
begin
  Par:=SeZnat.Value;
end;

Procedure CopyList(List:TFigyraList; var NewList:TfigyraList);
var
  CurList,NewElList,TopNewList:TFigyraList;
  NewElFigyra:TFigyra;
begin
  NewList:=nil;
  CurList:=List;
  while CurList<>nil do
    begin
    NewElFigyra:=TFigyra.Create(CurList.Figyra.tip,CurList.Figyra.prenadl);
    NewElFigyra.Ystanovit(CurList.Figyra.x,CurList.Figyra.y);
    NewElList:=TFigyraList.CreateElList(NewElFigyra);
    NewElList.DeisFigyra:=CurList.Figyra;
    If NewList=nil then
      begin
      NewList:=NewElList;
      TopNewList:=NewList;
      end
    else
      begin
      TopNewList.NextFigyra:=NewElList;
      TopNewList:=NewElList;
      end;
    CurList:=CurList.NextFigyra;
    end;
end;

procedure CopyDosk(Dosk:TDoska; var NewDosk:TDoska);
  Var
    NewFigyra:TFigyra;
    NewFigyraList:TFigyraList;
  begin
  NewDosk:=TDoska.Create;
  If Dosk.Sop<>nil then
    begin
    {����������� ����� �����}
    CopyList(Dosk.Sop.FigyraList,NewFigyraList);
    NewDosk.Sop:=TSoperniki.CreateList(NewFigyraList);
    NewDosk.Sop.Rokirovka:=Dosk.Sop.Rokirovka;
    end;
  if (Dosk.Sop<>nil) and(Dosk.Sop.NextSop<>nil) then
    begin
    {����������� ����� �����}
    CopyList(Dosk.Sop.NextSop.FigyraList,NewFigyraList);
    NewDosk.Sop.NextSop:=TSoperniki.CreateList(NewFigyraList);
    NewDosk.Sop.NextSop.Rokirovka:=Dosk.Sop.NextSop.Rokirovka;
    end;
  If Dosk.Del<>nil then
    begin
    {����������� ����� �����}
    CopyList(Dosk.Del.FigyraList,NewFigyraList);
    NewDosk.Del:=TSoperniki.CreateList(NewFigyraList);
    end;
  if (Dosk.Del<>nil)and (Dosk.Del.NextSop<>nil) then
    begin
    {����������� ����� �����}
    CopyList(Dosk.Del.NextSop.FigyraList,NewFigyraList);
    NewDosk.Del.NextSop:=TSoperniki.CreateList(NewFigyraList);
    end;
  end;

Procedure DestroySop(DelSop:TSoperniki);
  Var
    DelFigyra:TFigyra;
    CurFigyraList,DelFigyraList:TFigyraList;
  begin
  If DelSop<>nil then
    begin
    CurFigyraList:=DelSop.FigyraList;
    While CurFigyraList<>nil do
      begin
      DelFigyraList:=CurFigyraList;
      CurFigyraList:=CurFigyraList.NextFigyra;
      DelFigyra:=DelFigyraList.Figyra;
      DelFigyra.Free;
      DelFigyraList.Free;
      end;
    end;
  DelSop.Free;
  end;

procedure DestroyDosk(NewDosk:TDoska);
  Var
    DelSop:TSoperniki;
  begin
  if newdosk<>nil then begin
  if NewDosk.Sop<>nil then
    begin
    DestroySop(NewDosk.Sop.NextSop);
    DestroySop(NewDosk.Sop);
    end;
  if newdosk.Del<>nil then
    begin
    DestroySop(NewDosk.Del.NextSop);
    DestroySop(NewDosk.Del);
    end;
  end;
  end;

function ProverkaNaShah(FigyraList:TFigyraList; Hod:THod):boolean;
  Var
    CurFigyraList:TFigyraList;
    CurHod:THod;
    PosX,PosY,VozX,VozY,Napad:Byte;
    NapadFigyra:TFigyra;
    NewFigyraList:TFigyraList;
  begin
  Result:=false;
  if Hod<>nil then begin
  CurFigyraList:=FigyraList;
  While (CurFigyraList.Figyra.tip<>'q') do
    CurFigyraList:=CurFigyraList.NextFigyra;
  PosX:=CurFigyraList.Figyra.x;
  PosY:=CurFigyraList.Figyra.y;
  CurHod:=Hod;
  While (CurHod<>nil) and (not result) do
    begin
    CurHod.SchitatHod(VozX,VozY,Napad,NapadFigyra);
    result:= (Napad<>1) and (VozX=PosX) and (VozY=PosY);
    CurHod:=CurHod.next;
    end;
  end;
  end;

procedure TForm1.BtBeginGameClick(Sender: TObject);
var
MaxHod:THodTree;
begin
 RgRastanovka.Enabled:=false;
 RgBlackWhite.Enabled:=false;
 RgBlackWhite.Visible:=false;
 RgHod.Visible:=false;
 Komand:=RgHod.ItemIndex+1;
 If komand=1 then
   LbProc.Caption:='��� �����'
 else
   LbProc.Caption:='��� ������';
 DrawPole(DgPole.Canvas);
 Dosk.DrawAllFigyre(DgPole.Canvas,Dosk.Sop);
 SozdTree;
 VivodTree(Head.Child,MTest);
 par:=20;
 if komand=1 then
   MaximalHod(Head.Child,False,MaxHod)
 else
   MaximalHod(Head.Child,True,MaxHod);
 VivodTree(MaxHod,MMaxhod);
 {����� ����}
 ViborHod(MaxHod,NewHod);
end;

procedure TForm1.RgDoskKillClick(Sender: TObject);

begin
  Case RgDoskKill.ItemIndex of
    0:begin
      DgPole.Visible:=true;
      DgKill.Visible:=false;
      DrawPole(DgPole.Canvas);
      If Dosk.Sop<>nil then
        Dosk.DrawAllFigyre(DgPole.Canvas,Dosk.Sop);
      end;
    1:begin
      DgPole.Visible:=false;
      DgKill.Visible:=true;
      DrawPole(DgKill.Canvas);
      if dosk.Del<>nil then
        Dosk.DrawAllFigyre(DgKill.Canvas,Dosk.Del);
      end;
    end;
end;

procedure VidelKletka(PosX,PosY:byte);
  begin
  Form1.DgPole.Canvas.Brush.Color:=ClGreen;
  Form1.DgPole.Canvas.Rectangle((PosX-1)*61+20,(PosY-1)*61+20,PosX*61+20,PosY*61+20);
  end;

Procedure VidelKletkaSoyznika(PosX,PosY:Byte);
  begin
  Form1.DgPole.Canvas.Brush.Color:=ClYellow;
  Form1.DgPole.Canvas.Rectangle((PosX-1)*61+20,(PosY-1)*61+20,PosX*61+20,PosY*61+20);
  end;

Procedure VidelKletkaProtivnika(PosX,PosY:Byte);
  begin
  Form1.DgPole.Canvas.Brush.Color:=ClRed;
  Form1.DgPole.Canvas.Rectangle((PosX-1)*61+20,(PosY-1)*61+20,PosX*61+20,PosY*61+20);
  end;

Procedure PeremeshenieFigyri(TrebDosk:TDoska; FigyraHod:TFigyra; PosX,PosY:byte; flag:boolean);
var
  CurLFigyraList:TFigyraList;
  Tip:byte;
  ProtFigyra:TFigyra;
begin
 TrebDosk.ClearKletka(PosX,PosY,FigyraHod.prenadl,tip,ProtFigyra);
 if tip=2 then
   TrebDosk.KillFigyre(PosX,PosY);
 Hod:=nil;
 {����������� ������}
 if tip<>1 then  begin
  if (FigyraHod.tip='q') and (((komand=1) and(TrebDosk.Sop.Rokirovka<>0)) or((komand=2)and(TrebDosk.Sop.NextSop.Rokirovka<>0))) then
    begin
    if komand=1 then
      TrebDosk.Sop.Rokirovka:=0
    else
      Trebdosk.Sop.NextSop.Rokirovka:=0;
    If (PosX=7) and ((PosY=1) or (PosY=8)) then
      begin
      {����� �����}
      If FigyraHod.prenadl=1 then
        CurLFigyraList:=TrebDosk.Sop.FigyraList
      else
        CurLFigyraList:=TrebDosk.Sop.NextSop.FigyraList;
      While (CurLFigyraList<>nil) and not ((CurLFigyraList.Figyra.tip='l') and (CurLFigyraList.Figyra.x=8)) do
        CurLFigyraList:=CurLFigyraList.NextFigyra;
      {������������ �����}
      CurLFigyraList.Figyra.x:=6;
      end; {(PosX=7) and ((PosY=1) or (PosY=8)}
    If (PosX=3) and ((PosY=1) or (PosY=8)) then
      begin
     {����� �����}
      If FigyraHod.prenadl=1 then
        CurLFigyraList:=TrebDosk.Sop.FigyraList
      else
        CurLFigyraList:=TrebDosk.Sop.NextSop.FigyraList;
      While (CurLFigyraList<>nil) and not ((CurLFigyraList.Figyra.tip='l') and (CurLFigyraList.Figyra.x=1)) do
        CurLFigyraList:=CurLFigyraList.NextFigyra;
      {������������ �����}
      CurLFigyraList.Figyra.x:=4;
      end;  {(PosX=3) and ((PosY=1) or (PosY=8)}
    end; {FigyraHod.tip='q'}
  if (FigyraHod.tip='l') and (((komand=1) and(TrebDosk.Sop.Rokirovka<>0)) or((komand=2)and(TrebDosk.Sop.NextSop.Rokirovka<>0))) then
    begin
    if FigyraHod.x=1 then
      if (komand=1) then
        begin
        If (TrebDosk.Sop.Rokirovka=3) then
          TrebDosk.Sop.Rokirovka:=1;
        If (TrebDosk.Sop.Rokirovka=2) then
          TrebDosk.Sop.Rokirovka:=0;
       end {(komand=1)}
     else
       begin
       If (TrebDosk.Sop.NextSop.Rokirovka=3) then
         Trebdosk.Sop.NextSop.Rokirovka:=1;
       If (TrebDosk.Sop.NextSop.Rokirovka=2) then
         Trebdosk.Sop.NextSop.Rokirovka:=0;
       end;{(komand=2)}
     If FigyraHod.x=8 then
       if komand=1 then
         begin
         If (TrebDosk.Sop.Rokirovka=3) then
           TrebDosk.Sop.Rokirovka:=2;
         If (TrebDosk.Sop.Rokirovka=1) then
           TrebDosk.Sop.Rokirovka:=0;
         end {(komand=1)}
       else
         begin
         If (TrebDosk.Sop.NextSop.Rokirovka=3) then
           Trebdosk.Sop.NextSop.Rokirovka:=2;
         If (TrebDosk.Sop.NextSop.Rokirovka=1) then
           Trebdosk.Sop.NextSop.Rokirovka:=0;
         end; {(komand=2)}
    end; {FigyraHod.tip='l'}
  FigyraHod.x:=PosX;
  FigyraHod.y:=PosY;
  end;
  if ((FigyraHod.tip='p') and ((FigyraHod.y=1) or (FigyraHod.y=8))) and (flag) then
    begin {����� �� ��������� �����}
    FFigyra.ShowModal;
    FigyraHod.tip:=UFigyraNew.Figyra.tip;
    end;
end;

Function ProverkaHod(Hod:THod):boolean;
  var
    X,Y,Napad:byte;
    F:TFigyra;
  begin
  Result:=true;
  While Hod<>nil do
    begin
    Hod.SchitatHod(X,Y,Napad,F);
    If Napad<>2 then Result:=false;
    Hod:=Hod.next;
    end;
  end;


procedure TForm1.DgPoleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  PosX,PosY,VozX,VozY,Napad:Byte;
  SopFigyraList:TFigyraList;
  Tip,NKomand:Byte;
  CurHod,kompHod:THod;
  CurFigyra,protFigyra:TFigyra;
  CurLFigyraList:TFigyraList;
  DelHod,MaxHod:tHodTree;
  Test:THod;
  a,s,d,g:byte;
  f:TFigyra;
  st,st1,st2:string;
  Maks:Longint;
  nom:byte;
begin
  DrawPole(DgPole.Canvas);
  If ((RgWhite.ItemIndex=0) and (komand=1)) or
     ((RgBlack.ItemIndex=0) and (komand=2)) then
    begin
    PosX:=(x-20) div 61+1;
    PosY:=(Y-20) div 61+1;
    end
  else
    begin
    Hod:=THod.Create;
    Hod.YstanovitHod(NewHod.X,Newhod.Y,0,nil,NewHod.Tip);
    PosX:=NewHod.X;
    PosY:=NewHod.Y;
    {����� ������}
    if komand=1 then
      CurLFigyralist:=Dosk.Sop.FigyraList
    else
      CurLFigyralist:=Dosk.Sop.NextSop.FigyraList;
    While (CurLFigyraList<>nil) and
          not((CurLFigyraList.Figyra.x=NewHod.Xnat) and (CurLFigyraList.Figyra.y=NewHod.Ynat) and (CurLFigyraList.Figyra.tip=NewHod.Tip)) do
      CurLFigyraList:=CurLFigyraList.NextFigyra;
    If CurLFigyraList<>nil then
      FigyraHod:=CurLFigyraList.Figyra;
    end;

  {���� ���������� ���������}
  If (RgRastanovka.ItemIndex=1) and (RgRastanovka.Enabled=true) then
    begin
    if Dosk.Sop=nil then
      begin
      LbProc.Caption:='�������� ������� ������ ������';
      UFigyraNew.Figyra:=TFigyra.Create('q',1);
      UFigyraNew.Figyra.Ystanovit(PosX,PosY);
      VozX:=PosX;
      VozY:=PosY;
      FigyraListWhite:=TFigyraList.CreateElList(UFigyraNew.Figyra);
      Dosk.Sop:=TSoperniki.CreateList(FigyraListWhite);
      end
    else
    if (Dosk.Sop.NextSop=nil) and (PosX<>VozX) and (PosY<>VozY) then
      begin
      LbProc.Caption:='��� ������ ���� ���������� ��� ������';
      UFigyraNew.Figyra:=TFigyra.Create('q',2);
      UFigyraNew.Figyra.Ystanovit(PosX,PosY);
      FigyraListBlack:=TFigyraList.CreateElList(UFigyraNew.Figyra);
      Dosk.Sop.NextSop:=TSoperniki.CreateList(FigyraListBlack);
      end
    else
    begin
    Dosk.ClearKletka(PosX,PosY,RgRastanovka.ItemIndex,Tip,CurFigyra);
    If tip=0 then
      begin
      LbProc.Caption:='��� ������ ���� ������� ������ "������ ����"';
      BtBeginGame.Enabled:=true;
      BtBeginGame.Visible:=True;
      FFigyra.ShowModal;
      UFigyraNew.Figyra.Ystanovit(PosX,PosY);
      YstanovitFigyra(UFigyraNew.Figyra);
      Dosk.Sop.FigyraList:=FigyraListWhite;
      Dosk.Sop.NextSop.FigyraList:=FigyraListBlack;
      Dosk.DrawAllFigyre(DgPole.Canvas,Dosk.Sop);
      dosk.Sop.Rokirovka:=0;
      dosk.Sop.NextSop.Rokirovka:=0;
      Dosk.HodShah(Dosk.Sop.FigyraList,Dosk.Sop.NextSop.FigyraList,Dosk.Sop.HodList);
      Dosk.HodShah(Dosk.Sop.NextSop.FigyraList,Dosk.Sop.FigyraList,Dosk.Sop.NextSop.HodList);
      end;
    end;
    end
  else
  begin
  If Dosk.Sop<>nil then
     begin
     If Hod=nil then
       begin
       Dosk.ClearKletka(PosX,PosY,komand,tip,ProtFigyra);
       if Tip=1 then
         begin
         FigyraHod:=ProtFigyra;
         if komand=1 then
           Dosk.ListHodovFigyreShah(ProtFigyra,Dosk.Sop.FigyraList,dosk.Sop.NextSop.FigyraList,Hod)
         else
           Dosk.ListHodovFigyreShah(ProtFigyra,Dosk.Sop.NextSop.FigyraList,dosk.Sop.FigyraList,Hod);
         CurHod:=Hod;
         While CurHod<>nil do
           begin
           CurHod.SchitatHod(PosX,PosY,Napad,ProtFigyra);
           if napad<>2 then
           begin
           Dosk.ClearKletka(PosX,PosY,komand,tip,ProtFigyra);
           If Tip=0 then
             VidelKletka(PosX,PosY);
           If Tip=1 then
             VidelKletkaSoyznika(PosX,PosY);
           If Tip=2 then
             VidelKletkaProtivnika(PosX,PosY);
           end; {napad}
           CurHod:=CurHod.next;
           end;  {While}
         end;    {Tip=1}
       end    {hod=nil}
     else
       begin
       CurHod:=Hod;
       While CurHod<>nil do
         begin
         CurHod.SchitatHod(VozX,VozY,Napad,ProtFigyra);
         If (VozX=PosX) and (VozY=PosY) and (NApad<>2) then
           Break;
         CurHod:=CurHod.next;
         end;  {While}
       if CurHod=nil then
         Hod:=Nil
       else
         begin
         PeremeshenieFigyri(Dosk,FigyraHod,PosX,PosY,true);
         {���������� ���� ��������� �����}
         Dosk.HodShah(Dosk.Sop.FigyraList,Dosk.Sop.NextSop.FigyraList,Dosk.Sop.HodList);
         Dosk.HodShah(Dosk.Sop.NextSop.FigyraList,Dosk.Sop.FigyraList,Dosk.Sop.NextSop.HodList);
         {��������� ������ �����}
         {���������� ����}
         VitHod(CurHod,DelHod);
         ZnakKath:=-ZnakKath;
         {������� ���������� ������}
         Perestryktyrirovat(DelHod);
         {��������� ��� �������}
         NewKomand:=Komand;
         if SeKol.Value>=KolHod then
           begin
           for nom:=1 to SeKol.Value-KolHod+1 do
             begin
             AddYroven;
             if Nkomand=1 then
               NKomand:=2
             else
               nKomand:=1;
             end;
           Kolhod:=Sekol.Value;
           end
         else
           Dec(KolHod);
         {������������ ����}
         PoiskMaksim;
         {������� ������}
         VivodTree(Head.Child,MTest);
         {��������� � ������� ������ ����}
         if komand=1 then
           MaximalHod(Head.Child,False,MaxHod)
         else
           MaximalHod(Head.Child,True,MaxHod);
         VivodTree(MaxHod,MMaxhod);
         {����� ����}
         if RgViborHoda.ItemIndex=1  then
            ViborHod(MaxHod,NewHod)
         Else
            NewHod:=Maxhod;
         Inc(k);
         str(k,st);
         vivodfail(st+'.txt');
         Hod.Free;
         {�������� ���� ������ �������}
         if (tip<>1) then
         If komand=1 then
           begin
           LbProc.Caption:='��� ������';
           Komand:=2;
           Dosk.HodShah(Dosk.Sop.NextSop.FigyraList,Dosk.Sop.FigyraList,Dosk.Sop.NextSop.HodList);
           NulHod:=ProverkaHod(Dosk.Sop.NextSop.HodList);
           If ProverkaNaShah(Dosk.Sop.NextSop.FigyraList,dosk.Sop.HodList) then
             begin
             LbHax.Caption:='���';
             if NulHod then
               LbHax.Caption:='���';
             end
           else
             begin
             IF (NulHod) or ((Dosk.Sop.FigyraList.NextFigyra=nil) and (Dosk.Sop.NextSop.FigyraList.NextFigyra=nil)) then
               LbHax.Caption:='���'
             else
               LbHax.Caption:='';
             end;
           end
         else
           begin
           LbProc.Caption:='��� �����';
           Komand:=1;
           Dosk.HodShah(Dosk.Sop.FigyraList,Dosk.Sop.NextSop.FigyraList,Dosk.Sop.HodList);
           NulHod:=ProverkaHod(Dosk.Sop.HodList);
           If ProverkaNaShah(Dosk.Sop.FigyraList,dosk.Sop.NextSop.HodList) then
             begin
             LbHax.Caption:='���';
             Dosk.HodShah(Dosk.Sop.FigyraList,Dosk.Sop.NextSop.FigyraList,Dosk.Sop.HodList);
             if NulHod then
               LbHax.Caption:='���';
             end
           else
             begin
             IF (NulHod) or ((Dosk.Sop.FigyraList.NextFigyra=nil) and (Dosk.Sop.NextSop.FigyraList.NextFigyra=nil)) then
               LbHax.Caption:='���'
             else
               LbHax.Caption:='';
             end;
           end;
         end;
       end;  {Hod<>nil}
     Dosk.DrawAllFigyre(DgPole.Canvas,Dosk.Sop);
     end;     {Dosk.sop<>nil}
  end; {if ItemIndex=1}
end;

procedure TForm1.BtHodClick(Sender: TObject);
  var
  CurHod:THod;
  PosX,PosY,Tip,Napad:byte;
  ProtFigyra:TFigyra;
  begin
  DrawPole(DgPole.Canvas);
  if komand=1 then
    CurHod:=Dosk.Sop.HodList
  else
    CurHod:=Dosk.Sop.NextSop.HodList;
  While CurHod<>nil do
    begin
    CurHod.SchitatHod(PosX,PosY,Napad,ProtFigyra);
    if Napad<>2 then begin
    Dosk.ClearKletka(PosX,PosY,komand,tip,ProtFigyra);
    If Tip=0 then
      VidelKletka(PosX,PosY);
    If Tip=1 then
      VidelKletkaSoyznika(PosX,PosY);
    If Tip=2 then
      VidelKletkaProtivnika(PosX,PosY);
    end;
    CurHod:=CurHod.next;
    end;  {While}
  Dosk.DrawAllFigyre(DgPole.Canvas,Dosk.Sop);
  end;

procedure TForm1.BtHodProtClick(Sender: TObject);
  var
  CurHod:THod;
  PosX,PosY,Tip,NKomand,Napad:byte;
  ProtFigyra:TFigyra;
  begin
  DrawPole(DgPole.Canvas);
  if komand=2 then
    begin
    CurHod:=Dosk.Sop.HodList;
    NKomand:=1;
    end
  else
    begin
    CurHod:=Dosk.Sop.NextSop.HodList;
    NKomand:=2;
    end;
  While CurHod<>nil do
    begin
    CurHod.SchitatHod(PosX,PosY,Napad,ProtFigyra);
    if Napad<>2 then begin
    Dosk.ClearKletka(PosX,PosY,Nkomand,tip,ProtFigyra);
    If Tip=0 then
      VidelKletka(PosX,PosY);
    If Tip=1 then
      VidelKletkaSoyznika(PosX,PosY);
    If Tip=2 then
      VidelKletkaProtivnika(PosX,PosY);
    end;  
    CurHod:=CurHod.next;
    end;  {While}
  Dosk.DrawAllFigyre(DgPole.Canvas,Dosk.Sop);
end;

procedure TForm1.RgBlackWhiteClick(Sender: TObject);
begin
if RgBlackWhite.ItemIndex=0 then
  Komand:=1;
If RgBlackWhite.ItemIndex=1 then
  komand:=2;
end;

end.

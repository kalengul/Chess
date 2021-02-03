unit UIntel;

interface

uses UFigyre, UDoska;

type
  THodTree = Class
    Brother,Father,Child:THodTree;
    Kach:Integer;
    KachYroven:integer;
    X,Y,Xnat,YNat:byte;
    Tip:Char;
    Constructor Create;
    end;

  PStackHod = ^TStackHod;
  TStackHod = record
    Tip:Char;
    X,Y,Xnat,YNat:Byte;
    Next:pStackHod;
    end;

Procedure AddHod(FatherHod:THodTree; var NewHod:THodTree);
Procedure Perestryktyrirovat(Hod:THodTree);
Procedure AddYroven;
procedure NextHod(var Hod:THodTree);
procedure VitChena(FDosk:tDoska; Figyra:tFigyra; X,Y:byte;var Kach:integer);
Procedure AddList(FatherHod:THodTree);
Procedure DelHod(var Hod:THod);
procedure SozdTree;
procedure vivodfail(st:string);
Procedure PoiskMaksim;
Procedure VitHod(Hod:THod; var HodTree:THodTree);
Procedure SearchMaks(FatherHod:THodTree; var Maks:integer; var MaksHod:THodTree);
Procedure MaximalHod(Head:THodTree; ExtremMax:boolean; var MaxHod:THodTree);
Procedure ViborHod(HodTree:THodTree; var ViborHod:tHodTree);
var
  Head:THodTree;
  NewDosk:TDoska;
  NewKomand:byte;
  k:byte;
  ZnakKath:Shortint;
  par:word;
  kolHod:byte;

implementation

uses forma;

procedure vivodfail(st:string);
  var
  F:TextFile;
  curHod:THodTree;
  l:byte;

procedure vivod(Hod:THodTree);
  var
  st,st1:string;
  i:byte;
  begin

  str(Hod.YNat,st1);
  st:=Hod.tip+' s   '+Kletka[Hod.XNat]+st1;
  st:=st+'    na   '+Kletka[Hod.x];
  str(Hod.Y,st1);
  st:=st+st1;
  str(Hod.Kach,st1);
  st:=st+'    '+st1;
  str(Hod.KachYroven,st1);
  st:=st+'     '+st1;
  For i:=1 to l do
    St:='*'+St;
  Writeln(f,st);
{  Form1.MTest.Lines.Add(st); }
  end;

  begin
{  Form1.MTest.Clear;}
  AssignFile(f,st);
  Rewrite(f);
  CurHod:=Head;
  l:=0;
  While CurHod<>nil do
    begin
    if CurHod.Child<>nil then
      begin
      inc(l);
      CurHod:=CurHod.Child;
      Vivod(CurHod);
      end;
    If (CurHod.Child=nil) and (CurHod.Brother<>nil) then
      begin
      CurHod:=CurHod.Brother;
      Vivod(CurHod);
      end;
    If (CurHod.Child=nil) and (CurHod.Brother=nil) then
      begin
      CurHod:=CurHod.Father;
      Dec(l);
      While (CurHod<>nil) and (CurHod.Brother=nil) do
        begin
        curHod:=CurHod.Father;
        dec(l);
        end;
      if curhod<>nil then
        begin
        CurHod:=CurHod.Brother;
        Vivod(CurHod);
        end;
      end;
    end;
  CloseFile(f);
  end;

procedure SozdTree;
  var
  l:byte;
  st:string;
  maks:Longint;
  begin
  Znakkath:=1;
  Head:=THodTree.Create;
  NewDosk:=UDoska.Dosk;
  NewKomand:=1;
  AddList(Head);
  For l:=1 to Form1.SeKol.Value-1 do
    begin
    If NewKomand=1 then
      NewKomand:=2                        
    else
      NewKomand:=1;
    ZnakKath:=-ZnakKath;

    AddYroven;
    end;
    Kolhod:=2;
    PoiskMaksim;
    Inc(k);
    str(k,st);
    vivodfail(st+'.txt');
  end;

{Процедура добавления уровня ходов}
procedure AddYroven;
  var
    CurHod,FHod:THodTree;
    Stack,NewStack:pStackHod;
    x,y,Napad:byte;
    Figyra:TFigyra;
    FigyraList:TFigyraList;
  begin
  CurHod:=Head;
  repeat
    {Получаем ход с последнего уровня к которому будем стыковать}
    NextHod(CurHod);
    {Вычисляем путь к этому ходу}
    if (curhod<>nil) and (CurHod<>head) then begin
    Stack:=nil;
    FHod:=CurHod;
     While (FHod<>Head) and (FHod<>nil) do
       begin
       New(NewStack);
       If FHod=CurHod then
         NewStack.Next:=nil
       else
         NewStack.Next:=Stack;
       NewStack.Tip:=FHod.Tip;
       NewStack.X:=FHod.X;
       NewStack.Y:=FHod.Y;
       NewStack.XNat:=FHod.XNat;
       NewStack.YNat:=FHod.YNat;
       Stack:=NewStack;
       FHod:=FHod.Father;
       end;
    {Создаем новую доску}
    CopyDosk(UDoska.Dosk,NewDosk);
    {Вычисляем новый список фигур dosk}
    While Stack<>nil do
      begin
      {Поиск фигуры на новой доске}
      FigyraList:=NewDosk.Sop.FigyraList;
      While (FigyraList<>nil) and not ((Figyralist.Figyra.x=Stack.XNat) and (Figyralist.Figyra.y=Stack.YNat) and (Figyralist.Figyra.tip=Stack.Tip)) do
        FigyraList:=FigyraList.NextFigyra;
      If Figyralist=nil then
        begin
        FigyraList:=NewDosk.Sop.NextSop.FigyraList;
        While (FigyraList<>nil) and not ((Figyralist.Figyra.x=Stack.XNat) and (Figyralist.Figyra.y=Stack.YNat)and (Figyralist.Figyra.tip=Stack.Tip)) do
          FigyraList:=FigyraList.NextFigyra;
        end;
      Figyra:=FigyraList.Figyra;
      Forma.PeremeshenieFigyri(NewDosk,Figyra,stack.X,stack.Y,false);
      NewStack:=Stack;
      Stack:=stack.Next;
      NewStack.Next:=nil;
      dispose(NewStack);
      end;
    {Записываем все возможные ходы фигур в дерево}
    AddList(CurHod);
    {Удаляем созданную доску}
    DestroyDosk(NewDosk);
    NewDosk.Free;
    end;
  {Пока можем получать ходы с последнего уровня}
  until (CurHod=nil) or (CurHod=head) ;

  end;

{Процедура добавления ходов}
Procedure AddList(FatherHod:THodTree);
  var
    Hod,CurHod:THod;
    FigyraList:TFigyraList;
    X,Y,Nap:byte;
    Kath:integer;
    NewHod:THodTree;
    Figyra,NewFigyra:TFigyra;

  begin
    {Идем по всем фигурам}
    if NewKomand=1 then
      FigyraList:=NewDosk.Sop.FigyraList
    else
      FigyraList:=NewDosk.Sop.NextSop.FigyraList;
    While FigyraList<>nil do
      begin
      {Для каждой фигуры генерируем список возможных ходов}
      if NewKomand=1 then
        NewDosk.ListHodovFigyreShah(FigyraList.Figyra,NewDosk.Sop.FigyraList,NewDosk.Sop.NextSop.FigyraList,Hod)
      else
        NewDosk.ListHodovFigyreShah(FigyraList.Figyra,NewDosk.Sop.NextSop.FigyraList,NewDosk.Sop.FigyraList,Hod);
      {Удаление ненужных ходов}
      DelHod(Hod);
      CurHod:=Hod;
      {Идем по всем ходам фигуры}
      While CurHod<>nil do
        begin
        {Для каждого хода строим новый элемент дерева}
        AddHod(FatherHod,NewHod);
        CurHod.SchitatHod(X,Y,Nap,Figyra);
        NewHod.Xnat:=FigyraList.Figyra.x;
        NewHod.Ynat:=FigyraList.Figyra.y;
        NewHod.X:=X;
        NewHod.Y:=Y;
        NewHod.Tip:=FigyraList.Figyra.tip;
        {Вычисляем цену каждого хода}
        VitChena(NewDosk,FigyraList.Figyra,X,Y,Kath);
        Kath:=Kath*ZnakKath;
        NewHod.Kach:=Kath;
        NewHod.KachYroven:=Kath;
        {Переходим к следующему ходу}
        CurHod:=CurHod.next;
        end;
      {Переходим к следующей фигуре}
      FigyraList:=FigyraList.NextFigyra;
      end;

  end;

{Процедура получения хода последнего уровня}
procedure NextHod(var Hod:THodTree);
  begin
  {Если Нод=Head}
  if Hod=Head then
    begin
    {То ищем ближайший ход у которого нет наследников, и он не матовый}
    While Hod.Child<>nil do
      Hod:=Hod.Child;
    end
  {иначе}
  else
    begin
{    repeat
    {Пока к брату двигаться нельзя}
    While (Hod<>nil) and (Hod<>Head) and(Hod.Brother=nil) do
      {Двигаемся вверх}
      Hod:=Hod.Father;
    if (Hod<>nil) and (Hod<>Head) then
      Hod:=Hod.Brother;
    {Пока потомки есть}
    While (Hod<>nil) and (Hod<>Head) and (Hod.Child<>nil) do
      {Двигаемся вниз}
      Hod:=Hod.Child;
    {Пока ход не матовый}
    end;
{    until (Hod=nil) or (Hod=Head);}
  end;

{Процедура вычисления цены хода}
procedure VitChena(FDosk:tDoska; Figyra:tFigyra; X,Y:byte; var Kach:integer);
  Var
    Hod:THod;
    Napad,Line,Tip:byte;
    NFigyra,PFigyra:TFigyra;
    NDosk:TDoska;
    NFigyraList:tFigyraList;
  begin
  Kach:=0;
  Forma.CopyDosk(FDosk,NDosk);
  {Поиск фигуры на новой доске}
  NFigyraList:=NDosk.Sop.FigyraList;
  While (NFigyraList<>nil) and not ((NFigyralist.Figyra.x=Figyra.x) and (NFigyralist.Figyra.y=Figyra.y) and (NFigyralist.Figyra.tip=Figyra.tip)) do
    NFigyraList:=NFigyraList.NextFigyra;
  If NFigyralist=nil then
    begin
    NFigyraList:=NDosk.Sop.NextSop.FigyraList;
    While (NFigyraList<>nil) and not ((NFigyralist.Figyra.x=Figyra.x) and (NFigyralist.Figyra.y=Figyra.y)and (NFigyralist.Figyra.tip=Figyra.tip)) do
      NFigyraList:=NFigyraList.NextFigyra;
    end;
  PFigyra:=NFigyraList.Figyra;
  NDosk.ClearKletka(X,Y,PFigyra.prenadl,Tip,NFigyra);
  If (Tip<>0) and (NFigyra.tip='p') then
   If PFigyra.prenadl=1 then
      Line:=Y-2
   else
      Line:=7-Y;
  Case PFigyra.tip of
    'p':Case NFigyra.tip of
         'p':Kach:=Kach+10*(6-Line);
         's':Kach:=Kach+70;
         'k':Kach:=Kach+80;
         'l':Kach:=Kach+110;
         'f':Kach:=Kach+160;
         end;
    's':Case NFigyra.tip of
         'p':Kach:=Kach+7*(6-Line);
         's':Kach:=Kach+50;
         'k':Kach:=Kach+60;
         'l':Kach:=Kach+90;
         'f':Kach:=Kach+110;
         end;
    'k':Case NFigyra.tip of
         'p':Kach:=Kach+7*(6-Line);
         's':Kach:=Kach+45;
         'k':Kach:=Kach+60;
         'l':Kach:=Kach+90;
         'f':Kach:=Kach+110;
         end;
    'l':Case NFigyra.tip of
         'p':Kach:=Kach+5*(6-Line);
         's':Kach:=Kach+20;
         'k':Kach:=Kach+20;
         'l':Kach:=Kach+60;
         'f':Kach:=Kach+80;
         end;
    'f':Case NFigyra.tip of
         'p':Kach:=Kach+3*(6-Line);
         's':Kach:=Kach+20;
         'k':Kach:=Kach+20;
         'l':Kach:=Kach+50;
         'f':Kach:=Kach+70;
         end;
    'q': Case NFigyra.tip of
         'p':Kach:=Kach+15*(6-Line);
         's':Kach:=Kach+100;
         'k':Kach:=Kach+100;
         'l':Kach:=Kach+130;
         'f':Kach:=Kach+170;
         end;
    end;
  Forma.PeremeshenieFigyri(NDosk,PFigyra,X,Y,False);
  If PFigyra.prenadl=1 then
    NDosk.ListHodovFigyreShah(PFigyra,NDosk.Sop.FigyraList,NDosk.Sop.NextSop.FigyraList,Hod)
  else
    NDosk.ListHodovFigyreShah(PFigyra,NDosk.Sop.NextSop.FigyraList,NDosk.Sop.FigyraList,Hod);
  Case PFigyra.tip of
    'p': begin
         If PFigyra.prenadl=1 then
           Line:=Y-2
         else
           Line:=7-Y;
           Case Line of
             1:Kach:=Kach+30;
             2:Kach:=Kach+40;
             3:Kach:=Kach+50;
             4:Kach:=Kach+60;
             5:Kach:=Kach+80;
             6:Kach:=Kach+120;
             end;
         If (X=4) or (X=5) then
           begin
           Kach:=Kach+5;
           end;
         While Hod<> nil do
           begin
           Hod.SchitatHod(X,Y,Napad,NFigyra);
           NDosk.ClearKletka(X,Y,PFigyra.prenadl,Tip,NFigyra);
           If Napad<>1 then
           begin
           If Tip=1 then
             Case NFigyra.tip of
               'p':Kach:=Kach+5*(Line+1);
               's':Kach:=Kach+20;
               'k':Kach:=Kach+20;
               'l':Kach:=Kach+15;
               'f':Kach:=Kach+15;
             end;
           If Tip=2 then
             Case NFigyra.tip of
               'p':Kach:=Kach+3*(6-Line);
               's':Kach:=Kach+20;
               'k':Kach:=Kach+20;
               'l':Kach:=Kach+40;
               'f':Kach:=Kach+50;
               'q':Kach:=Kach+110;
           end;
           end;
           Hod:=Hod.next;
           end;
         end;
    's': While Hod<>nil do
         begin
         Hod.SchitatHod(X,Y,Napad,NFigyra);
         NDosk.ClearKletka(X,Y,PFigyra.prenadl,Tip,NFigyra);
         If (Tip<>0) and (NFigyra.tip='p') then
           If PFigyra.prenadl=1 then
                  Line:=Y-2
               else
                  Line:=7-Y;
         if Tip=1 then
           Case NFigyra.tip of
               'p':Kach:=Kach+2*(Line+1);
               's':Kach:=Kach+40;
               'k':Kach:=Kach+30;
               'l':Kach:=Kach+25;
               'f':Kach:=Kach+25;
           End;
         if Tip=2 then
           Case NFigyra.tip of
               'p':Kach:=Kach+4*(Line+1);
               's':Kach:=Kach+30;
               'k':Kach:=Kach+30;
               'l':Kach:=Kach+35;
               'f':Kach:=Kach+40;
               'q':Kach:=Kach+100;
           end;
         Hod:=Hod.next;
         Kach:=Kach+2;
         end;
    'k': While Hod<>nil do
         begin
         Hod.SchitatHod(X,Y,Napad,NFigyra);
         NDosk.ClearKletka(X,Y,PFigyra.prenadl,Tip,NFigyra);
         If (Tip<>0) and (NFigyra.tip='p') then
           If PFigyra.prenadl=1 then
                  Line:=Y-2
               else
                  Line:=7-Y;
         if Tip=1 then
           Case NFigyra.tip of
               'p':Kach:=Kach+3*(Line+1);
               's':Kach:=Kach+10;
               'k':Kach:=Kach+25;
               'l':Kach:=Kach+25;
               'f':Kach:=Kach+20;
           End;
         if Tip=2 then
           Case NFigyra.tip of
               'p':Kach:=Kach+3*(Line+1);
               's':Kach:=Kach+30;
               'k':Kach:=Kach+40;
               'l':Kach:=Kach+45;
               'f':Kach:=Kach+55;
               'q':Kach:=Kach+120;
           end;
         Hod:=Hod.next;
         Kach:=Kach+4;
         end;
    'l': While Hod<>nil do
         begin
         Hod.SchitatHod(X,Y,Napad,NFigyra);
         NDosk.ClearKletka(X,Y,PFigyra.prenadl,Tip,NFigyra);
                 If (Tip<>0) and (NFigyra.tip='p') then
           If PFigyra.prenadl=1 then
                  Line:=Y-2
               else
                  Line:=7-Y;
         if Tip=1 then
           Case NFigyra.tip of
               'p':Kach:=Kach+1*(Line+1);
               's':Kach:=Kach+15;
               'k':Kach:=Kach+13;
               'l':Kach:=Kach+30;
               'f':Kach:=Kach+25;
           End;
         if Tip=2 then
           Case NFigyra.tip of
               'p':Kach:=Kach+2*(Line+1);
               's':Kach:=Kach+30;
               'k':Kach:=Kach+30;
               'l':Kach:=Kach+40;
               'f':Kach:=Kach+45;
               'q':Kach:=Kach+100;
           end;
         Hod:=Hod.next;
         Kach:=Kach+2;
         end;
    'f': While Hod<>nil do
         begin
         Hod.SchitatHod(X,Y,Napad,NFigyra);
         NDosk.ClearKletka(X,Y,PFigyra.prenadl,Tip,NFigyra);
                 If (Tip<>0) and (NFigyra.tip='p') then
           If PFigyra.prenadl=1 then
                  Line:=Y-2
               else
                  Line:=7-Y;
         if Tip=1 then
           Case NFigyra.tip of
               'p':Kach:=Kach+(Line+1);
               's':Kach:=Kach+10;
               'k':Kach:=Kach+10;
               'l':Kach:=Kach+20;
               'f':Kach:=Kach+30;
           End;
         if Tip=2 then
           Case NFigyra.tip of
               'p':Kach:=Kach+1*(Line+1);
               's':Kach:=Kach+20;
               'k':Kach:=Kach+25;
               'l':Kach:=Kach+30;
               'f':Kach:=Kach+40;
               'q':Kach:=Kach+110;
           end;
         Hod:=Hod.next;
         Kach:=Kach+1;
         end;
    'q': While Hod<>nil do
         begin
                  Hod.SchitatHod(X,Y,Napad,NFigyra);
         NDosk.ClearKletka(X,Y,PFigyra.prenadl,Tip,NFigyra);
                 If (Tip<>0) and (NFigyra.tip='p') then
           If PFigyra.prenadl=1 then
                  Line:=Y-2
               else
                  Line:=7-Y;
         if Tip=1 then
           Case NFigyra.tip of
               'p':Kach:=Kach+2*(Line+1);
               's':Kach:=Kach+5;
               'k':Kach:=Kach+10;
               'l':Kach:=Kach+2;
               'f':Kach:=Kach+1;
           End;
         if Tip=2 then
           Case NFigyra.tip of
               'p':Kach:=Kach+2*(Line+1);
               's':Kach:=Kach+50;
               'k':Kach:=Kach+60;
               'l':Kach:=Kach+70;
               'f':Kach:=Kach+100;
           end;
         Hod:=Hod.next;
         Kach:=Kach+1;
         end;
     end;
     Forma.DestroyDosk(NDosk);
  end;

Procedure ViborHod(HodTree:THodTree; var ViborHod:tHodTree);
  var
    n,k,i:word;
    CurHod:THodtree;
  begin
  CurHod:=Hodtree;
  n:=0;
  While CurHod<>nil do
    begin
    Inc(n);
    CurHod:=Curhod.Brother;
    end;
  K:=Random(n);
  CurHod:=HodTree;
  For i:=1 to k do
    Curhod:=Curhod.Brother;
  ViborHod:=CurHod;
  end;

Procedure MaximalHod(Head:THodTree; ExtremMax:boolean; var MaxHod:THodTree);
  var
    CurHod,NewHod,Tophod:THodTree;
    MaxKach:Integer;
  begin
  MaxHod:=THodTree.Create;
  {Поиск лучшего хода}
  if ExtremMax then
    MaxKach:=-32000
  else
    MaxKach:=32000;
  CurHod:=Head;
  While CurHod<>nil do
    begin
    If ((ExtremMax) and (CurHod.KachYroven>MaxKach)) or ((not ExtremMax) and (CurHod.KachYroven<MaxKach)) then
      begin
      MaxKach:=CurHod.KachYroven;
      MaxHod.Xnat:=CurHod.Xnat;
      MaxHod.YNat:=CurHod.YNat;
      MaxHod.X:=CurHod.X;
      MaxHod.Y:=CurHod.Y;
      MaxHod.Tip:=CurHod.Tip;
      Maxhod.KachYroven:=CurHod.KachYroven;
      end;
    CurHod:=CurHod.Brother;
    end;
  {Добавление хороших ходов}
  TopHod:=MaxHod;
  CurHod:=Head;
  While CurHod<>nil do
    begin
    If (((ExtremMax) and (CurHod.KachYroven>MaxKach-par)) or
        ((not ExtremMax) and (CurHod.KachYroven<MaxKach+par))) and
        ( not((CurHod.X=MaxHod.X) and (CurHod.Y=MaxHod.Y) and (Curhod.Xnat=MaxHod.Xnat) and (CurHod.YNat=Maxhod.YNat) and (Curhod.Tip=maxHod.Tip))) then
      begin
      NewHod:=THodTree.Create;
      NewHod.Xnat:=CurHod.Xnat;
      NewHod.YNat:=CurHod.YNat;
      NewHod.X:=CurHod.X;
      NewHod.Y:=CurHod.Y;
      NewHod.Tip:=CurHod.Tip;
      Newhod.KachYroven:=CurHod.KachYroven;
      TopHod.Brother:=NewHod;
      Tophod:=NewHod;
      end;
    CurHod:=CurHod.Brother;
    end;
  end;

Procedure DelHod(var Hod:THod);
  var
  CurHod,DelHod,PredHod:THod;
  X,Y,Napad,tip:byte;
  Figyra:TFigyra;
  begin
  CurHod:=Hod;
  PredHod:=nil;
  While CurHod<>nil do
    begin
    CurHod.SchitatHod(X,Y,NApad,Figyra);
    NewDosk.ClearKletka(X,Y,NewKomand,Tip,Figyra);
    If (Tip=1) or ((Napad=2) and (tip<>2)) then
      {Удаление хода}
      begin
      DelHod:=CurHod;
      if CurHod=hod then
        begin
        CurHod:=curHod.next;
        Hod:=CurHod;
        end
      else
        begin
        PredHod.next:=CurHod.next;
        CurHod:=CurHod.next;
        end;
      DelHod.next:=nil;
      DelHod.Destroy;
      end
    else
      begin
      PredHod:=CurHod;
      Curhod:=CurHod.next;
      end;
    end;
  end;

Constructor THodTree.Create;
  begin
  Brother:=nil;
  Father:=Nil;
  Child:=Nil;
  end;

Procedure AddHod(FatherHod:THodTree; var NewHod:THodTree);
  var
    CurHod:THodTree;
  begin
  NewHod:=THodTree.Create;
  NewHod.Father:=FatherHod;
  if FatherHod.Child<>nil then
    begin
    CurHod:=FatherHod.Child;
    While CurHod.Brother<>nil do
      CurHod:=CurHod.Brother;
    CurHod.Brother:=NewHod;
    end
  else
    FatherHod.Child:=NewHod;
  end;

Procedure SearchMaks(Fatherhod:THodTree; var Maks:LongInt; var MaksHod:THodTree);
  var
    CurHod:THodTree;
  begin
    Maks:=-32000;
    CurHod:=FatherHod.Child;
    While CurHod<>nil do
      begin
      If (Abs(CurHod.KachYroven)>Maks) then
        begin
        Maks:=Abs(Curhod.KachYroven);
        MaksHod:=Curhod;
        end;
      CurHod:=CurHod.Brother;
      end;
  end;

Procedure Perestryktyrirovat(Hod:THodTree);
  var
    DelHod,CurHod,FatherHod:THodTree;
    l:byte;
    St,St1:string;
  begin
  Form1.MTest1.Clear;
  Form1.MTest2.Clear;
  CurHod:=Head;
  l:=0;
  While CurHod<>nil do
    begin
    If (CurHod=Hod) and (l=1) then
      CurHod:=CurHod.Brother;
    if Curhod<>nil then begin
    If CurHod.Child<>nil then
      begin
      CurHod:=CurHod.Child;
      Inc(l);
      end;
    if (CurHod.Child=nil) then
      begin
      If (CurHod=Hod) and (l=1) then
        CurHod:=CurHod.Brother;
      If CurHod<>nil then begin
      DelHod:=CurHod;
      if CurHod.Brother<>nil then
        begin
        Curhod:=CurHod.Brother;
        end
      else
        begin
        Dec(l);
        CurHod:=CurHod.Father;
        If CurHod<>nil then
          CurHod.Child:=nil;
        end;
      {удаление}
{      FatherHod:=DelHod.Father;
      If FatherHod<>nil then
        FatherHod.Child:=nil;   }
      DelHod.Father:=nil;
      DelHod.Brother:=nil;
      DelHod.Child:=nil;
      DelHod.Free;
      end;
      end;
      end;
    end;
  Head:=THodTree.Create;
  Head.Child:=Hod.Child;
  Hod.Child:=nil;
  Hod.Brother:=nil;
  Hod.Father:=nil;
  Hod.Free;
  CurHod:=Head.Child;
  While CurHod<>nil do
    begin
    CurHod.Father:=Head;
    CurHod:=CurHod.Brother;
    end;
  end;

Procedure PoiskMaksim;
  var
  Maks:longint;
  CurTree:THodTree;
  MaksHod:THodTree;
  begin
  CurTree:=Head;
  repeat
  If (CurTree.Child<>nil) then
    begin
    CurTree:=CurTree.Child;
    end;
  If (CurTree.Child=nil) and (CurTree.Brother<>nil) then
    begin
    CurTree:=CurTree.Brother;
    end;
  If (CurTree.Child=nil) and (CurTree.Brother=nil) then
    begin
    If CurTree<>Head then
      begin
      CurTree:=CurTree.Father;
      SearchMaks(CurTree,Maks,MaksHod);
      CurTree.KachYroven:=CurTree.Kach+MaksHod.KachYroven;
      end;
    while (CurTree<>Head) and(CurTree.Brother=nil) do
      begin
      CurTree:=CurTree.Father;
      SearchMaks(CurTree,Maks,MaksHod);
      CurTree.KachYroven:=CurTree.Kach+MaksHod.KachYroven;
      end;
    If CurTree=Head then
      begin
      SearchMaks(CurTree,Maks,MaksHod);
      CurTree.KachYroven:=CurTree.Kach+Maks;
      end;
    If (CurTree<>Head) then
      CurTree:=CurTree.Brother;
    end;
  until CurTree=Head;
  end;

Procedure VitHod(Hod:THod; var HodTree:THodTree);
  var
  X,Y,NX,Ny,napad:byte;
  Figyra:TFigyra;
  begin
  if Hod<>nil then begin
  Hod.SchitatHod(NX,Ny,napad,figyra);
  HodTree:=Head.Child;
  While (HodTree<>nil) do
    begin
    If (HodTree.X=NX) and (HodTree.Y=NY) and (Hod.tip=HodTree.Tip) then
      Break;
    HodTree:=HodTree.Brother;
    end;
  end;
  end;

end.

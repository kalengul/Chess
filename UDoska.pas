unit UDoska;

interface

uses Windows,Graphics,UFigyre;

type

  TFigyraList = class  {Список фигур на поле}
    NextFigyra:TFigyraList;  {Указатель на следующую фигуру}
    DeisFigyra:TFigyra; {Для интелекта}
    Figyra:TFigyra;    {Указатель на фигуру}
    Constructor CreateElList(NewFigyra:TFigyra); {Создание новой фигуры}
    end;

  TSoperniki = class   {Соперники}
               FigyraList:TFigyraList; {Указатель на список фигур соперника}
               HodList:THod;
               Rokirovka:Byte;
               NextSop:TSoperniki;      {Указатель на следующего сопреника}
               Constructor CreateList(NewFigyraList:TFigyraList); {Создание соперника}
               end;

  TDoska = class            {Доска}
    Sop:TSoperniki;         {Соперники}
    Del:TSoperniki;
    Constructor Create;   {Создать Доску}
    procedure Draw(ACol,ARow:integer; Rect: TRect; Canvas:TCanvas); {Нарисовать доску}
    Procedure DrawAllFigyre(Canvas:TCanvas; Sop:TSoperniki);
    Procedure ClearKletka(x,y:byte; komand:byte; var tip:byte; var Figyra:TFigyra);
    Procedure KillFigyre(x,y:byte);
    Procedure ListHodov(PoiskFigyra:TFigyra; var Hod:THod);
    Procedure ListAllHodov(PoiskFigyraList:TFigyraList; var Hod:THod);
    Procedure HodPeshki(PoiskFigyra:TFigyra; k:shortint; var Hod,TopHod:THod);
    Procedure HodLine(PoiskFigyra:TFigyra; kx,ky:shortint; var Hod,TopHod:THod);
    Procedure HodKletka(PoiskFigyra:TFigyra; kx,ky,ShagX,ShagY:shortint; var Hod,TopHod:THod; var svobod:byte);
    Procedure HodShah(var FigyraList,ProtFigyraList:TFigyraList; var Hod:THod);
    procedure ListHodovFigyreShah(Figyra:TFigyra; var FigyraList,ProtFigyraList:TFigyraList; var Hod:THod);
    Procedure DelShah(Korol:TFigyra; Var Hod:THod);
    end;


  Var
    HeadFigyraList,
    TopFigyraList,
    CurrentFigyraList:TFigyraList;
    Dosk:TDoska;

implementation

uses Forma,UIntel;

Constructor TFigyraList.CreateElList(NewFigyra:TFigyra);
  begin
  NextFigyra:=nil;
  Figyra:=NewFigyra;
  DeisFigyra:=Figyra;  
  end;

Constructor TSoperniki.CreateList(NewFigyraList:TFigyraList);
  begin
  NextSop:=nil;
  FigyraList:=NewFigyraList;
  end;

Constructor TDoska.Create;
  begin
  Sop:=Nil;
  end;

Procedure TDoska.DrawAllFigyre(Canvas:TCanvas; Sop:TSoperniki);
  var
    PoiskFigyraList:TFigyraList;
    Rect: TRect;
  begin
  {Пробегаем все фигуры}
  If Dosk.Sop<>nil then
  begin
  PoiskFigyraList:=Sop.FigyraList;
  While (PoiskFigyraList<>nil) do
    begin
    Rect.Left:=(PoiskFigyraList.Figyra.x-1)*61+20;
    Rect.Right:=PoiskFigyraList.Figyra.x*61+20;
    Rect.Top:=(PoiskFigyraList.Figyra.y-1)*61+20;
    Rect.Bottom:=PoiskFigyraList.Figyra.y*61+20;
    PoiskFigyraList.Figyra.Draw(rect,canvas);
    PoiskFigyraList:=PoiskFigyraList.NextFigyra;
    end;
  PoiskFigyraList:=Sop.NextSop.FigyraList;
  While (PoiskFigyraList<>nil) do
    begin
    Rect.Left:=(PoiskFigyraList.Figyra.x-1)*61+20;
    Rect.Right:=PoiskFigyraList.Figyra.x*61+20;
    Rect.Top:=(PoiskFigyraList.Figyra.y-1)*61+20;
    Rect.Bottom:=PoiskFigyraList.Figyra.y*61+20;
    PoiskFigyraList.Figyra.Draw(rect,canvas);
    PoiskFigyraList:=PoiskFigyraList.NextFigyra;
    end;
  End;
  end;

procedure TDoska.Draw(ACol,ARow:integer; Rect: TRect; Canvas:TCanvas);
  var
    PoiskFigyraList:TFigyraList;
  begin
  If ((ACol+ARow) mod 2 = 0) then
    begin
    Canvas.Brush.Color:=ClMaroon;
    Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
    end
  else
    begin
    Canvas.Brush.Color:=clInfoBk;
    Canvas.Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
    end;
  end;

Procedure TDoska.ClearKletka(x,y:byte; komand:byte; var tip:byte; var Figyra:TFigyra);
  var
    CurrentFigyraList:TFigyraList;
  begin
    if (X>8) or (y>8) or (X<1) or (Y<1) then
      begin
      Tip:=1;
      Figyra:=nil;
      end
    else
    begin
    tip:=0;
    CurrentFigyraList:=Sop.FigyraList;
    While (CurrentFigyraList<>nil) and not ((CurrentFigyraList.Figyra.x=x) and (CurrentFigyraList.Figyra.y=y)) do
      CurrentFigyraList:=CurrentFigyraList.NextFigyra;
    if CurrentFigyraList<>nil then
      begin
      if komand=1 then
        begin
        tip:=1;
        Figyra:=CurrentFigyraList.Figyra;
        end
      else
        begin
        tip:=2;
        Figyra:=CurrentFigyraList.Figyra;
        end;
      end;
    CurrentFigyraList:=Sop.NextSop.FigyraList;
    While (tip=0) and (CurrentFigyraList<>nil) and not ((CurrentFigyraList.Figyra.x=x) and (CurrentFigyraList.Figyra.y=y)) do
      CurrentFigyraList:=CurrentFigyraList.NextFigyra;
    if (CurrentFigyraList<>nil) and (tip=0) then
      begin
      if komand=2 then
        begin
        tip:=1;
        Figyra:=CurrentFigyraList.Figyra;
        end
      else
        begin
        tip:=2;
        Figyra:=CurrentFigyraList.Figyra;
        end;
      end;
    end;
  end;

Procedure TDoska.KillFigyre(x,y:byte);
  var
    CurrentFigyraList,PredFigyraList,DelFigyraList:TFigyraList;
    komand:byte;
    NewDel:TSoperniki;
  begin
  {Поиск удаляемой фигуры}
  komand:=1;
  PredFigyraList:=nil;
  DelFigyraList:=Sop.FigyraList;
  While (DelFigyraList<>nil) and not ((DelFigyraList.Figyra.x=x) and (DElFigyraList.Figyra.y=y)) do
    begin
    PredFigyraList:=DelFigyraList;
    DelFigyraList:=DelFigyraList.NextFigyra;
    end;
  if DelFigyraList=nil then
    begin
    komand:=2;
    PredFigyraList:=nil;
    DelFigyraList:=Sop.NextSop.FigyraList;
    While (DelFigyraList<>nil) and not ((DelFigyraList.Figyra.x=x) and (DelFigyraList.Figyra.y=y)) do
      begin
      PredFigyraList:=DelFigyraList;
      DelFigyraList:=DelFigyraList.NextFigyra;
      end;
    end;
  {Удаление фигуры с доски}
  if PredFigyraList<>nil then
    begin
    PredFigyraList.NextFigyra:=DelFigyraList.NextFigyra;
    DelFigyraList.NextFigyra:=nil;
    end
  else
    begin
    Case Komand of
      1:Sop.FigyraList:=Sop.FigyraList.NextFigyra;
      2:Sop.NextSop.FigyraList:=Sop.NextSop.FigyraList.NextFigyra;
      end;
    DelFigyraList.NextFigyra:=nil;
    end;
  {Добавление фигуры в список съеденных}
  If Del<>nil then
    begin
    case komand of
      1:CurrentFigyraList:=Del.FigyraList;
      2:CurrentFigyraList:=Del.NextSop.FigyraList;
      end;
    If CurrentFigyraList<>nil then
      begin
      While CurrentFigyraList.NextFigyra<>nil do
        CurrentFigyraList:=CurrentFigyraList.NextFigyra;
      CurrentFigyraList.NextFigyra:=DelFigyralist;
      end
    else
      begin
      CurrentFigyraList:=DelFigyraList;
      case komand of
        1:Del.FigyraList:=DelFigyraList;
        2:Del.NextSop.FigyraList:=DelFigyraList;
        end;
      end;
    end
  else
    begin
    Case Komand Of
      1:begin
        NewDel:=TSoperniki.CreateList(DelFigyraList);
        Del:=NewDel;
        NewDel:=TSoperniki.CreateList(nil);
        Del.NextSop:=NewDel;
        end;
      2:begin
        NewDel:=TSoperniki.CreateList(nil);
        Del:=NewDel;
        NewDel:=TSoperniki.CreateList(DelFigyraList);
        Del.NextSop:=NewDel;
        end;
    end;
    end;
  end;

Procedure TDoska.HodPeshki(PoiskFigyra:TFigyra; k:shortint; var Hod,TopHod:THod);
  var
    NewHod:THod;
    Svobod:byte;
    ProtFigyra:TFigyra;
  begin
  ClearKletka(PoiskFigyra.x+1,PoiskFigyra.y+1*k,PoiskFigyra.prenadl,svobod,ProtFigyra);
  If (Svobod=2) or (((Svobod=1) or (Svobod=0))and (PoiskFigyra.x+1<=8) and (PoiskFigyra.x+1>=1)
                              and (PoiskFigyra.y+1*k<=8) and (PoiskFigyra.y+1*k>=1)) then
    begin
    NewHod:=THod.Create;
    IF (Svobod=2) or (Svobod=1) then
      NewHod.YstanovitHod(PoiskFigyra.x+1,PoiskFigyra.y+1*k,3,ProtFigyra,'p')
    else
      NewHod.YstanovitHod(PoiskFigyra.x+1,PoiskFigyra.y+1*k,2,ProtFigyra,'p');
    if Hod<>nil then
      begin
      TopHod.next:=NewHod;
      TopHod:=NewHod;
      end
    else
      begin
      Hod:=NewHod;
      TopHod:=Hod;
      end;
    end;
  ClearKletka(PoiskFigyra.x-1,PoiskFigyra.y+1*k,PoiskFigyra.prenadl,svobod,ProtFigyra);
  If (Svobod=2) or (((Svobod=1) or (Svobod=0)) and (PoiskFigyra.x-1<=8) and (PoiskFigyra.x-1>=1)
                              and (PoiskFigyra.y+1*k<=8) and (PoiskFigyra.y+1*k>=1)) then
    begin
    NewHod:=THod.Create;
    IF (Svobod=2) or (Svobod=1) then
      NewHod.YstanovitHod(PoiskFigyra.x-1,PoiskFigyra.y+1*k,3,ProtFigyra,'p')
    else
      NewHod.YstanovitHod(PoiskFigyra.x-1,PoiskFigyra.y+1*k,2,ProtFigyra,'p');
    if Hod<>nil then
      begin
      TopHod.next:=NewHod;
      TopHod:=NewHod;
      end
    else
      begin
      Hod:=NewHod;
      TopHod:=Hod;
      end;
    end;
  ClearKletka(PoiskFigyra.x,PoiskFigyra.y+1*k,PoiskFigyra.prenadl,svobod,ProtFigyra);
  if (Svobod=0) then
    begin
    NewHod:=THod.Create;
    NewHod.YstanovitHod(PoiskFigyra.x,PoiskFigyra.y+1*k,1,ProtFigyra,'p');
    if Hod<>nil then
      begin
      TopHod.next:=NewHod;
      TopHod:=NewHod;
      end
    else
      begin
      Hod:=NewHod;
      TopHod:=Hod;
      end;
    end;
  if (Svobod<>1) and (Svobod<>2) and (PoiskFigyra.y+1*k<>8) and (PoiskFigyra.y+1*k<>1) and ((PoiskFigyra.y=2) or (PoiskFigyra.y=7))then
    begin
    ClearKletka(PoiskFigyra.x,PoiskFigyra.y+2*k,PoiskFigyra.prenadl,svobod,ProtFigyra);
    if (Svobod=0) then
      begin
      NewHod:=THod.Create;
      NewHod.YstanovitHod(PoiskFigyra.x,PoiskFigyra.y+2*k,1,ProtFigyra,'p');
      TopHod.next:=NewHod;
      TopHod:=NewHod;
      end;
    end;
  end;

procedure TDoska.HodKletka(PoiskFigyra:TFigyra; kx,ky,ShagX,ShagY:shortint; var Hod,TopHod:THod; var svobod:byte);
  var
    NewHod:THod;
    ProtFigyra:TFigyra;
  begin
  ClearKletka(PoiskFigyra.x+kx*Shagx,PoiskFigyra.y+ky*ShagY,PoiskFigyra.prenadl,svobod,ProtFigyra);
  If  (Svobod=0) or (svobod=2) or ((Svobod=1) and (PoiskFigyra.x+kx*Shagx<=8) and (PoiskFigyra.x+kx*Shagx>=1)
                                              and (PoiskFigyra.y+ky*ShagY<=8) and (PoiskFigyra.y+ky*ShagY>=1)) then
    begin
    NewHod:=THod.Create;
    NewHod.YstanovitHod(PoiskFigyra.x+kx*Shagx,PoiskFigyra.y+ky*ShagY,3,ProtFigyra,PoiskFigyra.tip);
    if Hod=nil then
      begin
      Hod:=NewHod;
      TopHod:=Hod;
      end
    else
      begin
      TopHod.next:=NewHod;
      TopHod:=NewHod;
      end;
    end;
  end;

Procedure TDoska.HodLine(PoiskFigyra:TFigyra; kx,ky:shortint; var Hod,TopHod:THod);
  var
    ShagX,ShagY,Svobod:byte;
  begin
  ShagX:=1;
  ShagY:=1;
  repeat
    HodKletka(PoiskFigyra,kx,ky,ShagX,ShagY,Hod,TopHod,Svobod);
    inc(ShagX);
    inc(ShagY);
  until (Svobod=1) or (Svobod=2) or ((kx<>0) and ((PoiskFigyra.x+kx*Shagx>8) or (PoiskFigyra.x+kx*Shagx<1))) or
        ((Ky<>0) and ((PoiskFigyra.y+ky*ShagY>8) or (PoiskFigyra.y+ky*ShagY<1)));
  end;

Procedure TDoska.DelShah(Korol:TFigyra; Var Hod:THod);
  var
    CurListHod,CurHod,PredHod:THod;
    PosX,PosY,VozX,VozY,Napad:byte;
    Figyra:TFigyra;
  begin
  if komand=1 then
    CurListHod:=Sop.NextSop.HodList
  else
    CurListHod:=Sop.HodList;
    {Идем по всем возможным ходам противника}
  While CurListHod<>nil do
    begin
    CurListHod.SchitatHod(VozX,VozY,Napad,Figyra);
      if napad<>1 then
      begin
      PredHod:=Nil;
      CurHod:=Hod;
      {Проходим по всем возможным ходам короля}
      While (CurHod<>nil) do
        begin
        CurHod.SchitatHod(PosX,PosY,Napad,Figyra);
        {Если поле бьется}
        If (PosX=VozX) and (PosY=VozY) then
          break;
        PredHod:=CurHod;
        CurHod:=CurHod.next;
        end;  {Проход по всем возможным ходам}
      {Удаляем битое поле из списка ходов короля}
      If (CurHod<>nil) and (PosX=VozX) and (PosY=VozY) then
        begin
        CurHod.YstanovitHod(VozX,VozY,2,Figyra,'q');
        {Если есть поле шаховое}
        if (((PosX=6) or (PosX=4) or (PosX=3)) and
           ((PosY=1) or (PosY=8))) and
          (((Korol.prenadl=1) and (Dosk.Sop.Rokirovka<>0))
          or ((Korol.prenadl=2) and (Dosk.Sop.NextSop.Rokirovka<>0))) then
          begin
          CurHod:=Hod;
          While (CurHod<>nil) do
            begin
            CurHod.SchitatHod(VozX,VozY,Napad,Figyra);
            if (((posX=6) and (VozX=7)) or (((posX=4) or (PosX=3)) and (VozX=3)) ) and ((VozY=1) or (VozY=8)) then
              CurHod.YstanovitHod(VozX,VozY,0,Figyra,'q');
            CurHod:=CurHod.next;
            end;
          end;
        end;    {Удалили поле}
        {Проверка на шах}
      end;  {Napad}
      CurListHod:=CurListHod.next;
      end;   {Проход по всем ходам противника}
  if (Form1.LbHax.Caption='Шах') and
     (((Korol.prenadl=1) and (Dosk.Sop.Rokirovka<>0))
      or ((Korol.prenadl=2) and (Dosk.Sop.NextSop.Rokirovka<>0))) then
     begin
     CurHod:=Hod;
     While (CurHod<>nil) do
       begin
       CurHod.SchitatHod(VozX,VozY,Napad,Figyra);
       if (VozX=7) or (VozX=3) then
         CurHod.YstanovitHod(VozX,VozY,0,Figyra,'q');
       CurHod:=CurHod.next;
       end;
    end;
  end;

Procedure TDoska.ListHodov(PoiskFigyra:TFigyra; var Hod:THod);
  var
    TopHod:THod;
    svobod:byte;
    RokHod,TopRokHod,Buf,BufTop,TopHodKor,HodKor:THod;
    Test:THod;
    st1,st2,st:String;
    a,s,d,g:byte;
    f:TFigyra;
  begin
  Hod:=nil;
  Case PoiskFigyra.tip of
    'p':begin
        Case PoiskFigyra.prenadl of
          1:HodPeshki(PoiskFigyra,1,hod,TopHod);
          2:HodPeshki(PoiskFigyra,-1,hod,TopHod);
          end;
        end;
    'l':begin
        HodLine(PoiskFigyra,1,0,hod,TopHod);
        HodLine(PoiskFigyra,-1,0,hod,TopHod);
        HodLine(PoiskFigyra,0,1,hod,TopHod);
        HodLine(PoiskFigyra,0,-1,hod,TopHod);
        end;
    'k':begin
        HodKletka(PoiskFigyra,1,1,2,1,Hod,TopHod,Svobod);
        HodKletka(PoiskFigyra,1,1,2,-1,Hod,TopHod,Svobod);
        HodKletka(PoiskFigyra,1,1,1,2,Hod,TopHod,Svobod);
        HodKletka(PoiskFigyra,1,1,-1,2,Hod,TopHod,Svobod);
        HodKletka(PoiskFigyra,1,1,-2,1,Hod,TopHod,Svobod);
        HodKletka(PoiskFigyra,1,1,-2,-1,Hod,TopHod,Svobod);
        HodKletka(PoiskFigyra,1,1,1,-2,Hod,TopHod,Svobod);
        HodKletka(PoiskFigyra,1,1,-1,-2,Hod,TopHod,Svobod);
        end;
    's':begin
        HodLine(PoiskFigyra,1,1,hod,TopHod);
        HodLine(PoiskFigyra,-1,1,hod,TopHod);
        HodLine(PoiskFigyra,1,-1,hod,TopHod);
        HodLine(PoiskFigyra,-1,-1,hod,TopHod);
        end;
    'f':begin
        HodLine(PoiskFigyra,1,0,hod,TopHod);
        HodLine(PoiskFigyra,-1,0,hod,TopHod);
        HodLine(PoiskFigyra,0,1,hod,TopHod);
        HodLine(PoiskFigyra,0,-1,hod,TopHod);
        HodLine(PoiskFigyra,1,1,hod,TopHod);
        HodLine(PoiskFigyra,-1,1,hod,TopHod);
        HodLine(PoiskFigyra,1,-1,hod,TopHod);
        HodLine(PoiskFigyra,-1,-1,hod,TopHod);
        end;
    'q':begin
        HodKor:=nil;
        TopHodKor:=nil;
        HodKletka(PoiskFigyra,1,1,1,0,HodKor,TopHodKor,Svobod);
        {Короткая рокировка}
        if PoiskFigyra.prenadl=1 then
          begin
          If ((Sop.Rokirovka=3) or (Sop.Rokirovka=1)) and (Svobod=0) then
            begin
            RokHod:=nil;
            TopRokHod:=nil;
            HodKletka(PoiskFigyra,1,1,2,0,RokHod,TopRokHod,svobod);
            if Svobod=0 then
              begin
              TopHodKor.next:=RokHod;
              TopHodKor:=TopRokHod;
              end;
            end;
          end
        else
          begin
          If ((Sop.NextSop.Rokirovka=3) or (Sop.NextSop.Rokirovka=1)) and (Svobod=0) then
            begin
            RokHod:=nil;
            TopRokHod:=nil;
            HodKletka(PoiskFigyra,1,1,2,0,RokHod,TopRokHod,Svobod);
            if Svobod=0 then
              begin
              TopHodKor.next:=RokHod;
              TopHodKor:=TopRokHod;
              end;
            end;
          end;
        HodKletka(PoiskFigyra,1,1,1,1,HodKor,TopHodKor,Svobod);
        HodKletka(PoiskFigyra,1,1,1,-1,HodKor,TopHodKor,Svobod);
        HodKletka(PoiskFigyra,1,1,0,-1,HodKor,TopHodKor,Svobod);
        HodKletka(PoiskFigyra,1,1,0,1,HodKor,TopHodKor,Svobod);
        HodKletka(PoiskFigyra,1,1,-1,0,HodKor,TopHodKor,Svobod);
        {длинная рокировка}
        if PoiskFigyra.prenadl=1 then
          begin
          If ((Sop.Rokirovka=3) or (Sop.Rokirovka=2)) and (Svobod=0) then
            begin
            RokHod:=nil;
            TopRokHod:=nil;
            HodKletka(PoiskFigyra,1,1,-2,0,RokHod,TopRokHod,svobod);
            if svobod=0 then
              begin
              Buf:=nil;
              BufTop:=nil;
              HodKletka(PoiskFigyra,1,1,-3,0,Buf,BufTop,svobod);
              if Svobod=0 then
                begin
                TopHodKor.next:=RokHod;
                TopHodKor:=TopRokHod;
                end;
              end;
            end;
          end
        else
          begin
          If ((Sop.NextSop.Rokirovka=3) or (Sop.NextSop.Rokirovka=2)) and (Svobod=0) then
            begin
            RokHod:=nil;
            TopRokHod:=nil;
            HodKletka(PoiskFigyra,1,1,-2,0,RokHod,TopRokHod,Svobod);
            if svobod=0 then
              begin
              Buf:=nil;
              BufTop:=nil;
              HodKletka(PoiskFigyra,1,1,-3,0,Buf,BufTop,svobod);
              if Svobod=0 then
                begin
                TopHodKor.next:=RokHod;
                TopHodKor:=TopRokHod;
                end;
              end;
            end;
          end;
        HodKletka(PoiskFigyra,1,1,-1,1,HodKor,TopHodKor,Svobod);
        HodKletka(PoiskFigyra,1,1,-1,-1,HodKor,TopHodKor,Svobod);
        DelShah(PoiskFigyra,hodKor);
        If Hod=nil then
          begin
          Hod:=HodKor;
          TopHod:=TopHodKor;
          end
        else
          begin
          TopHod.next:=HodKor;
          TopHod:=TopHodKor;
          end;
        end;
    end;
  end;

Procedure TDoska.ListAllHodov(PoiskFigyraList:TFigyraList; var Hod:THod);
  var
    TopHod,NewHod:THod;
    PoiskFigyra:TFigyra;
  begin
  Hod:=nil;
  While PoiskFigyraList<>nil do
  begin
  PoiskFigyra:=PoiskFigyraList.Figyra;
  ListHodov(PoiskFigyra,NewHod);
  If Hod=nil then
    begin
    Hod:=Newhod;
    TopHod:=Hod;
    end
  else
    begin
    TopHod.next:=NewHod;
    While TopHod.next<>nil do
      TopHod:=TopHod.next;
    end;
  PoiskFigyraList:=PoiskFigyraList.NextFigyra;
  end;
  end;



procedure TDoska.ListHodovFigyreShah(Figyra:TFigyra; var FigyraList,ProtFigyraList:TFigyraList; var Hod:THod);
  var
    PredList,CurList,DelList:TFigyraList;
    CurHod,PredHod,DelHod:THod;
    NewHodProt:THod;
    PosX,PosY,NPosX,NPosY,Napad,Tip:byte;
    FigyraProt:TFigyra;
        Test:THod;
        a,s,d:Byte;
    f:TFigyra;
    st,st1:string;
  begin
  NPosX:=Figyra.x;
  NPosY:=Figyra.y;
  {Получить список ходов}
  ListHodov(Figyra,Hod);
{          Form1.MTest1.Clear;
      Test:=Hod;
      While Test<>nil do
        begin
        Test.SchitatHod(a,s,d,f);
        Str(s,st);
        Str(d,st1);
        st:=Kletka[a]+' '+st+' '+st1;
        Form1.MTest1.Lines.Add(st);
        Test:=Test.next;
        end;
  {Проверить список ходов}
  PredHod:=nil;
  CurHod:=Hod;
  While CurHod<>nil do
    begin
    CurHod.SchitatHod(PosX,PosY,Napad,FigyraProt);
    ClearKletka(PosX,PosY,Forma.komand,tip,FigyraProt);
    {Удаление фигуры}
    DelList:=nil;
    If (Napad<>1) and (Tip=2) {and (Forma.komand=Figyra.prenadl) }then
      begin
      PredList:=nil;
      CurList:=ProtFigyraList;
      While  (CurList<>nil) and (not ((CurList.Figyra.x=PosX) and (CurList.Figyra.y=PosY)))do
        begin
        PredList:=CurList;
        CurList:=CurList.NextFigyra;
        end;
      if CurList<>nil then  
      if PredList=nil then
        begin
        DelList:=CurList;
        CurList:=CurList.NextFigyra;
        ProtFigyraList:=CurList;
        end
      else
        begin
        DelList:=CurList;
        PredList.NextFigyra:=CurList.NextFigyra;
        CurList:=PredList.NextFigyra;
        end;
      end;
    {Перемещаем фигуру на новый возможный ход}
    if (Napad<>2) and (tip<>1) then
      Figyra.Ystanovit(PosX,PosY);
    ListAllHodov(ProtFigyraList,NewHodProt);
    {Проверяем на шах}
    if Forma.ProverkaNaShah(FigyraList,NewHodProt) then
       begin
      {Удаляем ход}
       if PredHod=nil then
         begin
         delHod:=CurHod;
         CurHod:=CurHod.next;
         Hod:=CurHod;
         DelHod.Destroy;
         end
       else
         begin
         PredHod.next:=CurHod.next;
         DelHod:=CurHod;
         CurHod:=CurHod.next;
         DelHod.Destroy;         
         end;
       end
     else
       begin
       {Переходим к следующему ходу}
       PredHod:=CurHod;
       CurHod:=CurHod.next;
       end;
    {Возвращаем фигуру на место}
    Figyra.Ystanovit(NPosX,NPosY);
    {Возвращаем фигуру противника}
    If DelList<>nil then
      begin
      CurList:=ProtFigyraList;
      if ProtFigyraList=nil then
        begin
        ProtFigyraList:=DelList;
        end
      else
        begin
        While CurList.NextFigyra<>nil do
          CurList:=CurList.NextFigyra;
        CurList.NextFigyra:=DelList;
        DelList.NextFigyra:=nil;
        end;
      end;
    end;
  end;

Procedure TDoska.HodShah(var FigyraList,ProtFigyraList:TFigyraList; var Hod:THod);
  var
    CurFigyraList,DelElFigyra,NewElFigyra:TFigyraList;
    CurHod,predHod,delhod,NewHodProt,FigyraHod:THod;
    FigyraProt,DelFigyra:Tfigyra;
    PosX,PosY,Napad,tip,NPosX,NPosY:byte;
  begin
    Hod:=nil;
    {Выбираем фигуру}
    CurFigyraList:=FigyraList;
    While CurFigyraList<> nil do
      begin
      ListHodovFigyreShah(CurFigyraList.Figyra,FigyraList,ProtFigyraList,FigyraHod);
     {Запоминаем список ходов}
     if FigyraHod<>nil then
     if hod=nil then
       Hod:=FigyraHod
     else
       begin
       CurHod:=Hod;
       While CurHod.next<>nil do
         CurHod:=CurHod.next;
       CurHod.next:=FigyraHod;
       end;
     {Переходим к следующей фигуре}
     CurFigyraList:=CurFigyraList.NextFigyra;
     end;
  end;

end.

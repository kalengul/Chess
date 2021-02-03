unit UFigyraNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids,UFigyre,Forma;

type
  TFFigyra = class(TForm)
    DgNewFigyre: TDrawGrid;
    procedure DgNewFigyreMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DgNewFigyreDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FFigyra: TFFigyra;
  Figyra:TFigyra;

implementation

{$R *.dfm}

procedure PaintFigyra;
  var
    rect:TRect;
    Figyra:TFigyra;
  begin
  Figyra:=TFigyra.Create('s',Komand);
  Rect.Left:=0;
  Rect.Right:=60;
  Rect.Top:=0;
  Rect.Bottom:=60;

  Figyra.Draw(rect,FFigyra.DgNewFigyre.Canvas);
  Figyra:=TFigyra.Create('k',Komand);
  Rect.Left:=61;
  Rect.Right:=121;
  Rect.Top:=0;
  Rect.Bottom:=61;
  Figyra.Draw(rect,FFigyra.DgNewFigyre.Canvas);

  Figyra:=TFigyra.Create('l',Komand);
  Rect.Left:=122;
  Rect.Right:=182;
  Rect.Top:=0;
  Rect.Bottom:=61;
  Figyra.Draw(rect,FFigyra.DgNewFigyre.Canvas);

  Figyra:=TFigyra.Create('f',Komand);
  Rect.Left:=183;
  Rect.Right:=243;
  Rect.Top:=0;
  Rect.Bottom:=61;
  Figyra.Draw(rect,FFigyra.DgNewFigyre.Canvas);

  if Forma.Form1.RgRastanovka.ItemIndex=1 then
    begin
    Figyra:=TFigyra.Create('p',Komand);
    Rect.Left:=0;
    Rect.Right:=60;
    Rect.Top:=61;
    Rect.Bottom:=121;
    Figyra.Draw(rect,FFigyra.DgNewFigyre.Canvas);    
    end;
  end;

procedure TFFigyra.DgNewFigyreMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  PosX,PosY:Byte;
  Exit:Boolean;
begin
  PaintFigyra;
  Exit:=False;
  PosX:=x div 61;
  PosY:=Y div 61;
  If (PosX=0) and (PosY=0) then
    begin
    Figyra:=TFigyra.Create('s',Forma.komand);
    Exit:=True;
    End;
  If (PosX=1) and (PosY=0) then
    begin
    Figyra:=TFigyra.Create('k',Forma.komand);
    Exit:=True;
    End;
  If (PosX=2) and (PosY=0) then
    begin
    Figyra:=TFigyra.Create('l',Forma.komand);
    Exit:=True;
    End;
  If (PosX=3) and (PosY=0) then
    begin
    Figyra:=TFigyra.Create('f',Forma.komand);
    Exit:=True;
    End;
  If (PosX=0) and (PosY=1) and (Forma.Form1.RgRastanovka.ItemIndex=1) then
    begin
    Figyra:=TFigyra.Create('p',Forma.komand);
    Exit:=True;
    End;
  If Exit then
    FFigyra.Close;
end;

procedure TFFigyra.DgNewFigyreDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
 PaintFigyra;
end;

end.

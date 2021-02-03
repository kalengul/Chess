program Chess;

uses
  Forms,
  Forma in 'Forma.pas' {Form1},
  UFigyre in 'UFigyre.pas',
  UDoska in 'UDoska.pas',
  UFigyraNew in 'UFigyraNew.pas' {FFigyra},
  UIntel in 'UIntel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFFigyra, FFigyra);
  Application.Run;
end.

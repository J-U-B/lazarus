program notifier;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, notifierform, notifierdatamodule, notifierguicontrol, notifier_json
  { you can add units after this };

{$R *.res}

begin
<<<<<<< .mine
  //Application.Scaled:=True;
=======
  Application.Scaled:=True;
>>>>>>> .theirs
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.


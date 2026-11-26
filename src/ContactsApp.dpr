program ContactsApp;

uses
  Vcl.Forms,
  uDM in 'uDM.pas',
  uMainForm in 'uMainForm.pas' {uMainForm},
  uAddPerson in 'uAddPerson.pas' {uAddPerson},
  uAddContact in 'uAddContact.pas' {uAddContact},
  uConsts in 'uConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

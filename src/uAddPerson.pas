unit uAddPerson;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TAddPersonForm = class(TForm)
    lblLastName: TLabel;
    edtLastName: TEdit;
    lblFirstName: TLabel;
    edtFirstName: TEdit;
    lblMiddleName: TLabel;
    edtMiddleName: TEdit;
    lblGender: TLabel;
    cbGender: TComboBox;
    lblBirthDate: TLabel;
    dtpBirthDate: TDateTimePicker;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    procedure InitCaptions;
  public
    function SelectedGender: string;
  end;

var
  AddPersonForm: TAddPersonForm;

implementation

uses
  uConsts;

{$R *.dfm}

procedure TAddPersonForm.InitCaptions;
const
  cDefaultGenderIdx = 0;
begin
  Caption := cAddPersonTitle;
  lblLastName.Caption := cLblLastName;
  lblFirstName.Caption := cLblFirstName;
  lblMiddleName.Caption := cLblMiddleName;
  lblGender.Caption := cLblGenderReq;
  lblBirthDate.Caption := cLblBirthDate;
  btnOk.Caption := cBtnSave;
  btnCancel.Caption := cBtnCancel;

  cbGender.Items.Clear;
  cbGender.Items.Add(cGenderMale);
  cbGender.Items.Add(cGenderFemale);
  cbGender.ItemIndex := cDefaultGenderIdx;
end;

procedure TAddPersonForm.FormCreate(Sender: TObject);
const
  cDefaultBirthYear  = 1990;
  cDefaultBirthMonth = 1;
  cDefaultBirthDay   = 1;
begin
  InitCaptions;
  dtpBirthDate.Date := EncodeDate(
    cDefaultBirthYear,
    cDefaultBirthMonth,
    cDefaultBirthDay
  );
  dtpBirthDate.MaxDate := Date;
end;

function TAddPersonForm.SelectedGender: string;
const
  cFemaleItemIdx = 1;
begin
  if cbGender.ItemIndex = cFemaleItemIdx then
    Result := 'F'
  else
    Result := 'M';
end;

procedure TAddPersonForm.btnOkClick(Sender: TObject);
begin
  if (Trim(edtLastName.Text) = '') or (Trim(edtFirstName.Text) = '') then
    begin
      ShowMessage(cMsgReqPersonFields);
      Exit;
    end;
  ModalResult := mrOk;
end;

end.


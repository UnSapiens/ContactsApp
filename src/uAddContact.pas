unit uAddContact;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.RegularExpressions,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.DBCtrls;

type
  TAddContactForm = class(TForm)
    lblType: TLabel;
    dblcbType: TDBLookupComboBox;
    lblValue: TLabel;
    edtValue: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dblcbTypeCloseUp(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    procedure InitCaptions;
    procedure UpdateValueMaxLength;
    function IsValidEmail(const AEmail: string): Boolean;
    function SelectedTypeCode: string;
  public
    function SelectedTypeID: Integer;
  end;

var
  AddContactForm: TAddContactForm;

implementation

uses
  uConsts,
  uDM;

{$R *.dfm}

const
  cContactCodeEmail = 'EMAIL';
  cContactCodePhone = 'PHONE';

procedure TAddContactForm.InitCaptions;
begin
  Caption := cAddContactTitle;
  lblType.Caption := cLblContactType;
  lblValue.Caption := cLblContactValue;
  btnOk.Caption := cBtnSave;
  btnCancel.Caption := cBtnCancel;
  edtValue.MaxLength := cMaxContactValueLen;
end;

procedure TAddContactForm.FormCreate(Sender: TObject);
begin
  InitCaptions;
  dblcbType.OnCloseUp := dblcbTypeCloseUp;
end;

procedure TAddContactForm.FormShow(Sender: TObject);
begin
  dblcbType.ListSource := DM.dsContactTypes;
  if not DM.qryContactTypes.IsEmpty then
    dblcbType.KeyValue := DM.qryContactTypes.FieldByName('ID').AsInteger;
  UpdateValueMaxLength;
end;

procedure TAddContactForm.dblcbTypeCloseUp(Sender: TObject);
begin
  UpdateValueMaxLength;
end;

procedure TAddContactForm.UpdateValueMaxLength;
begin
  if SelectedTypeCode = cContactCodePhone then
    begin
      edtValue.MaxLength := cMaxPhoneValueLen;
      if Length(edtValue.Text) > cMaxPhoneValueLen then
        edtValue.Text := Copy(edtValue.Text, 1, cMaxPhoneValueLen);
    end
  else
    edtValue.MaxLength := cMaxContactValueLen;
end;

function TAddContactForm.SelectedTypeID: Integer;
begin
  if VarIsNull(dblcbType.KeyValue) then
    Result := 0
  else
    Result := VarAsType(dblcbType.KeyValue, varInteger);
end;

function TAddContactForm.SelectedTypeCode: string;
begin
  Result := '';
  if (SelectedTypeID > 0) and (not DM.qryContactTypes.IsEmpty) then
    Result := Trim(DM.qryContactTypes.FieldByName('CODE').AsString);
end;

function TAddContactForm.IsValidEmail(const AEmail: string): Boolean;
const
  cEmailRegexPattern =
    '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
begin
  Result := TRegEx.IsMatch(Trim(AEmail), cEmailRegexPattern);
end;

procedure TAddContactForm.btnOkClick(Sender: TObject);
var
  ContactValue: string;
begin
  if SelectedTypeID <= 0 then
    begin
      ShowMessage(cMsgSelectContactType);
      Exit;
    end;

  ContactValue := Trim(edtValue.Text);
  if ContactValue = '' then
    begin
      ShowMessage(cMsgReqContactValue);
      edtValue.SetFocus;
      Exit;
    end;

  if (SelectedTypeCode = cContactCodeEmail) and
    (not IsValidEmail(ContactValue)) then
    begin
      ShowMessage(cMsgInvalidEmail);
      edtValue.SetFocus;
      Exit;
    end;

  ModalResult := mrOk;
end;

end.


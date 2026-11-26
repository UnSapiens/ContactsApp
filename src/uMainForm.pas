unit uMainForm;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Data.DB,
  Vcl.StdCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    pnlFilter: TPanel;
    lblGender: TLabel;
    cbGender: TComboBox;
    lblFio: TLabel;
    edtFio: TEdit;
    lblContact: TLabel;
    edtContact: TEdit;
    lblAge: TLabel;
    edtAge: TEdit;
    btnSearch: TButton;
    btnReset: TButton;
    pnlLeft: TPanel;
    pnlLeftTop: TPanel;
    lblPersonsTitle: TLabel;
    btnAddPerson: TButton;
    dbgPersons: TDBGrid;
    Splitter1: TSplitter;
    pnlRight: TPanel;
    pnlRightTop: TPanel;
    lblContactsTitle: TLabel;
    btnAddContact: TButton;
    dbgContacts: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure Splitter1Moved(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnAddPersonClick(Sender: TObject);
    procedure btnAddContactClick(Sender: TObject);
  private
    procedure InitCaptions;
    function CalcMinLeftPanelWidth: Integer;
    function CalcMinRightPanelWidth: Integer;
    function CalcMinFilterPanelWidth: Integer;
    procedure EnforcePanelBounds;
    procedure OnDataSetAfterOpen(DataSet: TDataSet);
    procedure SetupGridColumn(AGrid: TDBGrid; AColIndex: Integer;
      const ACaption: string; AVisible: Boolean = True);
    procedure AutoFitGridByContent(AGrid: TDBGrid);
    procedure ConfigurePersonsGrid;
    procedure ConfigureContactsGrid;
  end;

var
  MainForm: TMainForm;

implementation

uses
  uConsts,
  uDM,
  uAddPerson,
  uAddContact;

{$R *.dfm}

procedure TMainForm.InitCaptions;
const
  cDefaultGenderIdx = 0;
begin
  Caption := cAppTitle;
  lblGender.Caption := cLblGender;
  lblFio.Caption := cLblFioFilter;
  lblContact.Caption := cLblContactFilter;
  lblAge.Caption := cLblAge;
  btnSearch.Caption := cBtnSearch;
  btnReset.Caption := cBtnReset;
  lblPersonsTitle.Caption := cLblPersonsTitle;
  btnAddPerson.Caption := cBtnAddPerson;
  lblContactsTitle.Caption := cLblContactsTitle;
  btnAddContact.Caption := cBtnAddContact;

  cbGender.Items.Clear;
  cbGender.Items.Add(cGenderAll);
  cbGender.Items.Add(cGenderMale);
  cbGender.Items.Add(cGenderFemale);
  cbGender.ItemIndex := cDefaultGenderIdx;

  edtFio.MaxLength := cMaxFilterTextLen;
  edtContact.MaxLength := cMaxFilterTextLen;
  edtAge.MaxLength := cMaxAgeTextLen;
end;

function TMainForm.CalcMinLeftPanelWidth: Integer;
const
  cLabelToButtonGap = 2;
  cRightEdgeMargin  = 16;
begin
  Result := lblPersonsTitle.Left + lblPersonsTitle.Width + cLabelToButtonGap +
    btnAddPerson.Width + cRightEdgeMargin;
end;

function TMainForm.CalcMinRightPanelWidth: Integer;
const
  cLabelToButtonGap = 2;
  cRightEdgeMargin  = 16;
begin
  Result := lblContactsTitle.Left + lblContactsTitle.Width +
    cLabelToButtonGap + btnAddContact.Width + cRightEdgeMargin;
end;

function TMainForm.CalcMinFilterPanelWidth: Integer;
const
  cMinControlGap = 2;
var
  AgeRightEdge, ButtonsBlockWidth, RightMargin: Integer;
begin
  AgeRightEdge := edtAge.Left + edtAge.Width;
  if (lblAge.Left + lblAge.Width) > AgeRightEdge then
    AgeRightEdge := lblAge.Left + lblAge.Width;

  ButtonsBlockWidth := (btnReset.Left + btnReset.Width) - btnSearch.Left;
  RightMargin := pnlFilter.ClientWidth - (btnReset.Left + btnReset.Width);
  if RightMargin < cMinControlGap then
    RightMargin := cMinControlGap;

  Result := AgeRightEdge + cMinControlGap + ButtonsBlockWidth + RightMargin;
end;

procedure TMainForm.EnforcePanelBounds;
const
  cRightEdgeMargin = 16;
var
  MinLeft, MinRight, MaxLeft: Integer;
begin
  MinLeft := CalcMinLeftPanelWidth;
  MinRight := CalcMinRightPanelWidth;
  MaxLeft := ClientWidth - MinRight - Splitter1.Width;

  if MaxLeft >= MinLeft then
    begin
      if pnlLeft.Width < MinLeft then
        pnlLeft.Width := MinLeft
      else
        if pnlLeft.Width > MaxLeft then
          pnlLeft.Width := MaxLeft;
    end;

  btnAddPerson.Left := pnlLeftTop.ClientWidth - cRightEdgeMargin -
    btnAddPerson.Width;
  btnAddContact.Left := pnlRightTop.ClientWidth - cRightEdgeMargin -
    btnAddContact.Width;
end;

procedure TMainForm.FormCreate(Sender: TObject);
const
  cSplitterDefaultMinSize = 1;
begin
  InitCaptions;
  Splitter1.MinSize := cSplitterDefaultMinSize;
  Splitter1.OnCanResize := Splitter1CanResize;
  Splitter1.OnMoved := Splitter1Moved;

  DM := TDM.Create;
  DM.qryPersons.AfterOpen := OnDataSetAfterOpen;
  DM.qryContacts.AfterOpen := OnDataSetAfterOpen;

  dbgPersons.DataSource := DM.dsPersons;
  dbgContacts.DataSource := DM.dsContacts;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  dbgPersons.DataSource := nil;
  dbgContacts.DataSource := nil;
  FreeAndNil(DM);
end;

procedure TMainForm.FormShow(Sender: TObject);
const
  cInitialLeftPanelRatio = 0.58;
var
  MinBottomWidth, MinTopWidth, MinClientW: Integer;
begin
  pnlLeft.Constraints.MinWidth := CalcMinLeftPanelWidth;
  pnlRight.Constraints.MinWidth := CalcMinRightPanelWidth;

  MinBottomWidth := CalcMinLeftPanelWidth + CalcMinRightPanelWidth +
    Splitter1.Width;
  MinTopWidth := CalcMinFilterPanelWidth;

  if MinTopWidth > MinBottomWidth then
    MinClientW := MinTopWidth
  else
    MinClientW := MinBottomWidth;

  Constraints.MinWidth := MinClientW + (Width - ClientWidth);
  if ClientWidth < MinClientW then
    ClientWidth := MinClientW;

  pnlLeft.Width := Round(ClientWidth * cInitialLeftPanelRatio);
  EnforcePanelBounds;
  ConfigurePersonsGrid;
  ConfigureContactsGrid;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  EnforcePanelBounds;
end;

procedure TMainForm.Splitter1CanResize(Sender: TObject; var NewSize: Integer;
  var Accept: Boolean);
var
  MinLeft, MinRight: Integer;
begin
  MinLeft := CalcMinLeftPanelWidth;
  MinRight := CalcMinRightPanelWidth;
  Accept := (NewSize >= MinLeft) and
    ((ClientWidth - NewSize - Splitter1.Width) >= MinRight);
end;

procedure TMainForm.Splitter1Moved(Sender: TObject);
begin
  EnforcePanelBounds;
end;

procedure TMainForm.OnDataSetAfterOpen(DataSet: TDataSet);
begin
  if DataSet = DM.qryPersons then
    ConfigurePersonsGrid
  else
    if DataSet = DM.qryContacts then
      ConfigureContactsGrid;
end;

procedure TMainForm.SetupGridColumn(AGrid: TDBGrid; AColIndex: Integer;
  const ACaption: string; AVisible: Boolean = True);
var
  Col: TColumn;
begin
  if (AColIndex < 0) or (AColIndex >= AGrid.Columns.Count) then
    Exit;

  Col := AGrid.Columns[AColIndex];
  Col.Visible := AVisible;
  if AVisible then
    Col.Title.Caption := ACaption;
end;

procedure TMainForm.AutoFitGridByContent(AGrid: TDBGrid);
const
  cCellHorizontalPadding = 22;
  cMinColWidth           = 45;
var
  DS: TDataSet;
  Bookmark: TBookmark;
  ColIdx, MaxW, TextW: Integer;
  Col: TColumn;
begin
  if (AGrid.DataSource = nil) or (AGrid.DataSource.DataSet = nil) then
    Exit;

  DS := AGrid.DataSource.DataSet;
  if not DS.Active then
    Exit;

  for ColIdx := 0 to AGrid.Columns.Count - 1 do
    begin
      Col := AGrid.Columns[ColIdx];
      if not Col.Visible then
        Continue;

      AGrid.Canvas.Font.Assign(Col.Title.Font);
      MaxW := AGrid.Canvas.TextWidth(Col.Title.Caption) +
        cCellHorizontalPadding;
      if MaxW < cMinColWidth then
        MaxW := cMinColWidth;
      Col.Width := MaxW;
    end;

  if DS.IsEmpty then
    Exit;

  AGrid.Canvas.Font.Assign(AGrid.Font);
  DS.DisableControls;
  try
    Bookmark := DS.GetBookmark;
    try
      DS.First;
      while not DS.Eof do
        begin
          for ColIdx := 0 to AGrid.Columns.Count - 1 do
            begin
              Col := AGrid.Columns[ColIdx];
              if not Col.Visible or (Col.Field = nil) then
                Continue;

              TextW := AGrid.Canvas.TextWidth(Col.Field.DisplayText) +
                cCellHorizontalPadding;
              if TextW > Col.Width then
                Col.Width := TextW;
            end;
          DS.Next;
        end;
      if DS.BookmarkValid(Bookmark) then
        DS.GotoBookmark(Bookmark);
    finally
      DS.FreeBookmark(Bookmark);
    end;
  finally
    DS.EnableControls;
  end;
end;

procedure TMainForm.ConfigurePersonsGrid;
const
  cPersonsExpectedCols = 7;
  cColIdxId            = 0;
  cColIdxLastName      = 1;
  cColIdxFirstName     = 2;
  cColIdxMiddleName    = 3;
  cColIdxGender        = 4;
  cColIdxBirthDate     = 5;
  cColIdxAge           = 6;
begin
  if dbgPersons.Columns.Count < cPersonsExpectedCols then
    Exit;

  SetupGridColumn(dbgPersons, cColIdxId, '', False);
  SetupGridColumn(dbgPersons, cColIdxLastName, cColLastName);
  SetupGridColumn(dbgPersons, cColIdxFirstName, cColFirstName);
  SetupGridColumn(dbgPersons, cColIdxMiddleName, cColMiddleName);
  SetupGridColumn(dbgPersons, cColIdxGender, cColGender);
  SetupGridColumn(dbgPersons, cColIdxBirthDate, cColBirthDate);
  SetupGridColumn(dbgPersons, cColIdxAge, cColAge);

  AutoFitGridByContent(dbgPersons);
end;

procedure TMainForm.ConfigureContactsGrid;
const
  cContactsExpectedCols = 3;
  cColIdxId             = 0;
  cColIdxType           = 1;
  cColIdxValue          = 2;
begin
  if dbgContacts.Columns.Count < cContactsExpectedCols then
    Exit;

  SetupGridColumn(dbgContacts, cColIdxId, '', False);
  SetupGridColumn(dbgContacts, cColIdxType, cColContactType);
  SetupGridColumn(dbgContacts, cColIdxValue, cColContactValue);

  AutoFitGridByContent(dbgContacts);
end;

procedure TMainForm.btnSearchClick(Sender: TObject);
const
  cGenderIdxMale   = 1;
  cGenderIdxFemale = 2;
  cEmptyAgeFilter  = -1;
var
  GenderCode: string;
  AgeVal: Integer;
begin
  case cbGender.ItemIndex of
    cGenderIdxMale:   GenderCode := 'M';
    cGenderIdxFemale: GenderCode := 'F';
  else
    GenderCode := '';
  end;

  if Trim(edtAge.Text) = '' then
    AgeVal := cEmptyAgeFilter
  else
    if not TryStrToInt(Trim(edtAge.Text), AgeVal) or (AgeVal < 0) then
      begin
        ShowMessage(cMsgInvalidAge);
        edtAge.SetFocus;
        Exit;
      end;

  DM.SearchPersons(GenderCode, edtFio.Text, edtContact.Text, AgeVal);
  ConfigurePersonsGrid;
  ConfigureContactsGrid;
end;

procedure TMainForm.btnResetClick(Sender: TObject);
const
  cGenderIdxAll    = 0;
  cEmptyAgeFilter  = -1;
begin
  cbGender.ItemIndex := cGenderIdxAll;
  edtFio.Clear;
  edtContact.Clear;
  edtAge.Clear;
  DM.SearchPersons('', '', '', cEmptyAgeFilter);
  ConfigurePersonsGrid;
  ConfigureContactsGrid;
end;

procedure TMainForm.btnAddPersonClick(Sender: TObject);
var
  AddPersonForm: TAddPersonForm;
  NewID: Integer;
begin
  AddPersonForm := TAddPersonForm.Create(Self);
  try
    if AddPersonForm.ShowModal = mrOk then
      begin
        try
          NewID := DM.AddPerson(
            AddPersonForm.edtLastName.Text,
            AddPersonForm.edtFirstName.Text,
            AddPersonForm.edtMiddleName.Text,
            AddPersonForm.SelectedGender,
            AddPersonForm.dtpBirthDate.Date
          );
          btnSearchClick(nil);
          DM.qryPersons.Locate('ID', NewID, []);
        except
          on E: EDatabaseError do
            Application.MessageBox(PChar(CleanFBError(E.Message)),
              PChar(Caption), MB_ICONERROR or MB_OK);
        end;
      end;
  finally
    FreeAndNil(AddPersonForm);
  end;
end;

procedure TMainForm.btnAddContactClick(Sender: TObject);
var
  AddContactForm: TAddContactForm;
  PersonID: Integer;
begin
  if DM.qryPersons.IsEmpty then
    begin
      ShowMessage(cMsgSelectPersonFirst);
      Exit;
    end;

  PersonID := DM.qryPersons.FieldByName('ID').AsInteger;
  AddContactForm := TAddContactForm.Create(Self);
  try
    if AddContactForm.ShowModal = mrOk then
      begin
        try
          DM.AddContact(PersonID, AddContactForm.SelectedTypeID,
            AddContactForm.edtValue.Text);
          DM.LoadContacts(PersonID);
          ConfigureContactsGrid;
        except
          on E: EDatabaseError do
            Application.MessageBox(PChar(CleanFBError(E.Message)),
              PChar(Caption), MB_ICONERROR or MB_OK);
        end;
      end;
  finally
    FreeAndNil(AddContactForm);
  end;
end;

end.


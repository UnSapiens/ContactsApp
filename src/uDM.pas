unit uDM;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.Stan.Def,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Comp.UI;

type
  TDbConfig = record
    Server: string;
    DatabasePath: string;
    UserName: string;
    Password: string;
    CharacterSet: string;
  end;

type
  TDM = class
  private
    FFDConnection: TFDConnection;
    FFDPhysFBDriverLink: TFDPhysFBDriverLink;
    FFDGUIxWaitCursor: TFDGUIxWaitCursor;
    FqryPersons: TFDQuery;
    FdsPersons: TDataSource;
    FqryContacts: TFDQuery;
    FdsContacts: TDataSource;
    FqryContactTypes: TFDQuery;
    FdsContactTypes: TDataSource;
    FspAddPerson: TFDStoredProc;
    FspAddContact: TFDStoredProc;
    procedure InitComponents;
    procedure ConnectToDB;
    procedure qryPersonsAfterScroll(DataSet: TDataSet);
    procedure GenderFieldGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    function LoadDbConfig: TDbConfig;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SearchPersons(const AGender, AFioPart, AContactPart: string;
      AAge: Integer);
    procedure LoadContacts(APersonID: Integer);
    procedure LoadContactTypes;
    function AddPerson(const ALastName, AFirstName, AMiddleName,
      AGender: string; ABirthDate: TDate): Integer;
    function AddContact(APersonID, ATypeID: Integer;
      const AValue: string): Integer;

    property qryPersons: TFDQuery read FqryPersons;
    property dsPersons: TDataSource read FdsPersons;
    property qryContacts: TFDQuery read FqryContacts;
    property dsContacts: TDataSource read FdsContacts;
    property qryContactTypes: TFDQuery read FqryContactTypes;
    property dsContactTypes: TDataSource read FdsContactTypes;
  end;

function CleanFBError(const AMsg: string): string;

var
  DM: TDM;

implementation

uses
  FireDAC.Stan.Async,
  FireDAC.DApt,
  System.IniFiles,
  uConsts;

function CleanFBError(const AMsg: string): string;
const
  cExDuplicateData    = 'EX_DUPLICATE_DATA';
  cExValidationErr    = 'EX_VALIDATION_ERR';
  cFbUserMsgLineIndex = 2;
  cMinFbErrorLines    = 3;
var
  Lines: TArray<string>;
begin
  if AMsg.Contains(cExDuplicateData) then
    Exit(cMsgDuplicateData);

  if AMsg.Contains(cExValidationErr) then
    Exit(cMsgValidationErr);

  Lines := AMsg.Split([#13#10, #10]);
  if Length(Lines) >= cMinFbErrorLines then
    Result := Lines[cFbUserMsgLineIndex].Trim
  else
    Result := AMsg;
end;

constructor TDM.Create;
begin
  inherited Create;
  InitComponents;
  ConnectToDB;
end;

destructor TDM.Destroy;
begin
  if Assigned(FFDConnection) then
    FFDConnection.Close;

  FreeAndNil(FdsContactTypes);
  FreeAndNil(FdsContacts);
  FreeAndNil(FdsPersons);

  FreeAndNil(FspAddContact);
  FreeAndNil(FspAddPerson);
  FreeAndNil(FqryContactTypes);
  FreeAndNil(FqryContacts);
  FreeAndNil(FqryPersons);

  FreeAndNil(FFDConnection);

  FreeAndNil(FFDPhysFBDriverLink);
  FreeAndNil(FFDGUIxWaitCursor);

  inherited Destroy;
end;

procedure TDM.InitComponents;
begin
  FFDConnection := TFDConnection.Create(nil);
  FFDConnection.LoginPrompt := False;

  FFDPhysFBDriverLink := TFDPhysFBDriverLink.Create(nil);

  FFDGUIxWaitCursor := TFDGUIxWaitCursor.Create(nil);
  FFDGUIxWaitCursor.Provider := 'Forms';

  FqryPersons := TFDQuery.Create(nil);
  FqryPersons.Connection := FFDConnection;
  FqryPersons.AfterScroll := qryPersonsAfterScroll;

  FdsPersons := TDataSource.Create(nil);
  FdsPersons.DataSet := FqryPersons;

  FqryContacts := TFDQuery.Create(nil);
  FqryContacts.Connection := FFDConnection;

  FdsContacts := TDataSource.Create(nil);
  FdsContacts.DataSet := FqryContacts;

  FqryContactTypes := TFDQuery.Create(nil);
  FqryContactTypes.Connection := FFDConnection;

  FdsContactTypes := TDataSource.Create(nil);
  FdsContactTypes.DataSet := FqryContactTypes;

  FspAddPerson := TFDStoredProc.Create(nil);
  FspAddPerson.Connection := FFDConnection;

  FspAddContact := TFDStoredProc.Create(nil);
  FspAddContact.Connection := FFDConnection;
end;

procedure TDM.ConnectToDB;
const
  cEmptyAgeFilter = -1;
var
  Cfg: TDbConfig;
begin
  Cfg := LoadDbConfig;

  if not FileExists(Cfg.DatabasePath) then
    raise Exception.Create(cMsgDbNotFound + sLineBreak + Cfg.DatabasePath);

  FFDConnection.Close;
  FFDConnection.DriverName := 'FB';
  FFDConnection.Params.Clear;
  FFDConnection.Params.Add('DriverID=FB');
  FFDConnection.Params.Add('Server=' + Cfg.Server);
  FFDConnection.Params.Add('Database=' + Cfg.DatabasePath);
  FFDConnection.Params.Add('User_Name=' + Cfg.UserName);
  FFDConnection.Params.Add('Password=' + Cfg.Password);
  FFDConnection.Params.Add('CharacterSet=' + Cfg.CharacterSet);

  try
    FFDConnection.Connected := True;
    LoadContactTypes;
    SearchPersons('', '', '', cEmptyAgeFilter);
  except
    on E: Exception do
      raise Exception.Create(cMsgDbConnectFail + Cfg.DatabasePath + '): ' +
        sLineBreak + E.Message);
  end;
end;

function TDM.LoadDbConfig: TDbConfig;
var
  ExeDir, IniPath, RawDbPath: string;
  IniFile: TIniFile;
begin
  ExeDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  IniPath := ExeDir + cConfigFileName;

  IniFile := TIniFile.Create(IniPath);
  try
    Result.Server := IniFile.ReadString(cIniSectionDb, cIniKeyServer,
      cDefaultServer).Trim;
    if Result.Server = '' then
      Result.Server := cDefaultServer;

    RawDbPath := IniFile.ReadString(cIniSectionDb, cIniKeyDatabase,
      cDefaultRelDbPath).Trim;
    if RawDbPath = '' then
      RawDbPath := cDefaultRelDbPath;

    Result.UserName := IniFile.ReadString(cIniSectionDb, cIniKeyUserName,
      cDefaultUserName).Trim;
    if Result.UserName = '' then
      Result.UserName := cDefaultUserName;

    Result.Password := IniFile.ReadString(cIniSectionDb, cIniKeyPassword,
      cDefaultPassword).Trim;
    if Result.Password = '' then
      Result.Password := cDefaultPassword;

    Result.CharacterSet := IniFile.ReadString(cIniSectionDb, cIniKeyCharset,
      cDefaultCharset).Trim;
    if Result.CharacterSet = '' then
      Result.CharacterSet := cDefaultCharset;

    if IniFile.ReadString(cIniSectionDb, cIniKeyServer, '').Trim = '' then
      IniFile.WriteString(cIniSectionDb, cIniKeyServer, Result.Server);
    if IniFile.ReadString(cIniSectionDb, cIniKeyDatabase, '').Trim = '' then
      IniFile.WriteString(cIniSectionDb, cIniKeyDatabase, RawDbPath);
    if IniFile.ReadString(cIniSectionDb, cIniKeyUserName, '').Trim = '' then
      IniFile.WriteString(cIniSectionDb, cIniKeyUserName, Result.UserName);
    if IniFile.ReadString(cIniSectionDb, cIniKeyPassword, '').Trim = '' then
      IniFile.WriteString(cIniSectionDb, cIniKeyPassword, Result.Password);
    if IniFile.ReadString(cIniSectionDb, cIniKeyCharset, '').Trim = '' then
      IniFile.WriteString(cIniSectionDb, cIniKeyCharset, Result.CharacterSet);
  finally
    FreeAndNil(IniFile);
  end;

  if IsRelativePath(RawDbPath) then
    Result.DatabasePath := ExpandFileName(ExeDir + RawDbPath)
  else
    Result.DatabasePath := RawDbPath;
end;

procedure TDM.SearchPersons(const AGender, AFioPart, AContactPart: string;
  AAge: Integer);
const
  cMinFioFilterLen     = 2;
  cMinContactFilterLen = 4;
begin
  FqryPersons.DisableControls;
  try
    FqryPersons.Close;
    FqryPersons.SQL.Text :=
      'SELECT * FROM SP_SEARCH_PERSONS(:P_GENDER, :P_FIO_PART, ' +
      ':P_CONTACT_PART, :P_AGE)';

    with FqryPersons.ParamByName('P_GENDER') do
    begin
      DataType := ftString;
      if AGender.Trim.IsEmpty then
        Clear
      else
        AsString := AGender;
    end;

    with FqryPersons.ParamByName('P_FIO_PART') do
    begin
      DataType := ftString;
      if AFioPart.Trim.Length < cMinFioFilterLen then
        Clear
      else
        AsString := AFioPart.Trim;
    end;

    with FqryPersons.ParamByName('P_CONTACT_PART') do
    begin
      DataType := ftString;
      if AContactPart.Trim.Length < cMinContactFilterLen then
        Clear
      else
        AsString := AContactPart.Trim;
    end;

    with FqryPersons.ParamByName('P_AGE') do
    begin
      DataType := ftInteger;
      if AAge < 0 then
        Clear
      else
        AsInteger := AAge;
    end;

    FqryPersons.Open;
    if FqryPersons.FindField('GENDER') <> nil then
      FqryPersons.FieldByName('GENDER').OnGetText := GenderFieldGetText;
    if FqryPersons.IsEmpty then
      FqryContacts.Close;
  finally
    FqryPersons.EnableControls;
  end;
end;

procedure TDM.qryPersonsAfterScroll(DataSet: TDataSet);
begin
  if not FqryPersons.IsEmpty then
    LoadContacts(FqryPersons.FieldByName('ID').AsInteger)
  else
    FqryContacts.Close;
end;

procedure TDM.LoadContacts(APersonID: Integer);
begin
  FqryContacts.Close;
  FqryContacts.SQL.Text := 'SELECT * FROM SP_GET_PERSON_CONTACTS(:P_PERSON_ID)';
  FqryContacts.ParamByName('P_PERSON_ID').AsInteger := APersonID;
  FqryContacts.Open;
end;

procedure TDM.LoadContactTypes;
begin
  FqryContactTypes.Close;
  FqryContactTypes.SQL.Text := 'SELECT * FROM SP_GET_CONTACT_TYPES';
  FqryContactTypes.Open;
end;

function TDM.AddPerson(const ALastName, AFirstName, AMiddleName,
  AGender: string; ABirthDate: TDate): Integer;
begin
  FspAddPerson.StoredProcName := 'SP_ADD_PERSON';
  FspAddPerson.Prepare;
  FspAddPerson.ParamByName('P_LAST_NAME').AsString := ALastName;
  FspAddPerson.ParamByName('P_FIRST_NAME').AsString := AFirstName;

  if AMiddleName.Trim.IsEmpty then
    FspAddPerson.ParamByName('P_MIDDLE_NAME').Clear
  else
    FspAddPerson.ParamByName('P_MIDDLE_NAME').AsString := AMiddleName;

  FspAddPerson.ParamByName('P_GENDER').AsString := AGender;
  FspAddPerson.ParamByName('P_BIRTH_DATE').AsDate := ABirthDate;

  FspAddPerson.ExecProc;
  Result := FspAddPerson.ParamByName('NEW_ID').AsInteger;
  FFDConnection.CommitRetaining;
end;

function TDM.AddContact(APersonID, ATypeID: Integer;
  const AValue: string): Integer;
begin
  FspAddContact.StoredProcName := 'SP_ADD_CONTACT';
  FspAddContact.Prepare;
  FspAddContact.ParamByName('P_PERSON_ID').AsInteger := APersonID;
  FspAddContact.ParamByName('P_CONTACT_TYPE_ID').AsInteger := ATypeID;
  FspAddContact.ParamByName('P_CONTACT_VALUE').AsString := AValue;

  FspAddContact.ExecProc;
  Result := FspAddContact.ParamByName('NEW_ID').AsInteger;
  FFDConnection.CommitRetaining;
end;

procedure TDM.GenderFieldGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
const
  cGenderCodeMale   = 'M';
  cGenderCodeFemale = 'F';
var
  Val: string;
begin
  Val := Trim(Sender.AsString);
  if Val = cGenderCodeMale then
    Text := cGenderMale
  else
    if Val = cGenderCodeFemale then
      Text := cGenderFemale
    else
      Text := Val;
end;
end.


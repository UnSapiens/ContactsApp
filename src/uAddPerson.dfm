object AddPersonForm: TAddPersonForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'AddPersonForm'
  ClientHeight = 250
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object lblLastName: TLabel
    Left = 20
    Top = 20
    Width = 61
    Height = 15
    Caption = 'LastName *'
  end
  object lblFirstName: TLabel
    Left = 20
    Top = 55
    Width = 62
    Height = 15
    Caption = 'FirstName *'
  end
  object lblMiddleName: TLabel
    Left = 20
    Top = 90
    Width = 69
    Height = 15
    Caption = 'MiddleName'
  end
  object lblGender: TLabel
    Left = 20
    Top = 125
    Width = 46
    Height = 15
    Caption = 'Gender *'
  end
  object lblBirthDate: TLabel
    Left = 20
    Top = 160
    Width = 57
    Height = 15
    Caption = 'BirthDate *'
  end
  object edtLastName: TEdit
    Left = 128
    Top = 17
    Width = 190
    Height = 23
    TabOrder = 0
  end
  object edtFirstName: TEdit
    Left = 128
    Top = 52
    Width = 190
    Height = 23
    TabOrder = 1
  end
  object edtMiddleName: TEdit
    Left = 128
    Top = 87
    Width = 190
    Height = 23
    TabOrder = 2
  end
  object cbGender: TComboBox
    Left = 128
    Top = 122
    Width = 190
    Height = 23
    Style = csDropDownList
    TabOrder = 3
  end
  object dtpBirthDate: TDateTimePicker
    Left = 128
    Top = 157
    Width = 190
    Height = 23
    Date = 32874.000000000000000000
    Time = 32874.000000000000000000
    TabOrder = 4
  end
  object btnOk: TButton
    Left = 156
    Top = 204
    Width = 78
    Height = 26
    Caption = 'Save'
    Default = True
    TabOrder = 5
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 240
    Top = 204
    Width = 78
    Height = 26
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
end

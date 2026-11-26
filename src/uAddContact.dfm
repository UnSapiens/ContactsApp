object AddContactForm: TAddContactForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'AddContactForm'
  ClientHeight = 145
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object lblType: TLabel
    Left = 20
    Top = 20
    Width = 32
    Height = 15
    Caption = 'Type *'
  end
  object lblValue: TLabel
    Left = 20
    Top = 58
    Width = 36
    Height = 15
    Caption = 'Value *'
  end
  object dblcbType: TDBLookupComboBox
    Left = 116
    Top = 17
    Width = 212
    Height = 23
    KeyField = 'ID'
    ListField = 'NAME'
    TabOrder = 0
  end
  object edtValue: TEdit
    Left = 116
    Top = 55
    Width = 212
    Height = 23
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 166
    Top = 100
    Width = 78
    Height = 26
    Caption = 'Save'
    Default = True
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 250
    Top = 100
    Width = 78
    Height = 26
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end

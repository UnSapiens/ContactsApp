object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 560
  ClientWidth = 1060
  Color = clBtnFace
  Constraints.MinHeight = 460
  Constraints.MinWidth = 940
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 640
    Top = 65
    Width = 5
    Height = 495
    MinSize = 1
    OnCanResize = Splitter1CanResize
    OnMoved = Splitter1Moved
  end
  object pnlFilter: TPanel
    Left = 0
    Top = 0
    Width = 1060
    Height = 65
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      1060
      65)
    object lblGender: TLabel
      Left = 16
      Top = 10
      Width = 38
      Height = 15
      Caption = 'Gender'
    end
    object lblFio: TLabel
      Left = 136
      Top = 10
      Width = 59
      Height = 15
      Caption = 'FIO (min 2)'
    end
    object lblContact: TLabel
      Left = 354
      Top = 10
      Width = 83
      Height = 15
      Caption = 'Contact (min 4)'
    end
    object lblAge: TLabel
      Left = 572
      Top = 10
      Width = 21
      Height = 15
      Caption = 'Age'
    end
    object cbGender: TComboBox
      Left = 16
      Top = 29
      Width = 105
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object edtFio: TEdit
      Left = 136
      Top = 29
      Width = 202
      Height = 23
      TabOrder = 1
    end
    object edtContact: TEdit
      Left = 354
      Top = 29
      Width = 202
      Height = 23
      TabOrder = 2
    end
    object edtAge: TEdit
      Left = 572
      Top = 29
      Width = 70
      Height = 23
      NumbersOnly = True
      TabOrder = 3
    end
    object btnSearch: TButton
      Left = 856
      Top = 28
      Width = 90
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Search'
      Default = True
      TabOrder = 4
      OnClick = btnSearchClick
    end
    object btnReset: TButton
      Left = 954
      Top = 28
      Width = 90
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Reset'
      TabOrder = 5
      OnClick = btnResetClick
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 65
    Width = 640
    Height = 495
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object pnlLeftTop: TPanel
      Left = 0
      Top = 0
      Width = 640
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        640
        41)
      object lblPersonsTitle: TLabel
        Left = 16
        Top = 12
        Width = 48
        Height = 17
        Caption = 'Persons'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnAddPerson: TButton
        Left = 492
        Top = 8
        Width = 136
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Add Person'
        TabOrder = 0
        OnClick = btnAddPersonClick
      end
    end
    object dbgPersons: TDBGrid
      Left = 0
      Top = 41
      Width = 640
      Height = 454
      Align = alClient
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object pnlRight: TPanel
    Left = 645
    Top = 65
    Width = 415
    Height = 495
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pnlRightTop: TPanel
      Left = 0
      Top = 0
      Width = 415
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        415
        41)
      object lblContactsTitle: TLabel
        Left = 12
        Top = 12
        Width = 53
        Height = 17
        Caption = 'Contacts'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnAddContact: TButton
        Left = 274
        Top = 8
        Width = 129
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Add Contact'
        TabOrder = 0
        OnClick = btnAddContactClick
      end
    end
    object dbgContacts: TDBGrid
      Left = 0
      Top = 41
      Width = 415
      Height = 454
      Align = alClient
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
end

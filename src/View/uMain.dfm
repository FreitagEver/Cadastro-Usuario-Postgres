object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Cadastro de Usu'#225'rios'
  ClientHeight = 430
  ClientWidth = 760
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    760
    430)
  TextHeight = 15
  object btnNovo: TButton
    Left = 16
    Top = 16
    Width = 110
    Height = 30
    Caption = 'Novo Usu'#225'rio'
    TabOrder = 0
    OnClick = btnNovoClick
  end
  object btnEditar: TButton
    Left = 136
    Top = 16
    Width = 110
    Height = 30
    Caption = 'Editar'
    TabOrder = 1
    OnClick = btnEditarClick
  end
  object btnExcluir: TButton
    Left = 256
    Top = 16
    Width = 110
    Height = 30
    Caption = 'Excluir'
    TabOrder = 2
    OnClick = btnExcluirClick
  end
  object grdUsuarios: TStringGrid
    Left = 16
    Top = 64
    Width = 728
    Height = 345
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    ExplicitWidth = 722
    ExplicitHeight = 328
  end
end

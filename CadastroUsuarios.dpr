program CadastroUsuarios;

uses
  Vcl.Forms,
  uMain in 'src\View\uMain.pas' {frmMain},
  uUsuario in 'src\View\uUsuario.pas' {frmUsuario},
  uUsuarioModel in 'src\Model\uUsuarioModel.pas',
  uUsuarioController in 'src\Controller\uUsuarioController.pas',
  uDatabase in 'src\Infrastructure\uDatabase.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Cadastro de Usuários - MVC';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

unit uUsuarioController;

interface

uses
  System.SysUtils, System.Generics.Collections,
  FireDAC.Comp.Client, uUsuarioModel, uDatabase;

type
  TUsuarioController = class
  private
    FDatabase: TDatabase;
    procedure Validate(const ANome, AEmail, ASenha: string; ARequirePassword: Boolean);
  public
    constructor Create(ADatabase: TDatabase);
    function Listar: TObjectList<TUsuario>;
    procedure Cadastrar(const ANome, AEmail, ASenha: string);
    procedure Atualizar(AId: Integer; const ANome, AEmail, ASenha: string);
    procedure Excluir(AId: Integer);
    function EmailExiste(const AEmail: string; AId: Integer = 0): Boolean;
    function GetById(AId: Integer): TUsuario;
  end;

implementation

constructor TUsuarioController.Create(ADatabase: TDatabase);
begin
  inherited Create;
  FDatabase := ADatabase;
end;

procedure TUsuarioController.Validate(const ANome, AEmail, ASenha: string; ARequirePassword: Boolean);
begin
  if Trim(ANome) = '' then
    raise Exception.Create('Informe o nome.');
  if Trim(AEmail) = '' then
    raise Exception.Create('Informe o e-mail.');
  if ARequirePassword and (Trim(ASenha) = '') then
    raise Exception.Create('Informe a senha.');
  if Pos('@', AEmail) <= 1 then
    raise Exception.Create('Informe um e-mail válido.');
end;

function TUsuarioController.EmailExiste(const AEmail: string; AId: Integer): Boolean;
var
  vQry: TFDQuery;
begin
  vQry := TFDQuery.Create(nil);
  try
    vQry.Connection := FDatabase.Connection;
    vQry.SQL.Text := 'SELECT 1 FROM usuario WHERE LOWER(email)=LOWER(:email) AND (:id=0 OR id<>:id) LIMIT 1';
    vQry.ParamByName('email').AsString := Trim(AEmail);
    vQry.ParamByName('id').AsInteger := AId;
    vQry.Open;
    Result := not vQry.IsEmpty;
  finally
    vQry.Free;
  end;
end;

procedure TUsuarioController.Cadastrar(const ANome, AEmail, ASenha: string);
var
  vQry: TFDQuery;
begin
  Validate(ANome, AEmail, ASenha, True);
  if EmailExiste(AEmail) then
    raise Exception.Create('O e-mail informado já está cadastrado.');

  vQry := TFDQuery.Create(nil);
  try
    vQry.Connection := FDatabase.Connection;
    vQry.SQL.Text := 'INSERT INTO usuario (nome,email,senha) VALUES (:nome,:email,:senha)';
    vQry.ParamByName('nome').AsString := Trim(ANome);
    vQry.ParamByName('email').AsString := Trim(AEmail);
    vQry.ParamByName('senha').AsString := FDatabase.HashPassword(ASenha);
    vQry.ExecSQL;
  finally
    vQry.Free;
  end;
end;

procedure TUsuarioController.Atualizar(AId: Integer; const ANome, AEmail, ASenha: string);
var
  vQry: TFDQuery;
begin
  Validate(ANome, AEmail, ASenha, False);
  if EmailExiste(AEmail, AId) then
    raise Exception.Create('O e-mail informado já está cadastrado.');

  vQry := TFDQuery.Create(nil);
  try
    vQry.Connection := FDatabase.Connection;
    if Trim(ASenha) <> '' then
    begin
      vQry.SQL.Text := 'UPDATE usuario SET nome=:nome,email=:email,senha=:senha WHERE id=:id';
      vQry.ParamByName('senha').AsString := FDatabase.HashPassword(ASenha);
    end
    else
      vQry.SQL.Text := 'UPDATE usuario SET nome=:nome,email=:email WHERE id=:id';

    vQry.ParamByName('nome').AsString := Trim(ANome);
    vQry.ParamByName('email').AsString := Trim(AEmail);
    vQry.ParamByName('id').AsInteger := AId;
    vQry.ExecSQL;
  finally
    vQry.Free;
  end;
end;

procedure TUsuarioController.Excluir(AId: Integer);
var
  vQry: TFDQuery;
begin
  vQry := TFDQuery.Create(nil);
  try
    vQry.Connection := FDatabase.Connection;
    vQry.SQL.Text := 'DELETE FROM usuario WHERE id=:id';
    vQry.ParamByName('id').AsInteger := AId;
    vQry.ExecSQL;
  finally
    vQry.Free;
  end;
end;

function TUsuarioController.Listar: TObjectList<TUsuario>;
var
  vQry: TFDQuery;
  vUsu: TUsuario;
begin
  Result := TObjectList<TUsuario>.Create(True);
  vQry := TFDQuery.Create(nil);
  try
    vQry.Connection := FDatabase.Connection;
    vQry.SQL.Text := 'SELECT id,nome,email,data_criacao FROM usuario ORDER BY id';
    vQry.Open;
    while not vQry.Eof do
    begin
      vUsu := TUsuario.Create;
      vUsu.Id := vQry.FieldByName('id').AsInteger;
      vUsu.Nome := vQry.FieldByName('nome').AsString;
      vUsu.Email := vQry.FieldByName('email').AsString;
      vUsu.DataCriacao := vQry.FieldByName('data_criacao').AsDateTime;
      Result.Add(vUsu);
      vQry.Next;
    end;
  finally
    vQry.Free;
  end;
end;

function TUsuarioController.GetById(AId: Integer): TUsuario;
var
  vQry: TFDQuery;
begin
  Result := nil;
  vQry := TFDQuery.Create(nil);
  try
    vQry.Connection := FDatabase.Connection;
    vQry.SQL.Text := 'SELECT id,nome,email,data_criacao FROM usuario WHERE id=:id';
    vQry.ParamByName('id').AsInteger := AId;
    vQry.Open;
    if not vQry.IsEmpty then
    begin
      Result := TUsuario.Create;
      Result.Id := vQry.FieldByName('id').AsInteger;
      Result.Nome := vQry.FieldByName('nome').AsString;
      Result.Email := vQry.FieldByName('email').AsString;
      Result.DataCriacao := vQry.FieldByName('data_criacao').AsDateTime;
    end;
  finally
    vQry.Free;
  end;
end;

end.

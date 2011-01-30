unit sql;

interface

uses
  DBXFirebird, SqlExpr, DB, DBClient, Variants, SysUtils, SimpleDS, Generics.Collections, DBXCommon, constant, utils, Dialogs;

type
  TSql = class
  strict private
    class procedure SetParams(const sourceParams: TParams; const dest: TSQLQuery); overload;
    class procedure SetParams(const sourceParams: TParams; const dest: TInternalSQLDataSet); overload;
  public
    class function ExecuteSql(const sql: string; const params: TParams = nil): Integer;
    class function ExecuteInsert(const sql: string; const params: TParams = nil): Integer;
    class function ExecuteSqlNoTrans(const sql: string; const params: TParams = nil): Integer;
    class function ExecuteQuery(const sql: string; const params: TParams = nil): OleVariant;
    class function ExecuteQueryDS(const sql: string; const params: TParams = nil): TDictionary<Integer, string>;
    class function ExecuteCount(const sql: string; const fieldAsName: string = 'c'): Integer;
  end;

implementation

class function TSql.ExecuteInsert(const sql: string; const params: TParams): Integer;
var
  conn: TSQLConnection;
  query: TSQLQuery;
  trans: TDBXTransaction;
begin
  Result := RETURN_FALSE;
  conn := TUtils.GetInstance.GetConnection;
  query := TUtils.GetInstance.GetQuery(conn);
  query.SQL.Text := sql;

  if params <> nil then
    SetParams(params, query);

  try
    try
      conn.Open;
      trans := conn.BeginTransaction;
      try
        query.Open;
        Result := query.FieldByName(PRIMARY_KEY_NAME).AsInteger;
        conn.CommitFreeAndNil(trans);
      except
        conn.RollbackFreeAndNil(trans);
        raise;
      end;
    except
      raise;
    end;
  finally
    TUtils.Free(query, conn);
  end;
end;

class function TSql.ExecuteSql(const sql: string; const params: TParams): Integer;
var
  conn: TSQLConnection;
  query: TSQLQuery;
  trans: TDBXTransaction;
begin
  Result := RETURN_FALSE;
  conn := TUtils.GetInstance.GetConnection;
  query := TUtils.GetInstance.GetQuery(conn);
  query.SQL.Text := sql;

  if params <> nil then
    SetParams(params, query);

  try
    try
      conn.Open;
      trans := conn.BeginTransaction;
      try
        Result := query.ExecSQL;
        conn.CommitFreeAndNil(trans);
      except
        conn.RollbackFreeAndNil(trans);
        raise;
      end;
    except
      raise;
    end;
  finally
    TUtils.Free(query, conn);
  end;
end;

class function TSql.ExecuteSqlNoTrans(const sql: string; const params: TParams): Integer;
var
  query: TSQLQuery;
begin
  Result := RETURN_FALSE;
  query := TUtils.GetInstance.GetQuery;
  query.SQL.Text := sql;

  if params <> nil then
    SetParams(params, query);

  try
    try
      Result := query.ExecSQL;
    except
      raise;
    end;
  finally
    TUtils.Free(query);
  end;
end;

class procedure TSql.SetParams(const sourceParams: TParams; const dest: TInternalSQLDataSet);
var
  i: Integer;
begin
  dest.Params.Clear;
  for i := 0 to sourceParams.Count - 1 do
  begin
    with dest.Params.AddParameter do
    begin
      Name := sourceParams[i].Name;
      DataType := sourceParams[i].DataType;
      Value := sourceParams[i].Value;
    end;
  end;
end;

class procedure TSql.SetParams(const sourceParams: TParams; const dest: TSQLQuery);
var
  i: Integer;
begin
  dest.Params.Clear;
  for i := 0 to sourceParams.Count - 1 do
  begin
    with dest.Params.AddParameter do
    begin
      Name := sourceParams[i].Name;
      DataType := sourceParams[i].DataType;
      Value := sourceParams[i].Value;
    end;
  end;
end;

class function TSql.ExecuteQuery(const sql: string; const params: TParams): OleVariant;
var
  ds: TSimpleDataSet;
begin
  ds := TUtils.GetInstance.GetSimpleDataSet;
  ds.DataSet.CommandText := sql;

  if params <> nil then
    SetParams(params, ds.DataSet);

  try
    try
      ds.Open;
      Result := ds.Data;
    except
      raise;
    end;
  finally
    TUtils.Free(ds);
  end;
end;

class function TSql.ExecuteQueryDS(const sql: string; const params: TParams): TDictionary<Integer, string>;
var
  query: TSQLQuery;
  ds: TDictionary<Integer, string>;
begin
  Result := nil;
  ds := TDictionary<Integer, string>.Create;

  query := TUtils.GetInstance.GetQuery;
  query.SQL.Text := sql;

  if params <> nil then
    SetParams(params, query);

  try
    try
      query.Open;
      while not query.Eof do
      begin
        ds.Add(StrToInt(VarToStr(query.FieldValues['id'])), VarToStr(query.FieldValues['name']));
        query.Next;
      end;
      Result := ds;
    except
      raise;
    end;
  finally
    TUtils.Free(query);
  end;
end;

class function TSql.ExecuteCount(const sql, fieldAsName: string): Integer;
var
  query: TSQLQuery;
begin
  Result := RETURN_FALSE;
  query := TUtils.GetInstance.GetQuery;
  query.SQL.Text := sql;

  try
    try
      query.Open;
      Result := StrToInt(VarToStr(query.FieldValues[fieldAsName]));
    except
      raise;
    end;
  finally
    TUtils.Free(query);
  end;
end;

end.

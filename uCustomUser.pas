unit uCustomUser;

interface uses
  System.Hash, SysUtils,
  Data.Win.ADODB,
  FMX.Dialogs
;

type
  ICustomUserAuth = interface(IUnknown)
    ['{1F0DF0EF-E83F-42FB-A472-93DC9FF7A560}']
    procedure Auth;
  end;

type
  TADOCustomUser = class(TInterfacedObject, ICustomUserAuth)
    public
      FID: integer;
      constructor Create;
      procedure Auth;

      procedure setConnectionString(Value: string);
      function getConnection: TADOConnection;
    private
      FPassword: string; // хранится только хэшированный
      FUSERNAME: string;
      FAuthStatus: boolean;
      FConnection: TADOConnection;
      FConnectionString: string;

      procedure setAuthData(pUsername: string; pPassword: string);
      procedure setAuth(Value: boolean);
    published
      property Password: string read FPassword write FPassword;
      property Username: string read FUSERNAME write FUSERNAME;
      property isAuth: boolean read FAuthStatus write setAuth;
      property ID: integer read FID write FID;
      property ConnectionString: string read FConnectionString;
  end;

Type
  TCTMUser = class(TADOCustomUser)
    procedure Auth(pUsername: string; pPassword: string);

  end;

implementation

  { ---------------CUSTOM USER------------------------------ }
constructor  TADOCustomUser.Create;
  begin

  end;

procedure TADOCustomUser.setConnectionString(Value: string);
  begin
    FConnectionString := Value;
  end;

procedure TADOCustomUser.Auth;
  begin
//    LoginInDB;
  end;

procedure TADOCustomUser.setAuth(Value: boolean);
  begin
    if not Value then
      // очистим
      begin
        FPassword := '';
        FUsername := '';
        FID := 0;
//        FConnection.Destroy;
        Fconnection := Nil;
        FAuthStatus := Value;
      end
    else
      begin
        FConnection := TADOConnection.Create(NIL);
        FConnection.CommandTimeout := 5;
        FConnection.ConnectionTimeout := 5;
        FConnection.ConnectionString := FConnectionString;
        FConnection.Connected := True;
      end;

    FAuthStatus := Value;
  end;

procedure TADOCustomUser.setAuthData(pUsername: string; pPassword: string);
  begin
    Username := pUsername;
    Password := THashMD5.GetHashString(pPassword);
  end;

function TADOCustomUser.getConnection: TADOConnection;
  begin
    result := FConnection;
  end;

  { --------------CTM USER ----------------------------------}
//CTMUser.setConnectionString(ConnectionSetup.GetConnectionString(cbIniSection.Selected.Text));
//CTMUser.Auth(editUsername.Text, editPassword.Text);
procedure TCTMUser.Auth(pUsername: string; pPassword: string);
  var
    q: TADOQuery;
  begin
    setAuthData(pUsername, pPassword);
    q := TADOQuery.Create(NIL);
    q.Connection := TADOConnection.Create(NIL);
    q.Connection.ConnectionTimeout := 5;
    q.Connection.CommandTimeout := 5;
    q.Connection.ConnectionString := FConnectionString;
    q.SQL.Clear;
    q.SQL.Add(
      'exec CTMUsers#login '
      + QuotedStr(FUSERNAME)
      + ','
      + QuotedStr(FPassword)
    );
    q.Open;
    if q.RecordCount = 1 then
      begin
        FID := q.FieldValues['ID'];
//        ShowMessage(IntToStr(FID));
        setAuth(True);
      end
    else
      begin
        setAuth(False);
//        ShowMessage(q.SQL[0]);
      end;
  end;

end.

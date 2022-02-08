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
      FUSERNAME: string;
      FisAUTH: boolean;
      FConnection: TADOConnection;
      constructor Create(pUsername: string; pPassword: string; pConnection: TADOConnection);
      procedure Auth;

    private
      FPassword: string; // хранится только хэшированный
  end;

Type
  TCTMUser = class(TADOCustomUser)
    procedure Auth;

  end;

implementation

constructor TADOCustomUser.Create(pUsername: string; pPassword: string; pConnection: TADOConnection);
  begin
    FUSERNAME := pUsername;
    FPassword := THashMD5.GetHashString(pPassword);
    FConnection := pConnection;
  end;

procedure TADOCustomUser.Auth;
  begin
//    LoginInDB;
  end;

procedure TCTMUser.Auth;
  var
    q: TADOQuery;
  begin
    q := TADOQuery.Create(NIL);
    q.Connection := FConnection;
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
        FisAUTH := True;
        q.Close;
        Exit;
      end;
    FisAUTH := False;
    exit;
  end;
end.

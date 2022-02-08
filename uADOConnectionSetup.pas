unit uADOConnectionSetup;

interface
  uses
    System.SysUtils, System.IniFiles, FMX.Dialogs,
    Classes;

type
  TADOConnectionSetup = class
    public
      constructor Create(DBType: string; IniFilePath: string);

      { наполняет выбранный компонент секциями ini-файла для выбора }
      procedure SetSectionSelector(SectionSelector: TStrings);

      { возвращет данные выбранной секции как строку подключения }
      function GetConnectionString(SelectedSection: string): string;

    private
      FDBType: string; // для дальнейшего развития
      FIniFilePath: string;
      FIniFile: TIniFile;

      { проверка существования ini-файла по заданному пути }
      procedure CheckIniFilePath;

      { создание ini-файла как объекта }
      procedure SetIniFile;
end;

implementation

constructor TADOConnectionSetup.Create(DBType: string; IniFilePath: string);
  begin
    FDBType := dbtype;
    FIniFilePath := IniFilePath;
  end;

procedure TADOConnectionSetup.SetSectionSelector(SectionSelector: TStrings);
  begin
    SetIniFile;
    FiniFile.ReadSections(SectionSelector);
//    ShowMessage(SectionSelector.UnitScope);
  end;

function TADOConnectionSetup.GetConnectionString(SelectedSection: string): string;
  var
    strValue: string;
    strValues: TStringList;
    strResult: string;
  begin
    strValues := TStringList.Create;
    FIniFile.ReadSectionValues(SelectedSection, strValues);
    for strValue in strValues do
      strResult := strResult + strValue;
    result := strResult;
  end;

procedure TADOConnectionSetup.SetIniFile;
  begin
    CheckIniFilePath;
    FIniFile := TIniFile.Create(FIniFilePath);
  end;

procedure TADOConnectionSetup.CheckIniFilePath;
  begin
    if not FileExists(FIniFilePath) then raise Exception.Create('Не существует ini-файла подключения');
  end;

end.

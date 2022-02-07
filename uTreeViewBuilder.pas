unit uTreeViewBuilder;

interface
  uses
    FMX.TreeView,
    Data.DB
    ;

type
  TTreeViewData = class
    ID: integer;
    PARENT_ID: integer;
    CAPTION: string;
    FORM_CLS: string;
    CHILDREN: array of TTreeViewData;
  end;

type
  TArrayTreeViewData = array of TTreeViewData;

type
  TTreeViewBuilder = class(TObject)
    public
      FTreeView: TTreeView;
      FDataSet: TDataSet;
      procedure Draw(DataSet: TDataSet; TreeView: TTreeView);
    private
      arrTreeViewData: array of TTreeViewData;
      procedure SetArrayTreeViewDataFromDataSet(DataSet: TDataSet);
      procedure DrawRoot(TreeView: TTreeView);
      procedure DrawBranch(PARENT_ID: integer; TreeViewItem: TTreeViewItem);
      function GetChildrenArray(PARENT_ID: integer): TArrayTreeViewData;
  end;

implementation

  procedure TTreeViewBuilder.Draw(DataSet: TDataSet; TreeView: TTreeView);
    begin
      SetArrayTreeViewDataFromDataSet(DataSet);
      DrawRoot(TreeView);
    end;

  procedure TTreeViewBuilder.SetArrayTreeViewDataFromDataSet(DataSet: TDataSet);
    var
      i: integer;
      TreeViewData: TTreeViewData;
    begin
      DataSet.Active := False;
      DataSet.Active := True;
      for i := 0 to DataSet.RecordCount - 1 do
        begin
          TreeViewData := TTreeViewData.Create;

          TreeViewData.ID := DataSet.fields[0].asInteger;
          TreeViewData.PARENT_ID := DataSet.fields[1].asInteger;
          TreeViewData.CAPTION := DataSet.fields[2].asString;
          TreeViewData.FORM_CLS := DataSet.fields[3].asString;

          SetLength(arrTreeViewData, Length(arrTreeViewData) + 1);
          arrTreeViewData[Length(arrTreeViewData) - 1] := TreeViewData;
          DataSet.Next;
        end;
    end;

  procedure TTreeViewBuilder.DrawRoot(TreeView: TTreeView);
    var
      i: integer;
      TreeViewItem: TTreeViewItem;
    begin
      for I := 0 to length(arrTreeViewData) - 1 do
        begin
          if arrTreeViewData[i].PARENT_ID = 0 then
            begin
              TreeViewItem := TTreeViewItem.Create(FTreeView);
              TreeViewItem.Text := arrTreeViewData[i].CAPTION;
              TreeViewItem.Parent := TreeView;
              DrawBranch(arrTreeViewData[i].ID, TreeViewItem);
            end;
        end;
    end;

  procedure TTreeViewBuilder.DrawBranch(PARENT_ID: integer; TreeViewItem: TTreeViewItem);
    var
      i: integer;
      Branch: TTreeViewItem;
      ChildrenArray: TArrayTreeViewData;
    begin
      ChildrenArray := GetChildrenArray(PARENT_ID);
      for i := 0 to length(ChildrenArray) - 1 do
        begin
          Branch := TTreeViewItem.Create(NIL);
          Branch.Text := ChildrenArray[i].CAPTION;
          TreeViewItem.AddObject(Branch);
          DrawBranch(ChildrenArray[i].ID, Branch);
        end;
    end;

  function TTreeViewBuilder.GetChildrenArray(PARENT_ID: integer): TArrayTreeViewData;
    var
      I: integer;
      ChildrenArray: TArrayTreeViewData;
    begin
      for i := 0 to Length(arrTreeViewData) - 1 do
        begin
          if arrTreeViewData[i].PARENT_ID = PARENT_ID  then
            begin
              SetLength(ChildrenArray, Length(ChildrenArray) + 1);
              ChildrenArray[Length(ChildrenArray) - 1] := arrTreeViewData[i];
            end;
        end;
      result := ChildrenArray;
    end;

end.

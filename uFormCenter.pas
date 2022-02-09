unit uFormCenter;

interface
  uses FMX.Forms;

procedure setFormOnCenter(obj: TForm);

implementation

procedure setFormOnCenter(obj: TForm);
  begin
    obj.left := (Screen.WorkAreaWidth - obj.Width) div 2;
    obj.top := (Screen.WorkAreaHeight - obj.Height) div 2;
  end;

end.

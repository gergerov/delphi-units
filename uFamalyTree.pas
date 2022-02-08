unit uFamalyTree;

interface
uses
  Classes,
  System.SysUtils,
  FMX.Forms, FMX.Memo, FMX.Types, FMX.Edit
  ;

procedure get_parent_class_info(cls: TClass; strings: TStrings; lvl: integer);
procedure draw_info(cls: TClass);
function get_class_info(cls: TClass): string;

implementation

procedure get_parent_class_info(cls: TClass; strings: TStrings; lvl: integer);
  begin
    if cls = TObject then
      exit;
    lvl := lvl + 1;

    strings.Append(
      IntToStr(lvl)
      + ' '
      + cls.ClassParent.ClassName
      + ' '
      + '('
      + cls.ClassParent.UnitName + ':' + cls.ClassParent.UnitScope
      + ')'
    );
    get_parent_class_info(cls.ClassParent, strings, lvl);
  end;

function get_class_info(cls: TClass): string;
  var
    str: string;
  begin
    str := str + cls.ClassName;
    str := str + ' ';
    str := str + '(';
    str := str + cls.UnitName + ':' + cls.UnitScope;
    str := str + ')';
    result := str;
  end;

procedure draw_info(cls: TClass);
  var
    frm: TForm;
    memo: TMemo;
    edit: TEdit;

  begin

    frm := TForm.CreateNew(NIL);

    frm.Width := 450;
    frm.Height := 450;
    frm.left := (Screen.WorkAreaWidth - frm.Width) div 2;
    frm.top := (Screen.WorkAreaHeight - frm.Height) div 2;

    edit := TEdit.Create(frm);
    edit.parent := frm;
    edit.Align := TAlignLayout.Top;
    edit.Text := get_class_info(cls);
    edit.ReadOnly := True;

    memo := TMemo.Create(frm);
    memo.parent := frm;
    memo.Align := TAlignLayout.Client;
    get_parent_class_info(cls, memo.Lines, 0);
    memo.ReadOnly := True;

    frm.ShowModal;

  end;

end.

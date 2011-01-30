unit validator;

interface

uses
  StdCtrls, SysUtils, Dialogs, constant, RegularExpressionsCore, Graphics;

type
  TValidator = class
  strict private
    constructor Create;
  public
    //空值验证
    class procedure EmptyStrCheck(const control: TEdit; const name: string);
    //正则表达式验证
    class procedure RegExCheck(const control: TEdit; const name: string; const regExStr: string);
    //两位小数验证
    class procedure TwoDecimalsCheck(const control: TEdit; const name: string);
    //两位数字验证
    class procedure TwoFiguresCheck(const control: TEdit; const name: string);
    //三位数字验证
    { TODO -oAnders : 需要加入不能输入0 }
    class procedure ThreeFiguresCheck(const control: TEdit; const name: string);
    //两个关联控件验证（A>=B）
    class procedure TwoControlsIntGreatCheck(const greatControl, smallControl: TEdit; const greatName, smallName: string);
    //两个关联控件验证（A<=B）
    class procedure TwoControlsIntSmallCheck(const smallControl, greatControl: TEdit; const smallName, greatName: string);
  end;

implementation

constructor TValidator.Create;
begin
  inherited;
end;

class procedure TValidator.EmptyStrCheck(const control: TEdit; const name: string);
begin
  if CompareStr(Trim(control.Text), EmptyStr) = 0 then
  begin
    control.Color := clRed;
    ShowMessage(name + EMPTY_STR_PROMPT);
    control.SetFocus;
    Abort;
  end
  else
  begin
    control.Color := clWindow;
  end;
end;

class procedure TValidator.RegExCheck(const control: TEdit; const name: string; const regExStr: string);
var
  reg: TPerlRegEx;
begin
  reg := TPerlRegEx.Create;
  reg.Subject := Trim(control.Text);
  reg.RegEx := regExStr;

  if not reg.Match then
  begin
    control.Color := clRed;
    ShowMessage(name + REG_EX_PROMPT);
    control.SetFocus;
    Abort;
  end
  else
  begin
    control.Color := clWindow;
  end;
end;

class procedure TValidator.ThreeFiguresCheck(const control: TEdit; const name: string);
begin
  RegExCheck(control, name, THREE_FIGURES);
end;

class procedure TValidator.TwoControlsIntGreatCheck(const greatControl, smallControl: TEdit; const greatName, smallName: string);
begin
  if StrToInt(Trim(greatControl.Text)) < StrToInt(Trim(smallControl.Text)) then
  begin
    greatControl.Color := clRed;
    ShowMessage(greatName + Format(TWO_CONTROLS_GREAT, [greatName, smallName]));
    greatControl.SetFocus;
    Abort;
  end
  else
  begin
    greatControl.Color := clWindow;
  end;
end;

class procedure TValidator.TwoControlsIntSmallCheck(const smallControl, greatControl: TEdit; const smallName, greatName: string);
begin
  if StrToInt(Trim(smallControl.Text)) > StrToInt(Trim(greatControl.Text)) then
  begin
    smallControl.Color := clRed;
    ShowMessage(smallName + Format(TWO_CONTROLS_SMALL, [smallName, greatName]));
    smallControl.SetFocus;
    Abort;
  end
  else
  begin
    smallControl.Color := clWindow;
  end;
end;

class procedure TValidator.TwoDecimalsCheck(const control: TEdit; const name: string);
begin
  RegExCheck(control, name, TWO_DECIMALS);
end;

class procedure TValidator.TwoFiguresCheck(const control: TEdit; const name: string);
begin
  RegExCheck(control, name, TWO_FIGURES);
end;

end.

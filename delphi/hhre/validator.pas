unit validator;

interface

uses
  StdCtrls, SysUtils, Dialogs, constant, RegularExpressionsCore, Graphics;

type
  TValidator = class
  strict private
    constructor Create;
  public
    //��ֵ��֤
    class procedure EmptyStrCheck(const control: TEdit; const name: string);
    //�������ʽ��֤
    class procedure RegExCheck(const control: TEdit; const name: string; const regExStr: string);
    //��λС����֤
    class procedure TwoDecimalsCheck(const control: TEdit; const name: string);
    //��λ������֤
    class procedure TwoFiguresCheck(const control: TEdit; const name: string);
    //��λ������֤
    { TODO -oAnders : ��Ҫ���벻������0 }
    class procedure ThreeFiguresCheck(const control: TEdit; const name: string);
    //���������ؼ���֤��A>=B��
    class procedure TwoControlsIntGreatCheck(const greatControl, smallControl: TEdit; const greatName, smallName: string);
    //���������ؼ���֤��A<=B��
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
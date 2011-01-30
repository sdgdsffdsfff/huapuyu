unit shhNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBClient, Generics.Collections, config, sql, common,
  CheckLst, RegularExpressionsCore, constant, validator, sqlScript, house;

type
  TFrmNew = class(TForm)
    gbDetailInfo: TGroupBox;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    cmbDecoration: TComboBox;
    cmbConstructYear: TComboBox;
    cmbPropType: TComboBox;
    cmbConstructType: TComboBox;
    cmbPropStruct: TComboBox;
    gbEssentialInfo: TGroupBox;
    Label27: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    edtName: TEdit;
    cmbProvince: TComboBox;
    cmbCity: TComboBox;
    cmbDistrict: TComboBox;
    edtPrice: TEdit;
    edtUnitPrice: TEdit;
    edtBuildingArea: TEdit;
    edtAddress: TEdit;
    edtBedroomCount: TEdit;
    edtLivingRoomCount: TEdit;
    edtKitchenCount: TEdit;
    edtWashroomCount: TEdit;
    edtUsableArea: TEdit;
    cmbDirection: TComboBox;
    edtTotalFloor: TEdit;
    edtFloor: TEdit;
    cmbPropety: TComboBox;
    edtBalconyCount: TEdit;
    Label31: TLabel;
    cmbPropMgtType: TComboBox;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    cmbVisitTime: TComboBox;
    clbFacility: TCheckListBox;
    clbFeature: TCheckListBox;
    memTransport: TMemo;
    memEnvironment: TMemo;
    memRemark: TMemo;
    Label39: TLabel;
    Label40: TLabel;
    btnNew: TButton;
    procedure FormShow(Sender: TObject);
    procedure cmbProvinceChange(Sender: TObject);
    procedure cmbCityChange(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
  private
    procedure Validate(Sender: TWinControl);
  public
    { Public declarations }
  end;

var
  FrmNew: TFrmNew;

implementation

{$R *.dfm}

procedure TFrmNew.btnNewClick(Sender: TObject);
var
  house: THouse;
begin
  TValidator.EmptyStrCheck(edtName, BUILDING_NAME);
  TValidator.EmptyStrCheck(edtAddress, ADDRESS);
  TValidator.EmptyStrCheck(edtPrice, PRICE);
  TValidator.EmptyStrCheck(edtBuildingArea, BUILDING_AREA);
  TValidator.EmptyStrCheck(edtUsableArea, USABLE_AREA);
  TValidator.EmptyStrCheck(edtBedroomCount, BEDROOM);
  TValidator.EmptyStrCheck(edtLivingRoomCount, LIVING_ROOM);
  TValidator.EmptyStrCheck(edtKitchenCount, KITCHEN);
  TValidator.EmptyStrCheck(edtWashroomCount, WASHROOM);
  TValidator.EmptyStrCheck(edtBalconyCount, BALCONY);
  TValidator.EmptyStrCheck(edtTotalFloor, TOTAL_FLOOR);
  TValidator.EmptyStrCheck(edtFloor, FLOOR);

  house := THouse.Create;
  house.Name := Trim(edtName.Text);
  house.ProvinceId := Integer(cmbProvince.Items.Objects[cmbProvince.ItemIndex]);
  house.CityId := Integer(cmbCity.Items.Objects[cmbCity.ItemIndex]);
  house.DistrictId := Integer(cmbDistrict.Items.Objects[cmbDistrict.ItemIndex]);
  house.Address := Trim(edtAddress.Text);
  house.BedroomCount := StrToInt(Trim(edtBedroomCount.Text));
  house.LivingRoomCount := StrToInt(Trim(edtLivingRoomCount.Text));
  house.KitchenCount := StrToInt(Trim(edtKitchenCount.Text));
  house.WashroomCount := StrToInt(Trim(edtWashroomCount.Text));
  house.BalconyCount := StrToInt(Trim(edtBalconyCount.Text));
  house.PropMgtTypeId := Integer(cmbPropMgtType.Items.Objects[cmbPropMgtType.ItemIndex]);
  house.DirectionId := Integer(cmbDirection.Items.Objects[cmbDirection.ItemIndex]);
  house.DecorationId := Integer(cmbDecoration.Items.Objects[cmbDecoration.ItemIndex]);
  house.TotalFloor := StrToInt(Trim(edtTotalFloor.Text));
  house.Floor := StrToInt(Trim(edtFloor.Text));
  house.ConstructYearId := Integer(cmbConstructYear.Items.Objects[cmbConstructYear.ItemIndex]);
  house.Transport := Trim(memTransport.Text);
  house.Environment := Trim(memEnvironment.Text);
  house.Remark := Trim(memRemark.Text);

  ShowMessage(house.Insert);

  ShowMessage(IntToStr(house.Id));

end;

procedure TFrmNew.cmbCityChange(Sender: TObject);
begin
  TCommon.GenComboBoxItem(TSqlScript.GetDistrict(IntToStr(Integer(cmbCity.Items.Objects[cmbCity.ItemIndex]))), cmbDistrict);
end;

procedure TFrmNew.cmbProvinceChange(Sender: TObject);
begin
  TCommon.GenComboBoxItem(TSqlScript.GetCity(IntToStr(Integer(cmbProvince.Items.Objects[cmbProvince.ItemIndex]))), cmbCity);
  TCommon.GenComboBoxItem(TSqlScript.GetDistrict(IntToStr(Integer(cmbCity.Items.Objects[cmbCity.ItemIndex]))), cmbDistrict);
end;

procedure TFrmNew.edtNameExit(Sender: TObject);
begin
  if Sender is TEdit then
    Validate(Sender as TEdit);
end;

procedure TFrmNew.FormShow(Sender: TObject);
begin
  //基本资料
  TCommon.GenComboBoxItem(TSqlScript.GetProvince, cmbProvince);
  TCommon.GenComboBoxItem(TSqlScript.GetCity(IntToStr(Integer(cmbProvince.Items.Objects[cmbProvince.ItemIndex]))), cmbCity);
  TCommon.GenComboBoxItem(TSqlScript.GetDistrict(IntToStr(Integer(cmbCity.Items.Objects[cmbCity.ItemIndex]))), cmbDistrict);
  TCommon.GenComboBoxItem(TSqlScript.GetDirection, cmbDirection);
  TCommon.GenComboBoxItem(TSqlScript.GetPropety, cmbPropety);

  //详细资料
  TCommon.ClearMemoLines(gbDetailInfo);
  TCommon.GenComboBoxItem(TSqlScript.GetPropMgtType, cmbPropMgtType);
  TCommon.GenComboBoxItem(TSqlScript.GetPropType, cmbPropType);
  TCommon.GenComboBoxItem(TSqlScript.GetPropStruct, cmbPropStruct);
  TCommon.GenComboBoxItem(TSqlScript.GetDecoration, cmbDecoration);
  TCommon.GenComboBoxItem(TSqlScript.GetConstructType, cmbConstructType);
  TCommon.GenComboBoxItem(TSqlScript.GetConstructYear, cmbConstructYear);
  TCommon.GenComboBoxItem(TSqlScript.GetVisitTime, cmbVisitTime);
  TCommon.GenCheckListBoxItem(TSqlScript.GetFacility, clbFacility);
  TCommon.GenCheckListBoxItem(TSqlScript.GetFeature, clbFeature);
end;

procedure TFrmNew.Validate(Sender: TWinControl);
begin
  case Sender.TabOrder of
    //楼盘名称
    0:
    begin
      TValidator.EmptyStrCheck(edtName, BUILDING_NAME);
    end;
    //详细地址
    4:
    begin
      TValidator.EmptyStrCheck(edtAddress, ADDRESS);
    end;
    //售价
    5:
    begin
      TValidator.EmptyStrCheck(edtPrice, PRICE);
      TValidator.TwoDecimalsCheck(edtPrice, PRICE);
      if TCommon.ControlValueIsNotEmpty(edtBuildingArea) then
        edtUnitPrice.Text := FormatFloat(FORMAT_TWO_DECIMALS, StrToFloat(Trim(edtPrice.Text)) * FORMAT_TEN_THOUSAND / StrToFloat(Trim(edtBuildingArea.Text)));
    end;
    //建筑面积
    6:
    begin
      TValidator.EmptyStrCheck(edtBuildingArea, BUILDING_AREA);
      TValidator.TwoDecimalsCheck(edtBuildingArea, BUILDING_AREA);
      if TCommon.ControlValueIsNotEmpty(edtPrice) then
        edtUnitPrice.Text := FormatFloat(FORMAT_TWO_DECIMALS, StrToFloat(Trim(edtPrice.Text)) * FORMAT_TEN_THOUSAND / StrToFloat(Trim(edtBuildingArea.Text)));
    end;
    //使用面积
    7:
    begin
      TValidator.EmptyStrCheck(edtUsableArea, USABLE_AREA);
      TValidator.TwoDecimalsCheck(edtUsableArea, USABLE_AREA);
    end;
    //室
    9:
    begin
      TValidator.EmptyStrCheck(edtBedroomCount, BEDROOM);
      TValidator.TwoFiguresCheck(edtBedroomCount, BEDROOM);
    end;
    //厅
    10:
    begin
      TValidator.EmptyStrCheck(edtLivingRoomCount, LIVING_ROOM);
      TValidator.TwoFiguresCheck(edtLivingRoomCount, LIVING_ROOM);
    end;
    //厨
    11:
    begin
      TValidator.EmptyStrCheck(edtKitchenCount, KITCHEN);
      TValidator.TwoFiguresCheck(edtKitchenCount, KITCHEN);
    end;
    //卫
    12:
    begin
      TValidator.EmptyStrCheck(edtWashroomCount, WASHROOM);
      TValidator.TwoFiguresCheck(edtWashroomCount, WASHROOM);
    end;
    //阳台
    13:
    begin
      TValidator.EmptyStrCheck(edtBalconyCount, BALCONY);
      TValidator.TwoFiguresCheck(edtBalconyCount, BALCONY);
    end;
    //总楼层
    15:
    begin
      TValidator.EmptyStrCheck(edtTotalFloor, TOTAL_FLOOR);
      TValidator.ThreeFiguresCheck(edtTotalFloor, TOTAL_FLOOR);
      if TCommon.ControlValueIsNotEmpty(edtFloor) then
        TValidator.TwoControlsIntGreatCheck(edtTotalFloor, edtFloor, TOTAL_FLOOR, FLOOR);
    end;
    //所在楼层
    16:
    begin
      TValidator.EmptyStrCheck(edtFloor, FLOOR);
      TValidator.ThreeFiguresCheck(edtFloor, FLOOR);
      if TCommon.ControlValueIsNotEmpty(edtTotalFloor) then
        TValidator.TwoControlsIntSmallCheck(edtFloor, edtTotalFloor, FLOOR, TOTAL_FLOOR);
    end;
  end;
end;

end.

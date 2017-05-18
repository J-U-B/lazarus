// This code is part of the opsi.org project

// Copyright (c) uib gmbh (www.uib.de)
// This sourcecode is owned by the uib gmbh, D55118 Mainz, Germany
// and published under the Terms of the GNU Affero General Public License.
// Text of the AGPL: http://www.gnu.org/licenses/agpl-3.0-standalone.html
// author: Rupert Roeder, detlef oertel
// credits: http://www.opsi.org/credits/

//***************************************************************************
// Subversion:
// $Revision: 494 $
// $Author: oertel $
// $Date: 2016-08-31 18:26:25 +0200 (Mi, 31 Aug 2016) $
//***************************************************************************


unit opsiclientkioskgui;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, DB,
  //FileUtil,
  ExtendedNotebook,
  //ZMConnection,
  //ZMQueryDataSet,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ComCtrls, Grids, DBGrids, DBCtrls, ockdata, CommCtrl,
  BufDataset, typinfo, installdlg, lcltranslator, oslog, inifiles,
  Variants,
  Lazfileutils;

type

  TProductPanel = class(TFlowPanel)
    LabelId: TLabel;
    LabelName: TLabel;
    LabelState: TLabel;
    //RadioGroupAction: TRadioGroup;
    RadioGroupAction: TGroupbox;
    rbsetup: TRadiobutton;
    rbNone: TRadiobutton;
    rbuninstall: TRadiobutton;
    lbsetup: TLabel;
    lbnone: TLabel;
    lbuninstall: TLabel;
    Button1: TButton;

    procedure Button1Click(Sender: TObject);
    procedure TileActionChanged(Sender: TObject);
    procedure ProductTileClick(Sender: TObject);
    procedure ProductTileChildClick(Sender: TObject);
  private
    { private declarations }
    //FidCaption : String;
    //function getIdCaption : string;
    //procedure setIdCaption(str: string);
  public
    { public declarations }
    constructor Create(TheOwner: TWincontrol);
    destructor Destroy;
    //property idCaption: string read getIdCaption write setIdCaption;
  end;

  TPanels = array of TProductPanel;


  { TFopsiClientKiosk }

  TFopsiClientKiosk = class(TForm)
    BitBtn1: TBitBtn;
    BitBtnShowAction: TBitBtn;
    BitBtnCancel: TBitBtn;
    BitBtnStoreAction: TBitBtn;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBComboBox1: TDBComboBox;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBMemoAdvice: TDBMemo;
    DBMemoDescription: TDBMemo;
    DBTextPriority: TDBText;
    DBTextVerStr: TDBText;
    DBTextClientVerStr: TDBText;
    ExtendedNotebook1: TExtendedNotebook;
    FlowPanelTiles: TFlowPanel;
    Image2: TImage;
    LabelWait: TLabel;
    LabelPriority: TLabel;
    LabelVerstr: TLabel;
    LabelDescription: TLabel;
    LabelDataload: TLabel;
    LabelDataLoadDetail: TLabel;
    LabelAdvice: TLabel;
    LabelClientVerstr: TLabel;
    Panelsearch: TPanel;
    PanelDependencies: TPanel;
    PanelPriority: TPanel;
    PanelDetailsDBText: TPanel;
    PanelDetailsLables: TPanel;
    PanelProgrssbar: TPanel;
    PanelProgressLabel: TPanel;
    PanelProgess: TPanel;
    ProgressBar1: TProgressBar;
    ProgressBarDetail: TProgressBar;
    RadioGroupView: TRadioGroup;
    ScrollBox1: TScrollBox;
    searchEdit: TEdit;
    ImageHeader: TImage;
    datapanel: TPanel;
    BtnUpgrade: TSpeedButton;
    SpeedButtonReload: TSpeedButton;
    SpeedButtonAll: TSpeedButton;
    Splitter1: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TimerSearchEdit: TTimer;
    TitleLabel: TLabel;
    NotebookProducts: TNotebook;
    PageList: TPage;
    PageTile: TPage;
    PanelToolbar: TPanel;
    productlistpanel: TPanel;
    productdetailpanel: TPanel;
    PanelTopImage: TPanel;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    procedure BitBtnInfoClick(Sender: TObject);
    procedure BitBtnShowActionClick(Sender: TObject);
    procedure BitBtnStoreActionClick(Sender: TObject);
    //procedure BtnActionClick(Sender: TObject);
    procedure BtnUpgradeClick(Sender: TObject);
    procedure DBComboBox1Exit(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1ColExit(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBGrid1Exit(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormDestroy(Sender: TObject);
    procedure grouplistEnter(Sender: TObject);
    procedure PageListBeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: integer);
    procedure ProcessMess;
    procedure RadioGroupViewClick(Sender: TObject);
    procedure RadioGroupViewSelectionChanged(Sender: TObject);
    procedure SpeedButtonReloadClick(Sender: TObject);
    procedure Terminate;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure CheckListBox1ShowHint(Sender: TObject; HintInfo: PHintInfo);
    procedure ExtendedNotebook1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //procedure grouplistSelectionChange(Sender: TObject; User: boolean);
    procedure reloadDataFromServer;
    procedure searchEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure RadioGroup1Click(Sender: TObject);
    procedure searchEditEnter(Sender: TObject);
    procedure SpeedButtonAllClick(Sender: TObject);
    procedure SpeedButtonViewListClick(Sender: TObject);
    procedure SpeedButtonViewStoreClick(Sender: TObject);
    procedure TimerSearchEditTimer(Sender: TObject);
    procedure ZMQueryDataSet1NewRecord(DataSet: TDataSet);
    procedure FilterOnSearch;
  private
    { private declarations }
  public
    { public declarations }
  end;

  Tmythread2 = class(TThread)
  public
    procedure Execute; override;
  end;

var
  FopsiClientKiosk: TFopsiClientKiosk;
  StartupDone: boolean;
  ProductTilesArray: TPanels;
  inTileRebuild: boolean = False;
  lastOrderDirAsc: boolean = True;
  lastOrderCol: string;


resourcestring
  rsNoActionsFound = 'No action requests found.';
  rsActRequest = 'Action Request';
  rsActSetup = 'Setup';
  rsActUninstall = 'Uninstall';
  rsActNone = 'None';
  rsInstalled = 'Installed';
  rsNotInstalled = 'Not installed';
  rsStateUnknown = 'Unknown';
  rsViewList = 'List';
  rsViewTiles = 'Tiles';


implementation

{$R *.lfm}

var
  mythread: Tmythread2;
  //tile
  tile_color: string;
  tile_Font_Name: string;
  tile_Font_Size: integer;
  tile_Font_Color: string;
  tile_Font_Bold: boolean;
  tile_Font_Italic: boolean;
  tile_Font_Underline: boolean;
  tile_width: integer;
  tile_height: integer;
  //TileRadio
  tile_radio_setup_color: string;
  tile_radio_uninstall_color: string;
  tile_radio_none_color: string;
  tile_radio_font_size: integer;


function actionRequestToLocale(actionRequest: string): string;
begin
  if actionRequest = 'setup' then
    Result := rsActSetup
  else if actionRequest = 'uninstall' then
    Result := rsActUninstall
  else if actionRequest = 'none' then
    Result := rsActNone
  else
    Result := 'unknown';
end;

function localeToActionRequest(localestr: string): string;
begin
  if localestr = rsActSetup then
    Result := 'setup'
  else if localestr = rsActUninstall then
    Result := 'uninstall'
  else if localestr = rsActNone then
    Result := 'none'
  else
    Result := 'unknown';
end;



constructor TProductPanel.Create(TheOwner: TWincontrol);
begin
  try
  inherited Create(theOwner);
  parent := theOwner;
  Width := tile_width;
  Height := tile_height;
  self.OnClick := ProductTileClick;
  BorderStyle := bsSingle;
  BorderSpacing.Around := 3;
  Color := StringToColor(tile_color);
  Font.Name := tile_Font_Name;
  font.Size := tile_Font_Size;
  font.Color := StringToColor(tile_Font_Color);
  font.Bold := tile_Font_Bold;
  font.Italic := tile_Font_Italic;
  font.Underline := tile_Font_Underline;
  //label ID
  labelId := TLabel.Create(self);
  LabelId.Parent := self;
  LabelId.Caption := 'id';
  LabelId.Font.Style := [fsBold];
  LabelId.Alignment := taCenter;
  LabelId.Width := Width;
  labelId.Align := alTop;
  labelId.BorderSpacing.Around := 3;
  labelId.OnClick := ProductTileChildClick;
  //label Name
  LabelName := TLabel.Create(self);
  LabelName.Parent := self;
  LabelName.Caption := 'name';
  LabelName.Width := Width;
  LabelName.WordWrap := True;
  LabelName.Alignment := taCenter;
  LabelName.Align := alTop;
  LabelName.BorderSpacing.Around := 3;
  LabelName.OnClick := ProductTileChildClick;
  //label LabelState
  LabelState := TLabel.Create(self);
  LabelState.Parent := self;
  LabelState.Caption := 'state';
  LabelState.Width := Width;
  LabelState.WordWrap := True;
  LabelState.Alignment := taCenter;
  LabelState.Align := alTop;
  LabelState.BorderSpacing.Around := 3;
  LabelState.OnClick := ProductTileChildClick;

  //RadioGroupAction
  //RadioGroupAction := TRadioGroup.Create(self);
  RadioGroupAction := TGroupbox.Create(self);
  RadioGroupAction.Parent := self;
  RadioGroupAction.Caption := rsActRequest;
  RadioGroupAction.Font.Size := tile_radio_font_size;
  //RadioGroupAction.Alignment := taCenter;
  RadioGroupAction.Align := alTop;
  //RadioGroupAction.OnClick := self.OnClick;
  RadioGroupAction.OnClick := ProductTileChildClick;
  //RadioGroupAction.OnSelectionChanged := TileActionChanged;

  // radiobuttons
  // none
  rbNone := TRadioButton.Create(self);
  rbNone.Caption := '';
  rbNone.Top := 50;
  rbNone.Align := alTop;
  rbNone.Parent := RadioGroupAction;
  rbNone.OnChange := TileActionChanged;
  rbNone.Tag := 0;
  lbnone := TLabel.Create(self);
  lbnone.Left := 20;
  lbnone.Caption := rsActNone;
  lbnone.Font.Color := StringToColor(tile_radio_none_color);
  lbnone.Parent := RadioGroupAction;
  lbnone.top := rbNone.top;
  lbnone.Left := 20;
  lbnone.Font.Size := tile_radio_font_size;
  lbnone.OnClick := rbnone.OnClick;

  // setup
  rbsetup := TRadioButton.Create(self);
  rbsetup.Caption := '';
  rbsetup.Top := 50;
  rbsetup.Align := alTop;
  rbsetup.Parent := RadioGroupAction;
  rbsetup.OnChange := TileActionChanged;
  rbsetup.Tag := 1;
  rbsetup.Enabled := False;
  lbsetup := TLabel.Create(self);
  lbsetup.Left := 20;
  lbsetup.Caption := rsActSetup;
  lbsetup.Font.Color := StringToColor(tile_radio_setup_color);
  lbsetup.Parent := RadioGroupAction;
  lbsetup.top := rbsetup.top;
  lbsetup.Left := 20;
  lbsetup.Font.Size := tile_radio_font_size;
  lbsetup.Enabled := False;
  lbsetup.OnClick := rbsetup.OnClick;

  // uninstall
  rbuninstall := TRadioButton.Create(self);
  rbuninstall.Caption := '';
  rbuninstall.Top := 50;
  rbuninstall.Align := alTop;
  rbuninstall.Parent := RadioGroupAction;
  rbuninstall.OnChange := TileActionChanged;
  rbuninstall.Tag := 2;
  rbuninstall.Enabled := False;
  lbuninstall := TLabel.Create(self);
  lbuninstall.Left := 20;
  lbuninstall.Caption := rsActUninstall;
  lbuninstall.Font.Color := StringToColor(tile_radio_uninstall_color);
  lbuninstall.Parent := RadioGroupAction;
  lbuninstall.top := rbuninstall.top;
  lbuninstall.Left := 20;
  lbuninstall.Font.Size := tile_radio_font_size;
  lbuninstall.Enabled := False;
  lbuninstall.OnClick := rbuninstall.OnClick;


  (*
  //Button
  Button1 := TButton.Create(self);
  Button1.Parent := self;
  Button1.Caption := 'btn';
  Button1.Width := 80;
  Button1.Height := 20;
  Button1.OnClick := Button1Click;
  *)
   except
      on e: Exception do
      begin
        logdatei.log('Exception TProductPanel.Create', LLError);
        logdatei.log('Exception: ' + E.message, LLError);
      end;
    end;
end;

destructor TProductPanel.Destroy;
begin
  try
    try
      FreeAndNil(labelId);
      FreeAndNil(LabelName);
      FreeAndNil(LabelState);
      FreeAndNil(rbsetup);
      FreeAndNil(rbNone);
      FreeAndNil(rbuninstall);
      FreeAndNil(lbsetup);
      FreeAndNil(lbnone);
      FreeAndNil(lbuninstall);
      FreeAndNil(RadioGroupAction);
      //Button1.Destroy;
    except
      on e: Exception do
      begin
        logdatei.log('Exception TProductPanel.Destroy', LLError);
        logdatei.log('Exception: ' + E.message, LLError);
      end;
    end;
  finally
    //LogDatei.log('TProductPanel.Destroy', LLDebug2);
    inherited Destroy;
  end;

end;


procedure TProductPanel.Button1Click(Sender: TObject);
begin
  //form1.Memo1.Append('click: '+TButton(sender).Parent.tag);
end;

procedure TProductPanel.TileActionChanged(Sender: TObject);
var
  pid, actionstr: string;
  tileindex, actionindex: integer;
begin
  if not inTileRebuild then
  begin
    tileindex := TRadioButton(Sender).Parent.Parent.Tag;
    //actionindex := ProductTilesArray[tileindex].RadioGroupAction.ItemIndex;
    actionindex := TRadioButton(Sender).Tag;
    pid := ProductTilesArray[tileindex].LabelId.Caption;
    ZMQueryDataSet1.First;
    if ZMQueryDataSet1.Locate('ProductId', VarArrayOf([pid]),
      [loCaseInsensitive]) then
    begin
      ZMQueryDataSet1.Edit;
      case actionindex of
        0: actionstr := 'none';
        1: actionstr := 'setup';
        2: actionstr := 'uninstall';
        else
          logdatei.log('Error: Unexpected tag number in TileActionChanged: ' +
            IntToStr(actionindex), LLError);
      end;
      ZMQueryDataSet1.FieldByName('actionrequest').AsString := actionstr;
      FopsiClientKiosk.productdetailpanel.Height := 185;
      ZMQueryDataSet1.Post;
    end;
  end;
end;

procedure TProductPanel.ProductTileClick(Sender: TObject);
var
  pid: string;
  tileindex: integer;
begin
  if not inTileRebuild then
  begin
    tileindex := TProductPanel(Sender).Tag;
    pid := ProductTilesArray[tileindex].LabelId.Caption;
    ZMQueryDataSet1.First;
    if ZMQueryDataSet1.Locate('ProductId', VarArrayOf([pid]),
      [loCaseInsensitive]) then
    begin
      FopsiClientKiosk.productdetailpanel.Height := 185;
    end;
  end;
end;


procedure TProductPanel.ProductTileChildClick(Sender: TObject);
var
  pid: string;
  tileindex: integer;
begin
  if not inTileRebuild then
  begin
    tileindex := TGroupbox(Sender).Parent.Tag;
    pid := ProductTilesArray[tileindex].LabelId.Caption;
    ZMQueryDataSet1.First;
    if ZMQueryDataSet1.Locate('ProductId', VarArrayOf([pid]),
      [loCaseInsensitive]) then
    begin
      FopsiClientKiosk.productdetailpanel.Height := 185;
    end;
  end;
end;

procedure rebuildProductTiles;
var
  counter, i, index: integer;
  action, state: string;
begin
  try
    inTileRebuild := True;
    logdatei.log('rebuildProductTiles start', LLDebug2);
    FopsiClientKiosk.ProgressBarDetail.Visible := True;
    FopsiClientKiosk.ProgressBar1.Visible := True;
    FopsiClientKiosk.LabelDataLoadDetail.Visible := True;
    FopsiClientKiosk.LabelDataLoad.Visible := True;
    FopsiClientKiosk.ProgressbarDetail.Position := 0;
    FopsiClientKiosk.LabelDataload.Caption := 'Clear Tiles';
    Application.ProcessMessages;
    try
      counter := length(ProductTilesArray);
      if counter > 0 then
        //for i:=0 to counter -1 do ProductTilesArray[i].Destroy;
        for i := 0 to counter - 1 do
        begin
          //FreeAndNil(ProductTilesArray[i]);
          ProductTilesArray[i].Visible := False;
          ProductTilesArray[i] := nil;
          ProductTilesArray[i].Free;
          //logdatei.log('FreeAndNil(ProductTilesArray', LLDebug2);
        end;
      SetLength(ProductTilesArray, 0);

    except
      on e: Exception do
      begin
        logdatei.log('Exception rebuildProductTiles: ProductTilesArray[i].Free;',
          LLError);
        logdatei.log('Exception: ' + E.message, LLError);
      end;
    end;
    // use complete window for tiles
    FopsiClientKiosk.productdetailpanel.Height := 0;
    // progess

    FopsiClientKiosk.Progressbar1.Position := 80;
    FopsiClientKiosk.LabelDataload.Caption := 'Fill Tiles';
    FopsiClientKiosk.ProgressbarDetail.max := ZMQUerydataset1.RecordCount;
    Application.ProcessMessages;
    logdatei.log('rebuildProductTiles from db start', LLDebug2);
    counter := 0;
    ZMQUerydataset1.First;
    while not ZMQUerydataset1.EOF do
    begin
      FopsiClientKiosk.LabelDataLoadDetail.Caption :=
        ZMQueryDataSet1.FieldByName('ProductId').AsString;
      Application.ProcessMessages;
      SetLength(ProductTilesArray, counter + 1);
      ProductTilesArray[counter] :=
        TProductPanel.Create(FopsiClientKiosk.FlowPanelTiles);
      ProductTilesArray[counter].LabelId.Caption :=
        ZMQueryDataSet1.FieldByName('ProductId').AsString;
      ProductTilesArray[counter].LabelName.Caption :=
        ZMQueryDataSet1.FieldByName('ProductName').AsString;
      //ProductTilesArray[counter].LabelState.Caption :=
      state := ZMQueryDataSet1.FieldByName('installationStatus').AsString;
      if state = 'installed' then
        ProductTilesArray[counter].LabelState.Caption := rsInstalled
      else if (state = 'not_installed') or (state = 'not installed') or (state = '') then
        ProductTilesArray[counter].LabelState.Caption := rsNotInstalled
      else if state = 'unknown' then
        ProductTilesArray[counter].LabelState.Caption := rsStateUnknown;

      //radio group
      ProductTilesArray[counter].rbsetup.Enabled := True;
      ProductTilesArray[counter].lbsetup.Enabled := True;
      action := Trim(ockdata.ZMQUerydataset1.FieldByName('possibleAction').AsString);
      if (action = 'uninstall') then
      begin
        ProductTilesArray[counter].rbuninstall.Enabled := True;
        ProductTilesArray[counter].lbuninstall.Enabled := True;
      end;
      action := Trim(ockdata.ZMQUerydataset1.FieldByName('actionrequest').AsString);
      if (action = 'none') or (action = '') then
        ProductTilesArray[counter].rbNone.Checked := True
      else if action = 'setup' then
        ProductTilesArray[counter].rbsetup.Checked := True
      else if action = 'uninstall' then
        ProductTilesArray[counter].rbuninstall.Checked := True;

    (*
    ProductTilesArray[counter].RadioGroupAction.Items.Add(rsActNone);
    ProductTilesArray[counter].RadioGroupAction.Items.Add(rsActSetup);
    action := Trim(ockdata.ZMQUerydataset1.FieldByName('possibleAction').AsString);
    if (action <> '') and (action <> 'setup') then
      ProductTilesArray[counter].RadioGroupAction.Items.Add(actionRequestToLocale(action));
    action := Trim(ockdata.ZMQUerydataset1.FieldByName('actionrequest').AsString);
    index := 0;
    index := ProductTilesArray[counter].RadioGroupAction.Items.IndexOf(actionRequestToLocale(action));
    ProductTilesArray[counter].RadioGroupAction.ItemIndex := index;
    //ProductTilesArray[counter].RadioGroupAction.ItemIndex := 0;
    *)
    (*
    //button
    ProductTilesArray[0].Button1.Caption :=
      ZMQueryDataSet1.FieldByName('ProductId').AsString;
    *)

      ProductTilesArray[counter].Tag := counter;
      Inc(counter);
      FopsiClientKiosk.ProgressbarDetail.Position := counter;
      Application.ProcessMessages;
      ZMQUerydataset1.Next;
    end;
  finally
    inTileRebuild := False;
    logdatei.log('rebuildProductTiles stop', LLDebug2);
    FopsiClientKiosk.ProgressBar1.Position := 66;
    FopsiClientKiosk.ProgressBarDetail.Visible := False;
    FopsiClientKiosk.LabelDataLoadDetail.Visible := False;
    FopsiClientKiosk.ProgressBar1.Visible := False;
    FopsiClientKiosk.LabelDataLoad.Visible := False;
  end;
end;

procedure Tmythread2.Execute;
//var
//counter: integer;
//i : integer;
begin
  //counter := 0;
  // write back action requests
  ockdata.ZMQUerydataset1.Filtered := False;
  ockdata.ZMQUerydataset1.Filter := 'ActionRequest  <> ""';
  ockdata.ZMQUerydataset1.Filtered := True;
  ZMQUerydataset1.First;
  while not ZMQUerydataset1.EOF do
  begin
    ockdata.setActionrequest(ZMQUerydataset1.FieldByName('ProductId').AsString,
      ZMQUerydataset1.FieldByName('ActionRequest').AsString);
    ZMQUerydataset1.Next;
    //Inc(counter);
    //FopsiClientKiosk.Progressbar1.Position := counter;
    //Application.ProcessMessages;
  end;
  Terminate;
end;


(*
//http://wiki.freepascal.org/How_to_write_in-memory_database_applications_in_Lazarus/FPC#Sorting_DBGrid_on_TitleClick_event_for_TBufDataSet
function SortBufDataSet(DataSet: TBufDataSet; const FieldName: string): boolean;
var
  i: integer;
  IndexDefs: TIndexDefs;
  IndexName: string;
  IndexOptions: TIndexOptions;
  Field: TField;
begin
  Result := False;
  Field := DataSet.Fields.FindField(FieldName);
  //If invalid field name, exit.
  if Field = nil then
    Exit;
  //if invalid field type, exit.
  if {(Field is TObjectField) or} (Field is TBlobField) or
    {(Field is TAggregateField) or} (Field is TVariantField) or
    (Field is TBinaryField) then
    Exit;
  //Get IndexDefs and IndexName using RTTI
  if IsPublishedProp(DataSet, 'IndexDefs') then
    IndexDefs := GetObjectProp(DataSet, 'IndexDefs') as TIndexDefs
  else
    Exit;
  if IsPublishedProp(DataSet, 'IndexName') then
    IndexName := GetStrProp(DataSet, 'IndexName')
  else
    Exit;
  //Ensure IndexDefs is up-to-date
  IndexDefs.Updated := False;
  {<<<<---This line is critical as IndexDefs.Update will do nothing on the next sort if it's already true}
  IndexDefs.Update;
  //If an ascending index is already in use,
  //switch to a descending index
  if IndexName = FieldName + '__IdxA' then
  begin
    IndexName := FieldName + '__IdxD';
    IndexOptions := [ixDescending];
  end
  else
  begin
    IndexName := FieldName + '__IdxA';
    IndexOptions := [];
  end;
  //Look for existing index
  for i := 0 to Pred(IndexDefs.Count) do
  begin
    if IndexDefs[i].Name = IndexName then
    begin
      Result := True;
      Break;
    end;  //if
  end; // for
  //If existing index not found, create one
  if not Result then
  begin
    if IndexName = FieldName + '__IdxD' then
      DataSet.AddIndex(IndexName, FieldName, IndexOptions, FieldName)
    else
      DataSet.AddIndex(IndexName, FieldName, IndexOptions);
    Result := True;
  end; // if not
  //Set the index
  SetStrProp(DataSet, 'IndexName', IndexName);
end;
*)

{ TFopsiClientKiosk }

procedure TFopsiClientKiosk.ProcessMess;
begin
  Application.ProcessMessages;
end;

procedure TFopsiClientKiosk.RadioGroupViewClick(Sender: TObject);
begin

end;

procedure TFopsiClientKiosk.RadioGroupViewSelectionChanged(Sender: TObject);
begin
  NotebookProducts.PageIndex := RadioGroupView.ItemIndex;
  if StartupDone then
    if RadioGroupView.ItemIndex = 1 then
      rebuildProductTiles;
end;

procedure TFopsiClientKiosk.SpeedButtonReloadClick(Sender: TObject);
begin
  //grouplistSelectionChange(Sender, True);
  reloadDataFromServer;
end;

procedure TFopsiClientKiosk.Terminate;
begin
  Application.Terminate;
end;

procedure TFopsiClientKiosk.DBGrid1TitleClick(Column: TColumn);
var
  direction: string;
begin
  try
    //ockdata.ZMQUerydataset1.SortDataset(Column.FieldName);
    //SortBufDataSet(TBufDataset(ockdata.ZMQUerydataset1), Column.FieldName);
    if ZMQueryDataSet1.Active then
      ZMQueryDataSet1.Close;
    ZMQUerydataset1.SQL.Clear;
    direction := ' ASC';
    if LowerCase(lastOrderCol) = LowerCase(Column.FieldName) then
    begin
      if lastOrderDirAsc then
      begin
        direction := ' DESC';
        lastOrderDirAsc := False;
      end
      else
      begin
        direction := ' ASC';
        lastOrderDirAsc := True;
      end;
    end
    else
      lastOrderCol := Column.FieldName;
    ZMQUerydataset1.SQL.Add('select * from kioskmaster order by ' +
      Column.FieldName + direction);
    ZMQUerydataset1.Open;

  except
  end;
end;

procedure TFopsiClientKiosk.FormDestroy(Sender: TObject);
begin
  LogDatei.log('FopsiClientKiosk.FormDestroy: Application terminates', LLInfo);
end;

procedure TFopsiClientKiosk.grouplistEnter(Sender: TObject);
begin
  productdetailpanel.Height := 0;
end;


procedure TFopsiClientKiosk.PageListBeforeShow(ASender: TObject;
  ANewPage: TPage; ANewIndex: integer);
begin

end;

procedure TFopsiClientKiosk.DBGrid1Exit(Sender: TObject);
begin
  //productdetailpanel.Height := 0;
end;

procedure TFopsiClientKiosk.DBGrid1Enter(Sender: TObject);
begin
  //productdetailpanel.Height := 0;
  //productdetailpanel.Height:=185;
end;

procedure TFopsiClientKiosk.BtnUpgradeClick(Sender: TObject);
begin
  searchEdit.Text:='';
  TimerSearchEdit.Enabled:=false;
  ockdata.ZMQUerydataset1.Filtered := False;
  ockdata.ZMQUerydataset1.FilterOptions := [foCaseInsensitive];
  ockdata.ZMQUerydataset1.Filter := 'updatePossible = "True"';
  ockdata.ZMQUerydataset1.Filtered := True;
  ProcessMess;
  while inTileRebuild do
    Sleep(10);
  if RadioGroupView.ItemIndex = 1 then
    rebuildProductTiles;
end;

procedure TFopsiClientKiosk.DBComboBox1Exit(Sender: TObject);
begin
  DBGrid1.Repaint;
  if DBComboBox1.Text <> '' then
    ockdata.ZMQueryDataSet1.Post;
  //  ockdata.ZMQueryDataSet1.FieldByName('actionrequest').AsString := 'none';
  //ockdata.ZMQueryDataSet1.Post;
end;

(*
procedure TFopsiClientKiosk.BtnActionClick(Sender: TObject);
begin
  ZMQueryDataSet1.Edit;
  ZMQueryDataSet1.FieldByName('actionrequest').AsString := BtnAction.Caption;
  ZMQueryDataSet1.Post;
end;
*)

procedure TFopsiClientKiosk.BitBtnShowActionClick(Sender: TObject);
var
  i: integer;
begin
  // write back action requests
  ockdata.ZMQUerydataset1.Filtered := False;
  //ockdata.ZMQUerydataset1.Filter := ' not ((ActionRequest = "") and (ActionRequest = "none"))';
  ockdata.ZMQUerydataset1.Filter := 'ActionRequest <> ""';
  ockdata.ZMQUerydataset1.Filtered := True;
  ProcessMess;
  RadioGroupViewSelectionChanged(self);
end;

procedure TFopsiClientKiosk.BitBtnInfoClick(Sender: TObject);
begin
  ShowMessage('opsi-kiosk-client' + LineEnding + 'Display language: ' +
    GetDefaultLang + Lineending + 'Version: ' + myVersion + Lineending +
    'CopyRight: uib gmbh (http://uib.de) under AGPLv3' + LineEnding +
    'http://opsi.org' + Lineending + 'Credits to: Lazarus/FPC,indy,sqllite,superobject');
end;

procedure TFopsiClientKiosk.BitBtnStoreActionClick(Sender: TObject);
var
  counter: integer;
  i: integer;
  request: string;
begin
  screen.Cursor := crHourGlass;
  try
    (*
    ProgressBar1.Max := 100;
    ProgressBar1.Min := 0;
    ProgressBar1.Style:=pbstMarquee;
    ProgressBar1.Enabled:=true;
    ProgressBar1.Visible:=true;
    *)
    ProcessMess;
    mythread := Tmythread2.Create(False);
    //mythread.Priority:=tpLowest;
    //mythread.Resume;
    mythread.WaitFor;

    begin
      installdlg.Finstalldlg.Memo1.Text := ockdata.getActionrequests.Text;
      if installdlg.Finstalldlg.Memo1.Text = '' then
        installdlg.Finstalldlg.Memo1.Text := rsNoActionsFound;
      installdlg.Finstalldlg.Show;
    end;

  finally
    mythread.Terminate;
    Screen.Cursor := crDefault;
    ProgressBar1.Style := pbstNormal;
    ProgressBar1.Visible := False;
    FreeAndNil(mythread);
  end;
end;

procedure TFopsiClientKiosk.DBGrid1CellClick(Column: TColumn);
var
  action: string;
begin
  productdetailpanel.Height := 185;
  action := ockdata.ZMQUerydataset1.FieldByName('possibleAction').AsString;
  DBComboBox1.Items.Clear;
  DBComboBox1.Items.Add('none');
  DBComboBox1.Items.Add('setup');
  if action <> 'setup' then
    DBComboBox1.Items.Add(action);
end;

procedure TFopsiClientKiosk.DBGrid1ColExit(Sender: TObject);
begin
  if (dbgrid1.SelectedField.FieldName = DBComboBox1.DataField) then
  begin
    DBComboBox1.Visible := False;
  end;
end;

procedure TFopsiClientKiosk.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
begin
  if (gdFocused in State) then
  begin
    if (dbgrid1.SelectedField.FieldName = DBComboBox1.DataField) then
    begin
      DBComboBox1.Left := Rect.Left + DBGrid1.Left;
      DBComboBox1.Top := Rect.Top + DBGrid1.top;
      DBComboBox1.Width := Rect.Right - Rect.Left;
      DBComboBox1.Visible := True;
    end
    else
    begin
      DBComboBox1.Top := Rect.Top + DBGrid1.top;
    end;
  end;
end;

procedure TFopsiClientKiosk.CheckListBox1ShowHint(Sender: TObject; HintInfo: PHintInfo);
begin

end;

procedure TFopsiClientKiosk.ExtendedNotebook1Change(Sender: TObject);
begin

end;

procedure TFopsiClientKiosk.FormActivate(Sender: TObject);
var
  ErrorMsg: string;
  optionlist: TStringList;

begin
  if not StartupDone then
  begin
    RadioGroupViewSelectionChanged(self);
    StartupDone := True;
    Application.ProcessMessages;
    optionlist := TStringList.Create;
    optionlist.Append('fqdn::');
    optionlist.Append('lang:');
    // quick check parameters
    ErrorMsg := Application.CheckOptions('', optionlist);
    if ErrorMsg <> '' then
    begin
      Application.ShowException(Exception.Create(ErrorMsg));
      Application.Terminate;
      Exit;
    end;

    // parse parameters
    if Application.HasOption('fqdn') then
    begin
      myClientId := Application.GetOptionValue('fqdn');
    end;

    if Application.HasOption('lang') then
    begin
      SetDefaultLang(Application.GetOptionValue('lang'));
    end;

    ockdata.main;
    Progressbar1.Position := Progressbar1.Max;
    ProgressbarDetail.Position := ProgressbarDetail.Max;
    LabelDataload.Caption := '';
    LabelDataLoadDetail.Caption := '';
    ProgressBar1.Visible := False;
    ProgressBarDetail.Visible := False;
    LabelWait.Visible := False;
    //grouplist.Enabled := True;
    RadioGroupViewSelectionChanged(self);
  end;
end;

procedure TFopsiClientKiosk.FormShow(Sender: TObject);
begin
  LabelDataload.Caption := 'Init';
  StartupDone := False;
end;

(*
procedure TFopsiClientKiosk.grouplistSelectionChange(Sender: TObject; User: boolean);
begin

end;
*)

procedure TFopsiClientKiosk.reloadDataFromServer;
var
  i: integer;
begin
  ockdata.fetchProductData_by_getKioskProductInfosForClient;
  (*
  ProgressBar1.Visible := True;
  ProgressBarDetail.Visible := True;
  LabelWait.Visible := True;
  grouplist.Enabled := False;

  if (grouplist.Items.Count <= 0) or ('' = grouplist.Items.Strings[0]) then
  begin
    LogDatei.log('No productgroups found', LLError);
    Fopsiclientkiosk.StatusBar1.Panels[0].Text := rsNoGroups;
  end
  else
  begin
    // fill product list
    if grouplist.SelCount = 0 then
    begin
      ; // clear product list
      ockdata.ZMQUerydataset1.EmptyDataSet;
      ockdata.ZMQUerydataset1.Open;
      ockdata.ZMQUerydataset2.EmptyDataSet;
      ockdata.ZMQUerydataset2.Open;
      ockdata.ZMQUerydataset2.MasterFields.Clear;
      ockdata.ZMQUerydataset2.MasterDetailFiltration := False;
    end
    else
    begin
      ockdata.ZMQUerydataset1.EmptyDataSet;
      ockdata.ZMQUerydataset1.Open;
      ockdata.ZMQUerydataset2.EmptyDataSet;
      ockdata.ZMQUerydataset2.Open;
      ockdata.ZMQUerydataset2.MasterFields.Clear;
      ockdata.ZMQUerydataset2.MasterDetailFiltration := False;
      productIdsList.Clear;
      if grouplist.Items.Count = 1 then
      begin
        fillproductsbygroup(grouplist.Items.Strings[0]);
        ockdata.fetchProductData;
      end
      else
      begin
        if grouplist.Selected[0] and (grouplist.Count > 1) then
        begin
          // 'All groups' are selected
          for i := 1 to grouplist.Items.Count - 1 do
            fillproductsbygroup(grouplist.Items.Strings[i]);
          ockdata.fetchProductData;
        end
        else
        begin
          for i := 1 to grouplist.Items.Count - 1 do
            if grouplist.Selected[i] then
              fillproductsbygroup(grouplist.Items.Strings[i]);
          ockdata.fetchProductData;
        end;
      end;
    end;
    ZMQUerydataset2.MasterFields.Add('ProductId');
    //ZMQUerydataset2.MasterReferentialKeys.;
    try
      ZMQUerydataset2.MasterDetailFiltration := True;
    except
    end;
  end;
  LabelDataload.Caption := '';
  LabelDataLoadDetail.Caption := '';
  ProgressBar1.Visible := False;
  ProgressBarDetail.Visible := False;
  LabelWait.Visible := False;
  grouplist.Enabled := True;
  *)
  RadioGroupViewSelectionChanged(self);
end;

procedure TFopsiClientKiosk.searchEditChange(Sender: TObject);
begin
  // search in list
  // if timer running: reset else start (so we wait to finish the input before seach)
  if TimerSearchEdit.Enabled then
  begin
    TimerSearchEdit.Enabled := False;
    logdatei.log('Got while input wait:' + searchEdit.Text, LLDebug2);
  end
  else
    logdatei.log('Got and start input wait:' + searchEdit.Text, LLDebug2);
  // start search via timer
  TimerSearchEdit.Enabled := True;
  //SpeedButton1Click(Sender);
end;

procedure TFopsiClientKiosk.FormCreate(Sender: TObject);
var
  skinpath: string;
  myini: TInifile;
begin
  // Load custom skin
  skinpath := Application.Location + PathDelim + 'opsiclientkioskskin' + PathDelim;
  if FileExistsUTF8(skinpath + 'opsiclientkiosk.png') then
  begin
    ImageHeader.Picture.LoadFromFile(skinpath + 'opsiclientkiosk.png');
  end;
  //tile
  tile_color := 'clSkyBlue';
  tile_Font_Name := 'Arial';
  tile_Font_Size := 11;
  tile_Font_Color := 'clBlack';
  tile_Font_Bold := False;
  tile_Font_Italic := False;
  tile_Font_Underline := False;
  tile_width := 200;
  tile_height := 200;
  //TileRadio
  tile_radio_setup_color := 'clRed';
  tile_radio_uninstall_color := 'clBlue';
  tile_radio_none_color := 'clBlack';
  tile_radio_font_size := 10;
  if FileExists(skinpath + 'opsiclientkiosk.ini') then
  begin
    myini := TIniFile.Create(skinpath + 'opsiclientkiosk.ini');
    TitleLabel.Caption :=
      myini.ReadString('TitleLabel', 'text', 'opsi Client Kiosk');
    TitleLabel.Font.Name := myini.ReadString('TitleLabel', 'FontName', 'Arial');
    TitleLabel.Font.Size := myini.ReadInteger('TitleLabel', 'FontSize', 12);
    TitleLabel.Font.Color := StringToColor(myini.ReadString('TitleLabel', 'FontColor', 'clBlack'));
    TitleLabel.Font.Bold := myini.ReadBool('TitleLabel', 'FontBold', True);
    TitleLabel.Font.Italic := myini.ReadBool('TitleLabel', 'FontItalic', False);
    TitleLabel.Font.Underline := myini.ReadBool('TitleLabel', 'FontUnderline', False);
    //tile
    tile_color := myini.ReadString('Tile', 'color', tile_color);
    tile_Font_Name := myini.ReadString('Tile', 'FontName', tile_Font_Name);
    tile_Font_Size := myini.ReadInteger('Tile', 'FontSize', tile_Font_Size);
    tile_Font_Color := myini.ReadString('Tile', 'FontColor', tile_Font_Color);
    tile_Font_Bold := myini.ReadBool('Tile', 'FontBold', tile_Font_Bold);
    tile_Font_Italic := myini.ReadBool('Tile', 'FontItalic', tile_Font_Italic);
    tile_Font_Underline := myini.ReadBool('Tile', 'FontUnderline', tile_Font_Underline);
    tile_width := myini.ReadInteger('Tile', 'Width', tile_width);
    tile_height := myini.ReadInteger('Tile', 'Height', tile_height);
    //TileRadio
    tile_radio_setup_color := myini.ReadString('TileRadio', 'setup_color',
      tile_radio_setup_color);
    tile_radio_uninstall_color :=
      myini.ReadString('TileRadio', 'uninstall_color', tile_radio_uninstall_color);
    tile_radio_none_color := myini.ReadString('TileRadio', 'none_color',
      tile_radio_none_color);
    tile_radio_font_size := myini.ReadInteger('TileRadio', 'fontsize',
      tile_radio_font_size);

    myini.Free;
    (*
    [TitleLabel]
    Text= opsi Client Kiosk
    FontName = Arial
    FontSize = 20
    FontColor = $00000000
    FontBold = false
    FontItalic = false
    FontUnderline = false
    *)
  end;

  // skinpath in opsiclientagent custom dir
  skinpath := Application.Location + PathDelim +
    '..\custom\opsiclientkioskskin' + PathDelim;
  if FileExistsUTF8(skinpath + 'opsiclientkiosk.png') then
  begin
    ImageHeader.Picture.LoadFromFile(skinpath + 'opsiclientkiosk.png');
  end;
  if FileExistsUTF8(skinpath + 'opsiclientkiosk.ini') then
  begin
    myini := TIniFile.Create(skinpath + 'opsiclientkiosk.ini');
    TitleLabel.Caption :=
      myini.ReadString('TitleLabel', 'text', 'opsi Client Kiosk');
    TitleLabel.Font.Name := myini.ReadString('TitleLabel', 'FontName', 'Arial');
    TitleLabel.Font.Size := myini.ReadInteger('TitleLabel', 'FontSize', 20);
    TitleLabel.Font.Color := myini.ReadInteger('TitleLabel', 'FontColor', $00000000);
    TitleLabel.Font.Bold := myini.ReadBool('TitleLabel', 'FontBold', True);
    TitleLabel.Font.Italic := myini.ReadBool('TitleLabel', 'FontItalic', False);
    TitleLabel.Font.Underline := myini.ReadBool('TitleLabel', 'FontUnderline', False);
    myini.Free;
    (*
    [TitleLabel]
    Text= opsi Client Kiosk
    FontName = Arial
    FontSize = 20
    FontColor = $00000000
    FontBold = false
    FontItalic = false
    FontUnderline = false
    *)
  end;
  GetDefaultLang;
  //grouplist.Clear;
  DBGrid1.Columns.Add.FieldName := 'ProductId';
  DBGrid1.Columns.Items[0].Title.Caption := 'ProductId';
  DBGrid1.Columns.Items[0].Width := 150;
  DBGrid1.Columns.Add.FieldName := 'ProductName';
  DBGrid1.Columns.Items[1].Width := 300;
  DBGrid1.Columns.Add.FieldName := 'InstallationStatus';
  DBGrid1.Columns.Items[2].Title.Caption := 'InstallationStatus';
  DBGrid1.Columns.Items[2].Width := 100;
  DBGrid1.Columns.Add.FieldName := 'actionrequest';
  DBGrid1.Columns.Items[3].Title.Caption := 'ActionRequest';
  DBGrid1.Columns.Items[3].Width := 100;
  //DBGrid1.Columns.Add.FieldName := 'updatePossible';
  //DBGrid1.Columns.Items[4].Title.Caption := 'updatePossible';
  //DBGrid1.Columns.Items[4].Width := 100;


  DBGrid2.Columns.Add.FieldName := 'requiredProductId';
  DBGrid2.Columns.Items[0].Title.Caption := 'requiredProductId';
  DBGrid2.Columns.Items[0].Width := 300;
  DBGrid2.Columns.Add.FieldName := 'required';
  DBGrid2.Columns.Items[1].Title.Caption := 'required';
  DBGrid2.Columns.Items[1].Width := 100;
  DBGrid2.Columns.Add.FieldName := 'prerequired';
  DBGrid2.Columns.Items[2].Title.Caption := 'pre-required';
  DBGrid2.Columns.Items[2].Width := 100;
  DBGrid2.Columns.Add.FieldName := 'postrequired';
  DBGrid2.Columns.Items[3].Title.Caption := 'post-required';
  DBGrid2.Columns.Items[3].Width := 100;

  // localize RadioGroupView
  RadioGroupView.Items[0] := rsViewList;
  RadioGroupView.Items[1] := rsViewTiles;

  //ockdata.initdb;
  (*
  //DataSource1.DataSet:= ockdata.ZMQUerydataset2;
  DataSource1.DataSet := ZMQUerydataset1;
  DBGrid1.DataSource := DataSource1;
  DataSource2.DataSet := ockdata.ZMQUerydataset2;
  DBGrid2.DataSource := DataSource2;
  //ZMQUerydataset2.MasterSource := DataSource1;
  ZMQUerydataset2.DataSource := DataSource1;
  LabelDataload.Caption := '';
  LabelDataLoadDetail.Caption := '';
  Progressbar1.Position := 0;
  ProgressBar1.Max := 8;
  ProgressbarDetail.Position := 0;
  //ProgressBar1.Brush.Color:=clBlue;
  //ProgressbarDetail.Brush.Color:=clBlue;
  //progressbar1.Perform(PBM_SETBARCOLOR, 0, clBlue);
  //SendMessage(ProgressBar1.Handle, PBM_SETBARCOLOR, 0, clBlue);
  productdetailpanel.Height := 0;
  //ZMReferentialKey1.MasterDataSet := ZMQUerydataset1;
  //ZMReferentialKey1.SlaveDataSet := ZMQUerydataset2;
  //ZMReferentialKey1.JoinedFields.Add('ProductId=ProductId');
  *)
end;

(*
procedure TFopsiClientKiosk.RadioGroup1Click(Sender: TObject);
begin
  NotebookProducts.PageIndex := RadioGroupView.ItemIndex;
end;
*)

procedure TFopsiClientKiosk.searchEditEnter(Sender: TObject);
begin
  productdetailpanel.Height := 0;
end;


procedure TFopsiClientKiosk.FilterOnSearch;
var
  Filtercond, Filterstr: string;
begin
  // search in list
  //ockdata.ZMQUerydataset1.SQL.Text:='select * from kiosk where ProductId like %'+searchedit.Text+'%;';
  //ockdata.ZMQUerydataset1.QueryExecute;
  //LogDatei.log('Filter for: '+searchedit.Text,LLinfo);
  if searchedit.Text = '' then
  begin
    Filtercond := '"*"';
    ockdata.ZMQUerydataset1.Filtered := False;
    LogDatei.log('Search for: ' + searchedit.Text + ' Filter off.', LLinfo);
  end
  else
  begin
    Filtercond := '"*' + searchedit.Text + '*"';
    LogDatei.log('Serach for: ' + searchedit.Text + ' Filter for: ' +
      Filtercond, LLinfo);
    Filterstr := 'ProductId =' + Filtercond;
    Filterstr := Filterstr + 'or ProductName =' + Filtercond;
    Filterstr := Filterstr + 'or DESCRIPTION =' + Filtercond;
    Filterstr := Filterstr + 'or ADVICE =' + Filtercond;
    Filterstr := Filterstr + 'or INSTALLATIONSTATUS =' + Filtercond;
    ockdata.ZMQUerydataset1.Filter := Filterstr;
    ockdata.ZMQUerydataset1.FilterOptions := [foCaseInsensitive];
    ockdata.ZMQUerydataset1.Filtered := True;
  end;
  if RadioGroupView.ItemIndex = 1 then
    rebuildProductTiles;
end;

procedure TFopsiClientKiosk.SpeedButtonAllClick(Sender: TObject);
begin
  if searchedit.Text = '' then
    FilterOnSearch
  else
    searchedit.Text := '';
  // this shoud call  searchEditChange
  // so we do nothing else here
  (*
  ockdata.ZMQUerydataset1.Filter := '"*"';
  ockdata.ZMQUerydataset1.Filtered := False;
  if RadioGroupView.ItemIndex = 1 then
    rebuildProductTiles;
    *)
end;

procedure TFopsiClientKiosk.SpeedButtonViewListClick(Sender: TObject);
begin
  NotebookProducts.PageIndex := 0;
end;

procedure TFopsiClientKiosk.SpeedButtonViewStoreClick(Sender: TObject);
begin
  NotebookProducts.PageIndex := 1;
end;

procedure TFopsiClientKiosk.TimerSearchEditTimer(Sender: TObject);
begin
  TimerSearchEdit.Enabled := False;
  while inTileRebuild do
    Sleep(10);
  FilterOnSearch;
end;


procedure TFopsiClientKiosk.ZMQueryDataSet1NewRecord(DataSet: TDataSet);
begin

end;

procedure TFopsiClientKiosk.BitBtnCancelClick(Sender: TObject);
var
  counter, i: integer;
begin
  if opsidata <> nil then
  begin
    // do not send log
    //opsidata.finishOpsiConf;
    opsidata.Free;
  end;
  try
    counter := length(ProductTilesArray);
    if counter > 0 then
      //for i:=0 to counter -1 do ProductTilesArray[i].Destroy;
      for i := 0 to counter - 1 do
      begin
        ProductTilesArray[i] := nil;
        ProductTilesArray[i].Free;
        logdatei.log('FreeAndNil(ProductTilesArray', LLDebug2);
      end;
    SetLength(ProductTilesArray, 0);

  except
    on e: Exception do
    begin
      logdatei.log('Exception BitBtnCancelClick: ProductTilesArray[i].Free;', LLError);
      logdatei.log('Exception: ' + E.message, LLError);
    end;
  end;

  Application.Terminate;
  halt;
end;

end.

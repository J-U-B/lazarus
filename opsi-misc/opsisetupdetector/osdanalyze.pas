unit osdanalyze;

{$mode delphi}

interface

uses
  {$IFDEF WINDOWS}
  Windows,
  ShlObj,
  Registry,
  {$ENDIF WINDOWS}
  LCLType,
  Classes,
  osdhelper,
  Process,
  fileutil,
  SysUtils,
  oslog,
  osdbasedata;


const

  SetupType_AdvancedMSI = 'AdvancedMSI';
  SetupType_Inno = 'Inno';
  SetupType_InstallShield = 'InstallShield';
  SetupType_InstallShieldMSI = 'InstallShieldMSI';
  SetupType_MSI = 'MSI';
  SetupType_NSIS = 'NSIS';
  SetupType_7zip = '7zip';


procedure get_aktProduct_general_info(installerId: TKnownInstaller; myfilename: string; var mysetup : TSetupFile);
procedure get_msi_info(myfilename: string; var mysetup : TSetupFile);
procedure get_inno_info(myfilename: string; var mysetup : TSetupFile);
procedure get_installshield_info(myfilename: string; var mysetup : TSetupFile);
procedure get_installshieldmsi_info(myfilename: string; var mysetup : TSetupFile);
procedure get_advancedmsi_info(myfilename: string; var mysetup : TSetupFile);
procedure get_nsis_info(myfilename: string; var mysetup : TSetupFile);
//procedure stringsgrep(myfilename: string; verbose,skipzero: boolean);
procedure Analyze(FileName: string; var mysetup : TSetupFile);
procedure grepmsi(instring: string);
//procedure grepmarker(instring: string);
function analyze_binary(myfilename: string; verbose, skipzero: boolean; var mysetup : TSetupFile): TKnownInstaller;
function getPacketIDfromFilename(str: string): string;
function getPacketIDShort(str: string): string;
function ExtractVersion(str: string): string;



implementation

uses
  resultform;

function getPacketIDfromFilename(str: string): string;
var
  strnew: string;
  i: integer;
  myChar: char;
begin
  strnew := '';
  for i := 1 to Length(str) do
  begin
    myChar := str[i];
    if myChar in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-'] then
      strnew := strnew + myChar
    else
    if (myChar <> #195) then
      strnew := strnew + '-';
  end;
  Result := strnew;
end;


function getPacketIDShort(str: string): string;
var
  strnew: string;
  i: integer;
  myChar: char;
  preChar: char = ' ';
begin
  strnew := '';
  str := lowercase(str);
  for i := 1 to Length(str) do
  begin
    myChar := str[i];
    if myChar in ['a'..'z', '0'..'9', '_', '-'] then
    begin
      strnew := strnew + myChar;
      preChar := myChar;
    end
    else
    begin
      if ((myChar <> #195) and (i > 1) and (strnew[Length(strnew) - 1] <> '_') and
        (strnew[Length(strnew) - 1] <> '-') and (i < Length(str))) then
        if (preChar <> '-') then
        begin
          strnew := strnew + '-';
          preChar := '-';
        end;
    end;
  end;
  Result := strnew;
end;


function ExtractVersion(str: string): string;
var
  i: integer;
  outstr: string = '';
begin
  str := StringReplace(str, 'w32', '', [rfReplaceAll, rfIgnoreCase]);
  str := StringReplace(str, 'w64', '', [rfReplaceAll, rfIgnoreCase]);
  str := StringReplace(str, 'win32', '', [rfReplaceAll, rfIgnoreCase]);
  str := StringReplace(str, 'win64', '', [rfReplaceAll, rfIgnoreCase]);
  for i := 1 to Length(str) do
  begin
    if str[i] in ['0'..'9', '.'] then
    begin
      if (Length(outstr) > 0) and (not (str[i - 1] in ['0'..'9', '.'])) then
        outstr := '';
      outstr := outstr + str[i];
    end
    else;
  end;
  Result := outstr;
end;

function grepexe(instring: string): string;
var
  lowerstring: string;
begin
  Result := '';
  lowerstring := lowercase(instring);
  if (0 < pos('installshield', lowerstring)) or (0 < pos('inno', lowerstring)) or
    (0 < pos('wise', lowerstring)) or (0 < pos('nullsoft', lowerstring)) or
    (0 < pos('wixquery', lowerstring)) or
    (0 < pos('product_build_number{', lowerstring)) or
    (0 < pos('productcode{', lowerstring)) or (0 < pos('msiexec', lowerstring)) or
    (0 < pos('extract', lowerstring)) or
    // (0 < pos('setup', lowerstring)) or
    (0 < pos('installer', lowerstring)) then
    Result := instring;
end;

procedure analyze_binstr(instring: string; var mysetup : TSetupFile);
var
  lowerstring: string;
  counter: integer;
  aktId: TKnownInstaller;


  procedure check_line_for_installer(line: string; instId: TKnownInstaller; var mysetup : TSetupFile);
  var
    i: integer;
  begin
    for i := 0 to installerArray[integer(instId)].patterns.Count - 1 do
    begin
      //LogDatei.log('check: ' + line + ' for: ' + installerToInstallerstr(instId), LLDebug2);
      if 0 <> pos(LowerCase(installerArray[integer(instId)].patterns[i]), line) then
      begin
        //aktProduct.markerlist.add(installerArray[integer(instId)].Name + IntToStr(i));
        mysetup.markerlist.add(installerArray[integer(instId)].patterns[i]);
        LogDatei.log('For: ' + installerToInstallerstr(instId) +
          ' found: ' + LowerCase(installerArray[integer(instId)].patterns[i]), LLinfo);
      end;
    end;
  end;

begin
  lowerstring := lowercase(instring);
  for counter := 0 to knownInstallerList.Count - 1 do
  begin
    aktId := installerArray[counter].installerId;
    if aktId <> stUnknown then
    begin
      check_line_for_installer(lowerstring, aktId, mysetup);
    end;
  end;
end;

(*
procedure grepmarker(instring: string);
var lowerstring: string;
begin
  lowerstring := lowercase(instring);
  if (0 < pos('installer,msi,database', lowerstring))  then begin
     markerEmbeddedMSI := true;
  end;
  if (0 < pos('installshield', lowerstring)) then begin
     markerInstallShield := true;
  end;
  if (markerEmbeddedMSI and markerInstallShield) then begin
     mywrite('found strings "Installer,MSI,Database" and "InstallShield"');
     mywrite('detected InstallShield+MSI Setup (InstallShield with embedded MSI)');
     setupType := SetupType_InstallShieldMSI;
  end;
  if (markerInstallShield and ((0 < pos('<description>InstallShield.Setup</description>', instring))) or ((0 < pos('InstallShield', instring)))) then begin
     mywrite('found string "<description>InstallShield.Setup</description>" or "InstallShield"');
     mywrite('detected InstallShield Setup');
     setupType := SetupType_InstallShield;
  end;
  if (0 < pos('inno', lowerstring)) and ((0 < pos('<description>inno setup</description>', lowerstring)) or (0 < pos('jr.inno.setup', lowerstring))) then begin
     mywrite('found string "<description>Inno Setup</description>" or "JR.Inno.Setup"');
     mywrite('detected Inno Setup');
     setupType := SetupType_Inno;
  end;
  if (0 < pos('nullsoft', lowerstring)) and ((0 < pos('Nullsoft.NSIS.exehead', lowerstring)) or (0 < pos('nullsoft install system', lowerstring))) then begin
      if (0 < pos('nullsoft.nsis.exehead', lowerstring)) then
         mywrite('found string "Nullsoft.NSIS.exehead"')
      else
         mywrite('found string "Nullsoft Install System"');
     mywrite('detected NSIS Setup');
     setupType := SetupType_NSIS;
  end;
  if (0 < pos('name="microsoft.windows.advancedinstallersetup"', lowerstring))  then begin
     mywrite('found string "microsoft.windows.advancedinstallersetup"');
     mywrite('detected Advanced Setup (with embedded MSI)');
     setupType := SetupType_AdvancedMSI;
  end;
end;
 *)

procedure grepmsi(instring: string);
begin
  if (0 < pos('product_build_number{', lowercase(instring))) or
    (0 < pos('productcode{', lowercase(instring))) then
    mywrite(instring);
end;

procedure get_aktProduct_general_info(installerId: TKnownInstaller; myfilename: string; var mysetup : TSetupFile);
var
  myoutlines: TStringList;
  myreport: string;
  myexitcode: integer;
  i: integer;
  fsize: int64;
  fsizemb, rsizemb: double;
  sMsiSize: string;
  sReqSize: string;
  sFileSize: string;
  sSearch: string;
  iPos: integer;
  destDir: string;
  myBatch: string;
  product: string;
  installerstr: string;

begin
  installerstr := installerToInstallerstr(installerId);
  Mywrite('Analyzing ' + installerstr + ' Setup: ' + myfilename);

  mysetup.installerId := installerId;
  mysetup.setupFullFileName := myfilename;
  //mysetup.setupFileNamePath := ExtractFileDir(myfilename);

  product := ExtractFileNameWithoutExt(mysetup.setupFileName);
  aktProduct.produktpropties.productId := getPacketIDShort(product);
  aktProduct.produktpropties.productName := product;

  fsize := fileutil.FileSize(myfilename);
  fsizemb := fsize / (1024 * 1024);
  rsizemb := fsizemb * 6;
  sFileSize := FormatFloat('##0.0', fsizemb) + ' MB';
  sReqSize := FormatFloat('###0', rsizemb) + ' MB';

  mywrite('Setup file size is: ' + sFileSize);
  mywrite('Estimated required space is: ' + sReqSize);
  mywrite('........');

  if fsizemb < 1 then
    fsizemb := 1;

  sFileSize := FormatFloat('#', fsizemb) + ' MB';
  sReqSize := FormatFloat('#', rsizemb) + ' MB';
  mysetup.requiredSpace := round(rsizemb);
  mysetup.setupFileSize := round(fsizemb);

end; //get_aktProduct_general_info



procedure get_msi_info(myfilename: string; var mysetup : TSetupFile);
var
  mycommand: string;
  myoutlines: TStringList;
  myreport: string;
  myexitcode: integer;
  i: integer;

  sSearch: string;
  iPos: integer;

begin
  Mywrite('Analyzing MSI: ' + myfilename);
  {$IFDEF WINDOWS}
  mycommand := 'cmd.exe /C cscript.exe "' + ExtractFilePath(ParamStr(0)) +
    'msiinfo.js" "' + myfilename + '"';
  mywrite(mycommand);
  myoutlines := TStringList.Create;
  if not RunCommandAndCaptureOut(mycommand, True, myoutlines, myreport,
    SW_SHOWMINIMIZED, myexitcode) then
  begin
    mywrite('Failed to analyze: ' + myreport);
  end
  else
  begin
    mysetup.installerId := stMsi;
    //resultForm1.Edit_installer_type.Text := installerToInstallerstr(stMsi);
    //resultForm1.EditMSI_file.Text := myfilename;
    mywrite('........');
    mysetup.setupFullFileName := myfilename;
    //mysetup.setupFileNamePath := ExtractFileDir(myfilename);
    (*
    resultForm1.EditMSI_ProductName.Text := '';
    resultForm1.EditMSI_ProductVersion.Text := '';
    resultForm1.EditMSI_ProductCode.Text := '';
    *)
    for i := 0 to myoutlines.Count - 1 do
    begin
      mywrite(myoutlines.Strings[i]);

      // sSearch := 'Manufacturer: ';
      // iPos := Pos (sSearch, myoutlines.Strings[i]);
      // if (iPos <> 0) then
      //   resultForm1.Edit2.Text := Copy(myoutlines.Strings[i], Length(sSearch)+1, Length(myoutlines.Strings[i])-Length(sSearch));

      sSearch := 'ProductName: ';
      iPos := Pos(sSearch, myoutlines.Strings[i]);
      if (iPos <> 0) then
        aktProduct.produktpropties.productName :=
          Copy(myoutlines.Strings[i], Length(sSearch) + 1,
          Length(myoutlines.Strings[i]) - Length(sSearch));

      sSearch := 'ProductVersion: ';
      iPos := Pos(sSearch, myoutlines.Strings[i]);
      if (iPos <> 0) then
        mysetup.softwareversion :=
          Copy(myoutlines.Strings[i], Length(sSearch) + 1,
          Length(myoutlines.Strings[i]) - Length(sSearch));

      sSearch := 'ProductCode: ';
      iPos := Pos(sSearch, myoutlines.Strings[i]);
      if (iPos <> 0) then
        mysetup.msiId :=
          Copy(myoutlines.Strings[i], Length(sSearch) + 1,
          Length(myoutlines.Strings[i]) - Length(sSearch));

    end;
    if aktproduct.produktpropties.productversion = '' then
      aktproduct.produktpropties.productversion :=mysetup.softwareversion;
  end;
  myoutlines.Free;
    {$ENDIF WINDOWS}
  mywrite('get_MSI_info finished');

  Mywrite('Finished Analyzing MSI: ' + myfilename);
  resultForm1.PageControl1.ActivePage := resultForm1.TabSheetAnalyze;
  if showMSI then
    resultForm1.PageControl1.ActivePage := resultForm1.TabSheetSetup1;
  //resultForm1.PageControl1.ActivePage := resultForm1.TabSheetMSI;
end;


procedure get_inno_info(myfilename: string; var mysetup : TSetupFile);
var
  myoutlines: TStringList;
  myreport: string;
  myexitcode: integer;
  i: integer;
  fsize: int64;
  fsizemb: double;
  rsizemb: double;
  sFileSize: string;
  sReqSize: string;
  sSearch: string;
  iPos: integer;
  destDir: string;
  destfile: string;
  myCommand: string;
  installScriptISS: string;
  issLine: string = '';
  fISS: Text;
  // components from install_script.iss[setup]
  AppName: string = '';
  AppVersion: string = '';
  AppVerName: string = '';
  DefaultDirName: string = '';
  tmpint: integer;

begin
  Mywrite('Analyzing Inno-Setup:');
  AppName := '';
  AppVersion := '';
  AppVerName := '';
  DefaultDirName := '';
  ArchitecturesInstallIn64BitMode := '';
  {$IFDEF WINDOWS}

  myoutlines := TStringList.Create;
  destDir := GetTempDir(False);
  destDir := destDir + DirectorySeparator + 'INNO';
  if not DirectoryExists(destDir) then
    CreateDir(destDir);
  destfile := ExtractFileName(myfilename);
  destfile := ExtractFileName(destfile);
  installScriptISS := destDir + DirectorySeparator + 'install_script.iss';

  LogDatei.log('extract install_script.iss from ' + myfilename + ' to',LLInfo);
  LogDatei.log(installScriptISS,LLInfo);
  // myCommand := 'cmd.exe /C "'+ExtractFilePath(paramstr(0))+'innounp.exe" -x -a -y -d"'+destDir+'" ' +myfilename+ ' install_script.iss';
  myCommand := '"' + ExtractFilePath(ParamStr(0)) +'utils'+PathDelim+ 'innounp.exe" -x -a -y -d"' +
    destDir + '" ' + myfilename + ' install_script.iss';
  Mywrite(myCommand);

  if not RunCommandAndCaptureOut(myCommand, True, myoutlines, myreport,
    SW_SHOWMINIMIZED, myexitcode) then
  begin
    LogDatei.log('Failed to extract install_script.iss: ' + myreport,LLerror);
  end
  else
  begin
    for i := 0 to myoutlines.Count - 1 do
      mywrite(myoutlines.Strings[i]);
    myoutlines.Free;

    // read install_script.iss
    if FileExists(installScriptISS) then
    begin
      Mywrite(installScriptISS);
      AssignFile(fISS, installScriptISS);
      Reset(fISS);
      // search [Setup] section
      while (not EOF(fISS)) and (not (0 < pos('[setup]', lowercase(issLine)))) do
      begin
        ReadLn(fISS, issLine);
      end;



      LogDatei.log('Here comes the iss file: '+installScriptISS,LLInfo);
      LogDatei.log('[Setup]',LLDebug);
      ReadLn(fISS, issLine);

      // read until next section (usually [Files])
      while (not EOF(fISS)) and (Length(issLine) > 0) and (issLine[1] <> '[') do
      begin
        LogDatei.log(issLine,LLDebug);
        if (0 < pos('appname=', lowercase(issLine))) then
          AppName := Copy(issLine, pos('=', issLine) + 1, 100);
        if (0 < pos('appversion=', lowercase(issLine))) then
          AppVersion := Copy(issLine, pos('=', issLine) + 1, 100);
        if (0 < pos('appvername=', lowercase(issLine))) then
          AppVerName := Copy(issLine, pos('=', issLine) + 1, 100);
        if (0 < pos('defaultdirname=', lowercase(issLine))) then
          DefaultDirName := Copy(issLine, pos('=', issLine) + 1, 100);
        if (0 < pos('architecturesinstallin64bitmode=', lowercase(issLine))) then
          ArchitecturesInstallIn64BitMode := Copy(issLine, pos('=', issLine) + 1, 100);
        ReadLn(fISS, issLine);
      end;

      // get AppVersion from AppVerName (AppVerName = AppName + AppVersion ?)
      if (AppVersion = '') and (AppVerName <> '') then
      begin
        AppVersion := StringReplace(AppVerName, AppName, '', []);
        AppVersion := StringReplace(AppVersion, ' ', '', [rfReplaceAll, rfIgnoreCase]);
      end;

      CloseFile(fISS);
    end;
  end;
    {$ENDIF WINDOWS}
  LogDatei.log('........',LLDebug);
  if AppVerName <> '' then
  begin
    aktProduct.produktpropties.productId := getPacketIDShort(AppName);
    aktProduct.produktpropties.productName := AppName;
  end;
  aktProduct.produktpropties.productversion := AppVersion;
  mysetup.SoftwareVersion:=AppVersion;
  if AppVerName = '' then
  begin
    if ((AppName <> '') and (AppVersion <> '')) then
      AppVerName := AppName + ' ' + AppVersion
    else
      AppVerName := AppName + AppVersion;
  end;
  if (0 < pos('x64', lowercase(ArchitecturesInstallIn64BitMode))) then
  begin
    if pos('{pf}',DefaultDirName) > 0 then
    begin
      DefaultDirName := StringReplace(DefaultDirName, '{pf}',
        '%ProgramFilesSysnativeDir%', [rfReplaceAll, rfIgnoreCase])
    end;
    if pos('{code:DefDirRoot}',DefaultDirName) > 0 then
    begin
      DefaultDirName := StringReplace(DefaultDirName, '{code:DefDirRoot}',
        '%ProgramFilesSysnativeDir%', [rfReplaceAll, rfIgnoreCase])
    end;
  end
  else
  begin
    if pos('{pf}',DefaultDirName) > 0 then
    begin
      DefaultDirName := StringReplace(DefaultDirName, '{pf}',
        '%ProgramFiles32Dir%', [rfReplaceAll, rfIgnoreCase])
    end;
    if pos('{code:DefDirRoot}',DefaultDirName) > 0 then
    begin
      DefaultDirName := StringReplace(DefaultDirName, '{code:DefDirRoot}',
        '%ProgramFiles32Dir%', [rfReplaceAll, rfIgnoreCase])
    end;
  end;
  DefaultDirName := StringReplace(DefaultDirName, '{sd}', '%Systemdrive%',
    [rfReplaceAll, rfIgnoreCase]);
  mysetup.installDirectory := DefaultDirName;
  aktProduct.produktpropties.comment := AppVerName;

  with mysetup do
  begin
    LogDatei.log('installDirectory: '+installDirectory,LLDebug);
    LogDatei.log('SoftwareVersion: '+SoftwareVersion,LLDebug);
  end;
  with aktProduct.produktpropties do
  begin
    LogDatei.log('comment: '+comment,LLDebug);
    LogDatei.log('productId: '+productId,LLDebug);
    LogDatei.log('productName: '+productName,LLDebug);
    LogDatei.log('productversion: '+productversion,LLDebug);
  end;


  mywrite('get_inno_info finished');
  mywrite('Inno Setup detected');



  Mywrite('Finished analyzing Inno-Setup');
  if showgui then
    resultForm1.PageControl1.ActivePage := resultForm1.TabSheetSetup1;
end;


procedure get_installshield_info(myfilename: string; var mysetup : TSetupFile);
var
  product: string;

begin
  Mywrite('Analyzing InstallShield-Setup:');
  mywrite('get_InstallShield_info finished');
  mywrite('InstallShield Setup detected');

  if showInstallShield then
    //resultForm1.PageControl1.ActivePage := resultForm1.TabSheetInstallShield;
    resultForm1.PageControl1.ActivePage := resultForm1.TabSheetSetup1;
end;


procedure get_installshieldmsi_info(myfilename: string; var mysetup : TSetupFile);
var
  myoutlines: TStringList;
  myreport: string;
  myexitcode: integer;
  myBatch: string;
  product: string;
  FileInfo: TSearchRec;
  //exefile: string;
  smask: string;

begin
  Mywrite('Analyzing InstallShield+MSI Setup: ' + myfilename);
  mysetup.installerId := stInstallShieldMSI;
  mysetup.setupFullFileName := myfilename;
  //&mysetup.setupFileNamePath := ExtractFileDir(myfilename);

  if DirectoryExists(opsitmp) then
    DeleteDirectory(opsitmp, True);
  if not DirectoryExists(opsitmp) then
    createdir(opsitmp);
  if not DirectoryExists(opsitmp) then
    mywrite('Error: could not create directory: ' + opsitmp);
  {$IFDEF WINDOWS}
  // extract and analyze MSI from setup

  Mywrite('Analyzing MSI from InstallShield Setup ' + myfilename);

  myoutlines := TStringList.Create;
  // myBatch := 'cmd.exe /C '+ExtractFilePath(paramstr(0))+'extractMSI.cmd "'+myfilename+'"'; // (does not work with spaces in EXE path)
  myBatch := '"' + ExtractFilePath(ParamStr(0)) +'utils'+PathDelim+  'extractMSI.cmd" "' + myfilename + '"';
  // dropped cmd.exe
  Mywrite(myBatch);
  Mywrite('!! PLEASE WAIT !!');
  Mywrite('!! PLEASE WAIT !! Extracting and analyzing MSI ...');
  Mywrite('!! PLEASE WAIT !!');

  product := ExtractFileNameWithoutExt(myfilename);



  if not RunCommandAndCaptureOut(myBatch, True, myoutlines, myreport,
    SW_SHOWMINIMIZED, myexitcode) then
  begin
    mywrite('Failed to to run "' + myBatch + '": ' + myreport);
  end
  else
  begin
    smask := opsitmp + '*.msi';
    Mywrite(smask);
    if SysUtils.FindFirst(smask, faAnyFile, FileInfo) = 0 then
    begin
      //resultform1.EditMSI_file.Text := opsitmp + FileInfo.Name;
      mysetup.msiFullFileName := opsitmp + FileInfo.Name;
      ;

      // analyze the extracted MSI
      //resultform1.OpenDialog1.InitialDir := opsitmp;
      //resultform1.OpenDialog1.FileName := FileInfo.Name;
      get_msi_info(mysetup.msiFullFileName,mysetup);

       (*
       // and use the parameters from get_msi_info (MSI analyze)
       product := resultForm1.EditMSI_opsiProductID.Text;
       resultForm1.EditInstallShieldMSIProductID.Text := product;
       resultForm1.EditInstallShieldMSIProductName.Text := resultForm1.EditMSI_ProductName.Text;
       resultForm1.EditInstallShieldMSIProductVersion.Text := resultForm1.EditMSI_ProductVersion.Text;
       resultForm1.EditInstallShieldMSIProductCode.Text := resultForm1.EditMSI_ProductCode.Text;
       resultForm1.MemoInstallShieldMSIDescription.Append(resultForm1.EditMSI_ProductName.Text);
       *)

      // reset OpenDialog parameters
      //resultform1.OpenDialog1.InitialDir := myfilename;
      //resultform1.OpenDialog1.FileName := ExtractFileNameWithoutExt(myfilename);

      // resultform1.setDefaultParametersMSI;
    end
    else
    begin
      //todo call Dialog here
      //Application.MessageBox(pchar(format(sErrExtractMSIfailed, [myfilename])), pchar(sMBoxHeader), MB_OK);
    end;
  end;
  {$ENDIF WINDOWS}
  mywrite('get_InstallShield_info finished');
  mywrite('InstallShield+MSI Setup detected');

  if showInstallShieldMSI then
    //resultForm1.PageControl1.ActivePage := resultForm1.TabSheetInstallShieldMSI;
    resultForm1.PageControl1.ActivePage := resultForm1.TabSheetSetup1;

end;



procedure get_advancedmsi_info(myfilename: string; var mysetup : TSetupFile);
var
  myoutlines: TStringList;
  myreport: string;
  myexitcode: integer;
  myBatch: string;
  product: string;
  FileInfo: TSearchRec;
  //exefile: string;
  smask: string;

begin
  Mywrite('Analyzing AdvancedMSI Setup: ' + myfilename);
  mysetup.installerId := stAdvancedMSI;
  mysetup.setupFileName := ExtractFileName(myfilename);
  //mysetup.setupFileNamePath := ExtractFileDir(myfilename);

  {$IFDEF WINDOWS}
  // extract and analyze MSI from setup

  Mywrite('Analyzing MSI from Setup ' + myfilename);

  myoutlines := TStringList.Create;
  myBatch := 'cmd.exe /C "' + myfilename + '" /extract:' + opsitmp;
  Mywrite(myBatch);
  Mywrite('!! PLEASE WAIT !!');
  Mywrite('!! PLEASE WAIT !! Extracting and analyzing MSI ...');
  Mywrite('!! PLEASE WAIT !!');


  product := ExtractFileNameWithoutExt(myfilename);

  if DirectoryExists(opsitmp) then
    DeleteDirectory(opsitmp, True);
  if not DirectoryExists(opsitmp) then
    createdir(opsitmp);
  if not DirectoryExists(opsitmp) then
    mywrite('Error: could not create directory: ' + opsitmp);

  if not RunCommandAndCaptureOut(myBatch, True, myoutlines, myreport,
    SW_SHOWMINIMIZED, myexitcode) then
  begin
    mywrite('Failed to extract MSI: ' + myreport);
  end
  else
  begin
    smask := opsitmp + '*.msi';
    Mywrite(smask);
    if SysUtils.FindFirst(smask, faAnyFile, FileInfo) = 0 then
    begin
      mysetup.msiFullFileName := opsitmp + FileInfo.Name;
      ;
      //resultform1.EditMSI_file.Text := opsitmp + FileInfo.Name;

      // analyze the extracted MSI
      //resultform1.OpenDialog1.InitialDir := opsitmp;
      //resultform1.OpenDialog1.FileName := FileInfo.Name;
      get_msi_info(mysetup.msiFullFileName, mysetup);

      // and use the parameters from get_msi_info (MSI analyze)
      //product := resultForm1.EditMSI_opsiProductID.Text;

      // reset OpenDialog parameters
      //resultform1.OpenDialog1.InitialDir := myfilename;
      //resultform1.OpenDialog1.FileName := ExtractFileNameWithoutExt(myfilename);

      // resultform1.setDefaultParametersMSI;
    end;
  end;
  {$ENDIF WINDOWS}

  mywrite('get_AdvancedMSI_info finished');
  mywrite('Advancd Installer Setup (with embedded MSI) detected');

  if showAdvancedMSI then
    //resultForm1.PageControl1.ActivePage := resultForm1.TabSheetAdvancedMSI;
    resultForm1.PageControl1.ActivePage := resultForm1.TabSheetSetup1;

end;




procedure get_nsis_info(myfilename: string; var mysetup : TSetupFile);
var
  myoutlines: TStringList;
  myreport: string;
  myexitcode: integer;
  i: integer;
  fsize: int64;
  fsizemb: double;
  sFileSize: string;
  sReqSize: string;
  sSearch: string;
  iPos: integer;
  destDir: string;
  myBatch: string;
  product: string;

begin
  Mywrite('Analyzing NSIS-Setup:');
  mywrite('get_nsis_info finished');
  mywrite('NSIS (Nullsoft Install System) detected');

  if showNsis then
    //resultForm1.PageControl1.ActivePage := resultForm1.TabSheetNsis;
    resultForm1.PageControl1.ActivePage := resultForm1.TabSheetSetup1;
end;

procedure get_7zip_info(myfilename: string);
var
  product: string;
begin
  Mywrite('Analyzing 7zip-Setup:');
end;


function analyze_markerlist(var mysetup : TSetupFile): TKnownInstaller;
var
  i: integer;

begin
  try
    Result := stUnknown;
    for i := 0 to mysetup.markerlist.Count - 1 do
      LogDatei.log('marker: ' + mysetup.markerlist[i], LLdebug);
    for i := 0 to integer(stUnknown) - 1 do
    begin
      if not Assigned(installerArray[i].detected) then
        LogDatei.log('No check implemented for: ' +
          installerToInstallerstr(TKnownInstaller(i)), LLWarning)
      else
      begin
        LogDatei.log('Check markerlist for: ' + installerToInstallerstr(
          TKnownInstaller(i)), LLInfo);
        if installerArray[i].detected(TClass(installerArray[i]),
          mysetup.markerlist) then
        begin
          Result := TKnownInstaller(i);
          LogDatei.log('Detected: ' + installerToInstallerstr(Result), LLnotice);
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      LogDatei.log('Exception in analyze_markerlist', LLcritical);
      LogDatei.log('Error: Message: ' + E.message, LLcritical);
    end;
  end;
end;

function analyze_binary(myfilename: string; verbose, skipzero: boolean; var mysetup : TSetupFile): TKnownInstaller;
var
  FileStream: TFileStream;
  CharIn: char;
  MinLen, MaxLen: integer;
  CurrValue: string;
  i: integer;
  size: longint;
  buffer: array [0 .. 2047] of char;
  charsread: longint;
  msg: string;
  setuptype: TKnownInstaller;

begin
  MinLen := 5;
  MaxLen := 512;
  CurrValue := '';
  setupType := stUnknown;
  Result := stUnknown;

  mywrite('------------------------------------');
  Mywrite('Analyzing: ' + myfilename);
  msg := 'stringsgrep started (verbose:';
  if verbose = True then
    msg := msg + 'true'
  else
    msg := msg + 'false';
  msg := msg + ', skipzero:';
  if skipzero = True then
    msg := msg + 'true'
  else
    msg := msg + 'false';
  msg := msg + ')';
  mywrite(msg);
  FileStream := TFileStream.Create(myfilename, fmOpenRead);
  //markerEmbeddedMSI := false;
  //markerInstallShield := false;
  try
    size := FileStream.Size;
    while (size > 0) and (setupType = stUnknown) do
    begin
      charsread := FileStream.Read(buffer, sizeof(buffer));
      size := size - charsread;

      for i := 0 to charsread - 1 do
      begin
        charIn := buffer[i];

        // skipzero: handling of wide strings by ignoring zero byte
        if skipzero and (CharIn = #0) then
          continue;

        // if (CharIn in [' ','A'..'Z','a'..'z','0'..'9','<','>','.','/','_','-']) and (Length(CurrValue) < MaxLen) then
        if (CharIn in [#32..#126]) and (Length(CurrValue) < MaxLen) then
          CurrValue := CurrValue + CharIn;

        if (Length(CurrValue) < MaxLen) and (i < charsread - 1) then
          continue;

        if (Length(CurrValue) >= MinLen) then
        begin
          if '.exe' = lowercase(ExtractFileExt(myfilename)) then
          begin
            if verbose then
            begin
              //grepexe(CurrValue);
              analyze_binstr(CurrValue,mysetup);
              logdatei.log(CurrValue, LLDebug2);
            end
            else
              analyze_binstr(CurrValue, mysetup);
          end
          else if '.msi' = lowercase(ExtractFileExt(myfilename)) then
          begin
            setupType := stMsi;
            if verbose then
            begin
              grepmsi(CurrValue);
              logdatei.log(CurrValue, LLDebug2);
            end;
          end
          else
          begin
            grepexe(CurrValue);
            grepmsi(CurrValue);
            logdatei.log(CurrValue, LLDebug2);
          end;
          CurrValue := '';
        end;
      end;

    end;
    msg := 'stringsgrep completed (verbose:';
    if verbose = True then
      msg := msg + 'true'
    else
      msg := msg + 'false';
    msg := msg + ', skipzero:';
    if skipzero = True then
      msg := msg + 'true'
    else
      msg := msg + 'false';
    msg := msg + ')';
    mywrite(msg);
    mywrite('------------------------------------');
  finally
    FileStream.Free;
  end;
  Result := analyze_markerlist(mysetup);
end;


procedure Analyze(FileName: string; var mysetup : TSetupFile);
var
  setupType: TKnownInstaller;
  verbose: boolean = True;
begin
  //aktProduct.setup32FileNamePath := FileName;
  //resultform1.clearAllTabs;
  setupType := stUnknown;
  if '.msi' = lowercase(ExtractFileExt(FileName)) then
  begin
    get_aktProduct_general_info(stMsi, Filename,mysetup);
    get_msi_info(FileName,mysetup);
  end
  else
  begin
    //stringsgrep(FileName, false, false); // filename, verbose, skipzero
    setupType := analyze_binary(FileName, verbose, False,mysetup); // filename, verbose, skipzero

    get_aktProduct_general_info(setupType, Filename,mysetup);

    case setupType of
      stInno: get_inno_info(FileName,mysetup);
      stNsis: get_nsis_info(FileName,mysetup);
      stInstallShield: get_installshield_info(FileName,mysetup);
      stInstallShieldMSI: get_installshieldmsi_info(FileName,mysetup);
      stAdvancedMSI: get_advancedmsi_info(FileName,mysetup);
      st7zip: get_7zip_info(FileName);
      stMsi: ;// nothing to do here - see above;
      st7zipsfx: logdatei.log('no getinfo implemeted for: '+installerToInstallerstr(setupType), LLWarning);
      stUnknown: LogDatei.log(
          'Unknown Installer after Analyze.', LLcritical);
      else
        LogDatei.log('Unknown Setuptype in Analyze: ' + IntToStr(
          instIdToint(setupType)), LLcritical);
    end;

 (*
    if (setupType = stInno) then
      get_inno_info(FileName)
    else if (setupType = stNsis) then
      get_nsis_info(FileName)
    else if (setupType = stInstallShield) then
      get_installshield_info(FileName)
    else if (setupType = stInstallShieldMSI) then
      get_installshieldmsi_info(FileName)
    else if (setupType = stAdvancedMSI) then
      get_advancedmsi_info(FileName)
    else
    begin
      resultForm1.PageControl1.ActivePage := resultForm1.TabSheetAnalyze;
      analyze_binary(FileName, True, False); // filename, verbose, skipzero
      analyze_binary(FileName, True, True); // filename, verbose, skipzero
      mywrite('unknown Setup Type.');   /// XXX Probe-Installation anbieten
    end;
    *)
  end;
end;




end.

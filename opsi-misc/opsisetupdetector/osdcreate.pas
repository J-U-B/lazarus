unit osdcreate;

{$mode delphi}

interface

uses
    {$IFDEF WINDOWS}
  Windows,
  ShlObj,
    {$ENDIF WINDOWS}
  Classes,
  SysUtils,
  strutils,
    Forms,
    Controls,
    FileUtil,
  Process,
  osdhelper,
  oslog,
  osdbasedata,
  Dialogs;

procedure createProductStructure;
procedure removeOtherTypeSpecificSections(setupType, setupFile: string);

implementation

uses
  osdform;

var
  patchlist: TStringList;
  myExeDir: string;
    prodpath, clientpath, opsipath: string;

procedure patchScript(infile, outfile: string);
var
  infileHandle, outfileHandle: Text;
  aktline: string;
  i: integer;
begin
  mywrite('creating: ' + outfile + ' from: ' + infile);

  {$I+}//use exceptions
  try
    AssignFile(infileHandle, infile);
    AssignFile(outfileHandle, outfile);
    reset(infileHandle);
    rewrite(outfileHandle);

    while not EOF(infileHandle) do
    begin
      ReadLn(infileHandle, aktline);
      for i := 0 to patchlist.Count - 1 do
        aktline := StringReplace(aktline, patchlist.Names[i],
          patchlist.ValueFromIndex[i], [rfReplaceAll, rfIgnoreCase]);
      writeln(outfileHandle, aktline);
    end;
    CloseFile(infileHandle);
    CloseFile(outfileHandle)
  except
    on E: EInOutError do
      logdatei.log('patchScript file error: ' + E.ClassName + '/' + E.Message,LLError);
  end;
end;


  procedure fillPatchList;
  var
      i : integer;
      str : string;
  begin
    patchlist.Clear;
    str := '';
    patchlist.add('#@productId*#='+aktProduct.productdata.productId);
    for i := 0 to myconfiguration.import_libraries.Count-1 do
      str := str + 'importlib "'+myconfiguration.import_libraries[i]+'"'+LineEnding;
    patchlist.add('#@importLibs*#='+str);
    patchlist.add('#@LicenseRequired*#='+ boolToStr(aktProduct.productdata.licenserequired,true));
    patchlist.add('#@MinimumSpace*#='+inttostr(aktProduct.SetupFiles[0].requiredSpace)+' MB');
    //setup 1
    patchlist.add('#@InstallDir1*#='+aktProduct.SetupFiles[0].installDirectory);
    patchlist.add('#@MsiId1*#='+aktProduct.SetupFiles[0].msiId);
    str :=myconfiguration.preInstallLines.Text;
    patchlist.add('#@preInstallLines1*#='+str);
    patchlist.add('#@installCommandLine1*#='+aktProduct.SetupFiles[0].installCommandLine);
    patchlist.add('#@postInstallLines1*#='+myconfiguration.postInstallLines.Text);
    patchlist.add('#@isExitcodeFatalFunction1*#='+aktProduct.SetupFiles[0].isExitcodeFatalFunction);
    str := aktProduct.SetupFiles[0].uninstallCheck.Text;
    patchlist.add('#@uninstallCheckLines1*#='+str);
    str :=myconfiguration.preUninstallLines.Text;
    patchlist.add('#@preUninstallLines1*#='+str);
    patchlist.add('#@uninstallCommandLine1*#='+aktProduct.SetupFiles[0].uninstallCommandLine);
    patchlist.add('#@uninstallProg1*#='+aktProduct.SetupFiles[0].uninstallProg);
    patchlist.add('#@uninstallWaitForProc1*#='+aktProduct.SetupFiles[0].uninstall_waitforprocess);
    patchlist.add('#@postUninstallLines1*#='+myconfiguration.postUninstallLines.Text);
    //setup 2
    patchlist.add('#@InstallDir2*#='+aktProduct.SetupFiles[1].installDirectory);
    patchlist.add('#@MsiId2*#='+aktProduct.SetupFiles[1].msiId);
    str :=myconfiguration.preInstallLines.Text;
    patchlist.add('#@preInstallLines2*#='+str);
    patchlist.add('#@installCommandLine2*#='+aktProduct.SetupFiles[1].installCommandLine);
    patchlist.add('#@postInstallLines2*#='+myconfiguration.postInstallLines.Text);
    patchlist.add('#@isExitcodeFatalFunction2*#='+aktProduct.SetupFiles[1].isExitcodeFatalFunction);
    str := aktProduct.SetupFiles[1].uninstallCheck.Text;
    patchlist.add('#@uninstallCheckLines2*#='+str);
    str :=myconfiguration.preUninstallLines.Text;
    patchlist.add('#@preUninstallLines2*#='+str);
    patchlist.add('#@uninstallCommandLine2*#='+aktProduct.SetupFiles[1].uninstallCommandLine);
    patchlist.add('#@uninstallProg2*#='+aktProduct.SetupFiles[1].uninstallProg);
    patchlist.add('#@uninstallWaitForProc2*#='+aktProduct.SetupFiles[1].uninstall_waitforprocess);
    patchlist.add('#@postUninstallLines2*#='+myconfiguration.postUninstallLines.Text);
  end;

  function createClientFiles : boolean;
  var
      infilename, outfilename : string;
  begin
    result := false;
    try
      patchlist:= TStringList.Create;
      fillPatchList;
      // setup script
      infilename :=ExtractFileDir(Application.ExeName)+PathDelim+'template-files'+Pathdelim+'setupsingle.opsiscript';
      outfilename := clientpath+PathDelim+aktProduct.productdata.setupscript;
      patchScript(infilename,outfilename);
      // delsub script
      infilename :=ExtractFileDir(Application.ExeName)+PathDelim+'template-files'+Pathdelim+'delsubsingle.opsiscript';
      outfilename := clientpath+PathDelim+aktProduct.productdata.delsubscript;
      patchScript(infilename,outfilename);
      // uninstall script
      infilename :=ExtractFileDir(Application.ExeName)+PathDelim+'template-files'+Pathdelim+'uninstallsingle.opsiscript';
      outfilename := clientpath+PathDelim+aktProduct.productdata.uninstallscript;
      patchScript(infilename,outfilename);
      // setup file
      copyfile(aktProduct.SetupFiles[0].setupFullFileName,
                clientpath+PathDelim+aktProduct.SetupFiles[0].setupFileName,
                [cffOverwriteFile,cffCreateDestDirectory,cffPreserveTime], true);
      //osd-lib.opsiscript
      infilename :=ExtractFileDir(Application.ExeName)+PathDelim+'template-files'+Pathdelim+'osd-lib.opsiscript';
      outfilename := clientpath+PathDelim+'osd-lib.opsiscript';
      copyfile(infilename,outfilename,[cffOverwriteFile,cffCreateDestDirectory,cffPreserveTime], true);
      //product png
      infilename :=ExtractFileDir(Application.ExeName)+PathDelim+'template-files'+Pathdelim+'template.png';
      outfilename := clientpath+PathDelim+aktProduct.productdata.productId+'.png';
      copyfile(infilename,outfilename,[cffOverwriteFile,cffCreateDestDirectory,cffPreserveTime], true);

      FreeAndNil(patchlist);
      result := true;;
    except
      on E: exception do
      begin
        logdatei.log('createClientFiles file error: ' + E.ClassName + '/' + E.Message,LLError);
      end;
    end;
  end;

  function createOpsiFiles : boolean;
  var
    textlist : Tstringlist;
  begin
    result := false;
    try
    textlist := Tstringlist.Create;
    textlist.Add('[Package]');
    textlist.Add('version: '+ intToStr(aktProduct.productdata.packageversion));
    textlist.Add('depends:');
    textlist.Add('');
    textlist.Add('[Product]');
    textlist.Add('type: '+aktProduct.productdata.producttype);
    textlist.Add('id: '+aktProduct.productdata.productId);
    textlist.Add('name: '+aktProduct.productdata.productName);
    textlist.Add('description: '+aktProduct.productdata.description);
    textlist.Add('advice: '+aktProduct.productdata.advice);
    textlist.Add('version:'+ aktProduct.productdata.productversion);
    textlist.Add('priority:'+ intToStr(aktProduct.productdata.priority));
    textlist.Add('licenseRequired: ');
    textlist.Add('productClasses:');
    textlist.Add('setupScript: '+ aktProduct.productdata.setupscript);
    textlist.Add('uninstallScript: '+ aktProduct.productdata.uninstallscript);
    textlist.Add('updateScript:');
    textlist.Add('alwaysScript:');
    textlist.Add('onceScript:');
    textlist.Add('customScript:');
    textlist.Add('userLoginScript:');
    textlist.SaveToFile(opsipath+pathdelim+'control');
    FreeAndNil(textlist);
    result := true;
    except
      LogDatei.log('Error in createOpsiFiles',LLError);
     FreeAndNil(textlist);
    end;
  end;

function createProductdirectory : boolean;
var
  goon: boolean;
begin
  prodpath := myconfiguration.workbench_Path + aktProduct.productdata.productId;
  clientpath := prodpath + PathDelim + 'CLIENT_DATA';
  opsipath := prodpath + PathDelim + 'OPSI';
  goon := True;
  if DirectoryExists(prodpath) then
    if not MessageDlg('opsi-setup-detector','Directory ' + prodpath + ' still exits. Overwrite ?', mtWarning, mbOKCancel,'') = mrOk then
      goon := False;
  if goon then
  begin
    if not ForceDirectories(prodpath) then
    begin
      Logdatei.log('Could not create directory: ' + prodpath, LLCritical);
      MessageDlg('opsi-setup-detector','Could not create directory: ' + prodpath, mtError, [mbOK],'');
      goon := False;
    end;
    if not ForceDirectories(clientpath) then
    begin
      Logdatei.log('Could not create directory: ' + clientpath, LLCritical);
      MessageDlg('opsi-setup-detector','Could not create directory: ' + clientpath, mtError,[mbOK],'');
      goon := False;
    end;
    if not ForceDirectories(opsipath) then
    begin
      Logdatei.log('Could not create directory: ' + opsipath, LLCritical);
      MessageDlg('opsi-setup-detector','Could not create directory: ' + opsipath, mtError,[mbOK],'');
      goon := False;
    end;
  end;
  result := goon;
end;


procedure createProductStructure;
var
  prodpath, clientpath, opsipath: string;
  goon: boolean;
begin
  goon := True;
  if not createProductdirectory  then
    begin
      Logdatei.log('createProductdirectory failed' , LLCritical);
      goon := False;
    end;
  if not (goon and createOpsiFiles) then
    begin
      Logdatei.log('createOpsiFiles failed' , LLCritical);
      goon := False;
    end;
  if not (goon and createClientFiles) then
    begin
      Logdatei.log('createClientFiles failed' , LLCritical);
      goon := False;
    end;
end;




function ExtractBetween(const Value, A, B: string): string;
var
  aPos, bPos: integer;
begin
  Result := '';
  aPos := pos(A, Value);
  if aPos > 0 then
  begin
    aPos := aPos + Length(A);
    bPos := PosEx(B, Value, aPos);
    if bPos > 0 then
    begin
      Result := Copy(Value, aPos, bPos - aPos);
    end;
  end;
end;


procedure ButtonCreatePacketClick(Sender: TObject);
var
  msg1: string;
  description: string;
  buildCall: string = '';
  OpsiBuilderProcess: TProcess;
  packit: boolean = False;
  errorstate: boolean = False;
  notused: string = '(not used)';

begin

  if patchlist = nil then
    patchlist := TStringList.Create
  else
    patchlist.Clear;
  myExeDir := ExtractFileDir(ParamStr(0));


  //Panel9.Visible := False;
      {$IFDEF WINDOWS}
  // execute opsiPacketBuilder

  if resultForm1.RadioButtonCreateOnly.Checked = True then
  begin
    //Application.MessageBox(PChar(sInfoFinished), PChar(sMBoxHeader), MB_OK);
  end
  else
  begin  // execute OPSIPackageBuilder
    OpsiBuilderProcess := process.TProcess.Create(nil);
    buildCall := getSpecialFolder(CSIDL_PROGRAM_FILES) + DirectorySeparator +
      'OPSI PackageBuilder' + DirectorySeparator + 'OPSIPackageBuilder.exe' +
      ' -p=' + packetBaseDir;
    if AnsiLastChar(packetBaseDir) <> DirectorySeparator then
      buildCall := buildCall + DirectorySeparator;
    buildCall := buildCall + productId;
    if resultForm1.RadioButtonInteractive.Checked = True then
    begin
      OpsiBuilderProcess.ShowWindow := swoMinimize;
    end
    else  // auto
    if resultForm1.RadioButtonAuto.Checked = True then
    begin
      if resultForm1.CheckboxBuild.Checked = True then
        buildCall := buildCall + ' --build=rebuild';
      if resultForm1.CheckboxInstall.Checked = True then
        buildCall := buildCall + ' --install';
      if resultForm1.CheckboxQuiet.Checked = True then
        buildCall := buildCall + ' --quiet';
      OpsiBuilderProcess.ShowWindow := swoMinimize;
    end;

    //mywrite('invoke opsi package builder');
    //mywrite(buildcall);

    try
      OpsiBuilderProcess.CommandLine := buildCall;
      OpsiBuilderProcess.Execute;
      if resultForm1.CheckboxQuiet.Checked = True then
      begin
        resultForm1.PanelProcess.Visible := True;
        resultForm1.processStatement.Caption := 'invoke opsi package builder ...';
        //Application.ProcessMessages;
        while OpsiBuilderProcess.Running do
        begin
          //Application.ProcessMessages;
        end;
      end;
    except
      errorstate := True;
      //Application.MessageBox(PChar(sErrOpsiPackageBuilderStart),
      //        PChar(sMBoxHeader), MB_OK);
    end;

    resultForm1.PanelProcess.Visible := False;
    if (resultForm1.CheckboxQuiet.Checked = True) then
    begin
      if (errorstate = False) then
      begin
        if (OpsiBuilderProcess.ExitStatus = 0) then
        //Application.MessageBox(PChar(sInfoFinished), PChar(sMBoxHeader), MB_OK)
        else;
        //Application.MessageBox(
        //  PChar(format(sErrOpsiPackageBuilderErrCode,
        //  [IntToStr(OpsiBuilderProcess.ExitStatus)])),
        //  PChar(sMBoxHeader), MB_OK);
      end;
    end;
  end;   // execute OPSIPackageBuilder
      {$ENDIF WINDOWS}
end;

procedure removeOtherTypeSpecificSections(setupType, setupFile: string);
var
  infileHandle, outfileHandle: Text;
  Patchmarker: string = '**--** PATCH_';
  filterType: string = '';
  thisType: string = '';
  aktline: string = '';
  tmpfile: string;
  isMarkerLine: boolean;
begin
  mywrite('removing all other type specific sections from: ' + setupfile);
  tmpfile := setupfile + '.tmp';

        {$I+}//use exceptions
  try
    AssignFile(infileHandle, setupfile);
    AssignFile(outfileHandle, tmpfile);
    reset(infileHandle);
    rewrite(outfileHandle);

    filterType := lowercase(setupType);

    // find and handle type specific patch sections
    while (not EOF(infileHandle)) do
    begin
      // find next type specific marker
      repeat
        ReadLn(infileHandle, aktline);
        isMarkerLine := (0 < pos(Patchmarker, aktline));
        if not isMarkerLine then
          writeln(outfileHandle, aktline);
      until isMarkerLine or EOF(infileHandle);
      if not EOF(infileHandle) then
      begin
        thisType := lowercase(ExtractBetween(aktline, Patchmarker, ' '));
        // write lines (or skip lines if other type)
        repeat
          ReadLn(infileHandle, aktline);
          isMarkerLine := (0 < pos(Patchmarker, aktline));
          if (thisType = filterType) and not isMarkerLine then
            writeln(outfileHandle, aktline);
        until isMarkerLine or EOF(infileHandle);
      end;
    end;

    CloseFile(infileHandle);
    CloseFile(outfileHandle);

    // delete setupfile and rename tmpfile to setupfile
    DeleteFile(PChar(setupfile));
    RenameFile(PChar(tmpfile), PChar(setupfile));

  except
    on E: EInOutError do
      mywrite('removeOtherTypeSpecificSections error: ' +
        E.ClassName + '/' + E.Message);
  end;
end;




end.

unit osxmlsections;

// This code is part of the opsi.org project

// Copyright (c) uib gmbh (www.uib.de)
// This sourcecode is owned by the uib gmbh, D55118 Mainz, Germany
// and published under the Terms of the General Public License.

// Text of the GPL: http://www.gnu.org/licenses/gpl.html
// Unofficial GPL Translations: http://www.gnu.org/licenses/translations.html

// author: Rupert Roeder, APohl, detlef oertel, m.hammel
// credits: http://www.opsi.org/credits/

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes,
  DOM,
  XMLRead,
  XMLWrite,
  Dialogs, StrUtils,
  ExtCtrls,
  key_valueCollection,
  oslog;

type
  TNodeSet = array of TDOMNode;

  TStringsArray = array of string;
  TbooleansArray = array of boolean;

  TLogCallbackProcedure = procedure(level: integer; logmsg: string) of object;

  TuibXMLDocument = class(TXMLDocument)
  private
      XML: TXMLDocument;
      actNode: TDOMNode;
      {actNode.FirstChild: TDOMNode, LastChild: TDOMNode, NextSibling: TDOMNode,
      PreviousSibling: TDOMNode, ParentNode: TDOMNode
      }

      fActNodeSet: TNodeSet;
      fDerivedNodeSet: TNodeSet;
      fDebugLevel: integer;

      function getCountNotNil: integer;
      // length actNodeSet without NIL-Elements

      function getCountDerivedNotNil: integer;
      // length derivedNodeSet without NIL-Elements

      function getNodeStrict(var newNode: TDOMNode; myparentNode: TDOMNode;
        mynodeName: string; attributeList : TList): boolean;
      // nodename has to fit and all attributes

      function getNodeByNameAndAttribute(var newNode: TDOMNode; myparentNode: TDOMNode;
        mynodeName: string; attributename: string; attributevalue : string): boolean;
      // nodename has to fit, one attribute can fit

      function getNodeByName(var newNode: TDOMNode; myparentNode: TDOMNode;
        mynodeName: string): boolean;
      // nodename has to fit

      procedure makeAttributesSL (var attributeStringList: TStringList; attributePath : String);

      procedure ErrorHandler(E: EXMLReadError);


    public
      destructor Destroy; override;
     //*************  XML File-Handling ***********************************
      function openXmlFile(filename: string): boolean;
      function writeXmlAndCloseFile(filename: string): boolean;

      //*************  XML Handling ***********************************
      function createXmlDocFromStringlist(docstrlist: TStringList): boolean;
      function getDocumentElement(): TDOMNode;
      function isValidXML(xmlString: TStringList): boolean;
      function getXmlStrings: TStringList;
      function nodeExistsByPathInXMLFile(filename,
                       path:string; attributes_strict: boolean) : boolean;
      //*************  NodeSet-Handling ***********************************
      procedure makeTopAsActNodeSet;
      // set actNodeSet from DocumentElement (top)

      procedure getNextGenerationActNodeSet;
      // set derivedNodeSet as actNodeset

      procedure makeNewDerivedNodeSet;
      // create derivedNodeSet. For every node in actNodeSet collect the next
      // childs. Therefore: helpfull if actNodeSet contains only one node

      procedure setlengthActNodeSet(newlength: integer);
      //

      procedure setlengthDerivedNodeSet(newlength: integer);
      //

      procedure cleanUpActNodeSet ();
      // eliminate NIL-Elements from actNodeset

      procedure cleanUpDerivedNodeSet ();
      // eliminate NIL-Elements from derivedNodeSet

      procedure logNodeSets;
      procedure logActNodeSet;

      //*************  Filters on Nodesets ********************************
      function filterByAttributeList
                     (var attributenames : Tstringsarray;
                      var attributevalueExists : Tbooleansarray;
                      var attributevalues : TStringsArray;
                      attributes_strict : boolean) : Boolean;

      function filterByAttributeName_existing (name: string) : Boolean;

      function filterByAttribute_existing (name: string; value : string) : Boolean;

      function filterByText (textvalue: string) : Boolean;

      function filterByChildElement (elementname: string) : Boolean;
      // tested


      //*************  Node-Operations ***********************************
      // The main idea for the following syntax:

      // The nodePath looks like this:
      // nodedescription XML2PATHSEPARATOR nodedescripton (and so on)
      // nodedescription looks like this:
      // nodename attributeName="attributeValue"
      // (!) attributeValue should be surrounded with ""
      // (!) attributeValue may contain a XML2PATHSEPARATOR string
          // nodeName may include a namespace prefix - no more
          // attributeName may include a namespace prefix - no more
          // (!) namespace prefix are case sensitiv - no more
      // a node without attributes looks like this:
      // nodename =""
      // XML2PATHSEPARATOR string is ' // '

      // eg:
      // foo bar="bar1" // childfoo ="" // RDF:foo NC:bar=nonesense

      function nodeExists(nodePath: string; attributes_strict:boolean): boolean;
      // tells if a node exists without changing anything
      // if attributes_strict=true: check all attributes, true if path and all
      //                            attributes fit, false if anything is wrong
      // if attributes_strict=false: check only node path,
      //                             true if node path exists, false if not

      function openNode(nodePath: string; attributes_strict: boolean): boolean;
      // open the node, analog nodeExists
      // afterwards this node is actNode

      // overload
      function makeNode(mynodeName: string): boolean; overload;
      // create new node, append to actNode, set newnode as actNode

      function makeNode(mynodeName, attributeName, attributeValue: string): boolean; overload;
      // create new node, append to actNode, set newnode as actNode

      // overload
      function makeNodeAndKeepActNode(mynodeName: string): boolean; overload;
       // create new node, append to actNode, actNode is kept

      function makeNodeAndKeepActNode(mynodeName,
                       attributeName, attributeValue, text: string): boolean; overload;
       // create new node, append to actNode, actNode is kept


      function makeNodePathWithTextContent(nodePath: string; text: string) : boolean;
      // create note path with textcontent
      // in nodepath all attributes have to fit or they will be created
      // actNode will be last created node, text will be set as TextContent

      function makeNodes
                       (mynodeName : String;
                       const textArray:TStringList
                       ):boolean;
     // creates couple of nodes in actnode with equal names
     // and different TextContent, actNode will be same after creation

      // overload procedure
      procedure delNode(nodePath: string); overload;
      // this node (and all childs) will be deleted, afterwards parent will be actnode
      // node will be opened with openNode

      procedure delNode(); overload;
      // aktnode (and all childs) will be deleted, afterwards parent will be actnode

      procedure setTopNodeAsActNode();
      // set top node as actual node

      procedure setFirstChildAsActNode();
      // set first child as actual node

      procedure setParentNodeAsActNode();
      // set parent node as actual node

      procedure setNodeTextActNode(Text: string);
      // set text at the actual node

      function setActNodeIfText(textvalue: string): boolean;
      // set actnode if text found

      function getNodeTextActNode () : String;
      // get text from the actual node

      function getNodeNameActNode () : string;
      // get name from the actual node


      //*************  Attributes ************************************
      function countAttributes ( myxmlnode: TDOMNode ) : integer;
      // count attributes of this node

      function hasAttribute(attributename: string): boolean;
      // checks if the actual node has the attribute

      procedure setAttribute(attributeName, attributeValue: string);
      // set the attribute at the actual node
      // if it exists it will be changed, otherwis create


      procedure addAttribute(attributeName, attributeValue: string);
      // add the attribute at the actual node
      // if it exists it will not (!) be changed

      procedure delAttribute(attributeName: string);
      // delete the attribute  at the actual node


      function getAttributeValue(attributeName: string): string;
      // get the attribute value at the actual node
      // ATTENTION: it returns an empty string:
      // - if there is no attribute with this name
      // - if the value of this attribute is an empty string

      // properties
      property debuglevel: integer read FDebugLevel write FDebugLevel;
      property actNodeSet: TNodeSet read factNodeSet write factNodeSet;
      property derivedNodeSet: TNodeSet read fDerivedNodeSet write fDerivedNodeSet;
      property CountNotNil: integer read getCountNotNil;
      property CountDerivedNotNil: integer read getCountDerivedNotNil;


 end;

implementation

const
  XML2PATHSEPARATOR: string = ' // ';
  extraindent = '   ';


var
  showErrors: boolean = True;
//#####################
// from osfunc
function divideAtFirst(const partialS, S: string; var part1, part2: string): boolean;
  //   teilt den String S beim ersten Vorkommen des Teilstrings partialS;
  //   liefert true, wenn partialS vorkommt,
  //   andernfalls false;
  //   wenn partialS nicht vorkommt, enthaelt part1 den Gesamtstring, part2 ist leer

var
  i: integer = 0;
begin
  i := pos(lowercase(partialS), lowercase(s));
  if i > 0 then
  begin
    part1 := copy(S, 1, i - 1);
    part2 := copy(S, i + length(partialS), length(S));
    Result := True;
  end
  else
  begin
    part1 := s;
    part2 := '';
    Result := False;
  end;
end;

// from osfunc
procedure stringsplit(const s, delimiter: string; var Result: TStringList);
// produziert eine Stringliste aus den Teilstrings, die zwischen den Delimiter-Strings stehen
var
  remainder: string = '';
  item: string = '';
  found: boolean;
begin
  Result := TStringList.Create;
  found := divideAtFirst(delimiter, s, item, remainder);
  while found do
  begin
    Result.add(item);
    found := divideAtFirst(delimiter, remainder, item, remainder);
  end;
  Result.add(item);
end;

function max(num1, num2: integer): integer;
begin
   if (num1 > num2) then
      result := num1
   else
      result := num2;
end;
{function getTag(line: string): string;
var
  p: integer;
  r, s: string;
begin
  Result := '';
  p := pos('<', line);
  if p > -1 then
  begin
    s := copy(line, p + 1, length(line));
    // TODO: getWord  (s, result, r, [' ', '>', '/']);
  end;
end;
}

function stringlistWithoutBreaks(strlist: TStringList): TStringList;
// eliminate breaks and empty lines
var
  intI: integer;
  teststr: string;
begin
  Result := TStringList.Create;
  if strlist.Count > 0 then
    for intI := 0 to strList.Count - 1 do
    begin
      teststr := StringReplace(strlist[intI], #10, '', [rfReplaceAll]);
      if (teststr <> '') then
        Result.Add(teststr);
    end;
end;

procedure setShowErrors(bValue: boolean);
begin
  showErrors := bValue;
end;

procedure TuibXMLDocument.ErrorHandler(E: EXMLReadError);
//http://wiki.lazarus.freepascal.org/XML_Tutorial/de#.C3.9Cberpr.C3.BCfen_der_G.C3.BCltigkeit_der_Struktur_einer_XML-Datei
begin
  if E.Severity = esError then
    // wir sind nur in Fehlern bezüglich der Verletzung der DTD interessiert
    LogDatei.log(E.Message, LLerror );
  // an dieser Stelle können wir auch alles andere machen, was bei einem Fehler getan werden sollte
end;


//*************  TuibXMLDocument ***********************************
destructor TuibXMLDocument.Destroy;
begin
  inherited Destroy;
end;

//*************  XML File-Handling ***********************************
function TuibXMLDocument.openXmlFile(filename: string): boolean;
var
  mystream: TFileStream;
begin
  openXmlFile := False;
  LogDatei.log( 'try to open File: ' + filename, LLinfo);
  try
    mystream := TFilestream.Create(fileName, fmOpenRead);
    mystream.Position := 0;
    XML := nil;
    LogDatei.log('try to load File: ' + filename, oslog.LLinfo);
    ReadXMLFile(XML, mystream);
    LogDatei.log('File: ' + filename + ' read', oslog.LLinfo);
    openXmlFile := True;
  except
    on e: Exception do
      LogDatei.log('Error in readXmlFile : ' + e.Message, oslog.LLerror);
  end;
  if mystream <> nil then
    mystream.Free;
end;

function TuibXMLDocument.writeXMLAndCloseFile(filename: string): boolean;
{ TODO : Schließen des Streams bei Except }
var
  mystream: TFileStream;
begin
  writeXMLAndCloseFile := False;
  try
    LogDatei.log('try to open File: '+filename, oslog.LLinfo);
    mystream := TFilestream.Create(fileName,fmCreate);
    mystream.Position:=0;
    WriteXMLFile(XML,mystream);
    LogDatei.log('file saved: '+filename, oslog.LLInfo);
    writeXMLAndCloseFile := True;
    mystream.Free;
  except
    on e: Exception do
      LogDatei.log('Error in writeXmlFile : ' + e.Message, oslog.LLerror);
  end;
end;

//*************  XML Handling ***********************************
function TuibXMLDocument.createXmlDocFromStringlist(docstrlist: TStringList): boolean;
var
  mystream: TStringStream;
begin
  createXmlDocFromStringlist := False;
  LogDatei.log('begin to create XMLDoc ', oslog.LLinfo);
  mystream := TStringStream.Create(docstrlist.Text);
  mystream.Position := 0;
  XML := nil;
  try
    ReadXMLFile(XML, mystream);
    LogDatei.log('XMLDoc created from Stringlist', LLinfo);
    createXmlDocFromStringlist := True;
  finally
    mystream.Free;
  end;
  LogDatei.log('XMLDoc created', LLinfo);
end;

function TuibXMLDocument.getDocumentElement(): TDOMNode;
begin
  getDocumentElement := XML.DocumentElement;
end;

function TuibXMLDocument.isValidXML(xmlString: TStringList): boolean;
{ TODO : Exception abfangen
 }
var
  nodestream: TStringStream;
  Parser: TDOMParser;
  Src: TXMLInputSource;
  TheDoc: TXMLDocument;
begin
  isValidXML := false;
  try
    Parser := TDOMParser.Create;
    nodestream := TStringStream.Create(stringlistWithoutBreaks(xmlString).Text);
    nodestream.Position := 0;
    Src := TXMLInputSource.Create(nodestream);
    Parser.Options.Validate := True;
    Parser.OnError := @ErrorHandler;
    Parser.Parse(Src, TheDoc);
    isValidXML:= true;

  finally
    Src.Free;
    Parser.Free;
  end;
  nodestream.Free;
end;

function TuibXMLDocument.getXmlStrings: TStringList;
var
  nodeStream: TMemoryStream;
  mystringlist: TStringList;
begin
  Result := TStringList.Create;
  if XML <> nil then
    try
      mystringlist := TStringList.Create;
      nodeStream := TMemoryStream.Create;
      WriteXML(XML, nodestream);
      nodeStream.Position := 0;
      mystringlist.LoadFromStream(nodestream);
      getXmlStrings := mystringlist;
    finally
      nodestream.Free;
    end;
end;

function TuibXMLDocument.nodeExistsByPathInXMLFile(filename, path:string; attributes_strict: boolean) : boolean;

begin
  nodeExistsByPathInXMLFile:= false;
  if openXmlFile(filename) then
  begin
    if openNode(path,attributes_strict) then
       nodeExistsByPathInXMLFile:=true;
  end
  else
    LogDatei.log('openXmlFile ' + filename + ' failed',oslog.LLinfo)
end;

//*************  Operations NodeSet  ***********************************
procedure TuibXMLDocument.makeTopAsActNodeSet;
var k: integer;
begin
  setlengthActNodeSet (1);
  actnodeset[0] := getDocumentElement;
  for k:= 0 to length(actNodeSet)-1 do
    if actNodeSet[k] <> nil then
      LogDatei.log('actNodeSet <> nil',oslog.LLinfo)
    else
      LogDatei.log('actNodeSet = nil',oslog.LLinfo);
end;

function TuibXMLDocument.getCountNotNil: integer;
// length actNodeSet without NIL-Elements
var
  i: integer;
  preresult : integer;
begin
  preresult := 0;
  for i := 0 to length(actnodeset) - 1 do
  begin
    if actnodeset[i] <> nil then
      Inc(preresult);
  end;
  getCountNotNil := preresult;
end;

function TuibXMLDocument.getCountDerivedNotNil: integer;
// length DerivedNodeSet without NIL-Elements
var
  i: integer;
  preresult : integer;
begin
  preresult := 0;
  for i := 0 to length(DerivedNodeSet) - 1 do
  begin
    if derivednodeset[i] <> nil then
      Inc(preresult);
  end;
  getCountDerivedNotNil := preresult;
end;

procedure TuibXMLDocument.getNextGenerationActNodeSet;
// thereby removing the nil elements
var
  i, n: integer;
begin
  LogDatei.log('Going to the next level ...', LLinfo);
  setlengthActNodeSet(0);
  n := length(FderivedNodeSet);
  for i := 0 to n - 1 do
  begin
    if derivednodeset[i] <> nil then
    begin
      setlengthActNodeSet(length(FActnodeset) + 1);
      FActNodeset[length(FActNodeSet) - 1] := derivednodeset[i];
    end;
  end;
end;


procedure TuibXMLDocument.makeNewDerivedNodeSet;
var
  i, n, j, basejindex: integer;

begin
  setLengthDerivedNodeSet(0);
  n := length(actNodeSet);
  for i := 0 to n - 1 do
  begin
    if actnodeset[i] <> nil then
      setlengthDerivedNodeSet(length(FDerivednodeset) + actnodeset[i].ChildNodes.Count);
  end;
  { fill with values }
  basejindex := 0;
  for i := 0 to n - 1 do
  begin
    if actnodeset[i] <> nil then
    begin
      for  j := 0 to actNodeSet[i].childnodes.Count - 1 do
        FDerivednodeset[basejindex + j] := actNodeset[i].childnodes[j];
      basejindex := basejindex + actNodeSet[i].childnodes.Count;
    end;
  end;
end;


procedure TuibXMLDocument.setlengthActNodeSet(newlength: integer);
begin
  setlength(factnodeset, newlength);
end;

procedure TuibXMLDocument.setlengthDerivedNodeSet(newlength: integer);
begin
  setlength(fderivednodeset, newlength);
end;

procedure TuibXMLDocument.cleanUpActNodeSet ();
var i, n: integer;
 myNodeSet: TNodeSet;
begin
  n:= length(actnodeset);
  for i := 0 to n - 1 do
  begin
    if actNodeSet[i] <> nil then
    begin
      setlength(myNodeSet, length(myNodeSet) + 1);
      mynodeset[length(myNodeSet) - 1] := actnodeset[i];
    end;
  end;
  actnodeset:=mynodeset;
end;

procedure TuibXMLDocument.cleanUpDerivedNodeSet ();
var i, n: integer;
 myNodeSet: TNodeSet;
begin
  n:= length(fderivednodeset);
  for i := 0 to n - 1 do
  begin
    if fderivednodeset[i] <> nil then
    begin
      setlength(myNodeSet, length(mynodeset) + 1);
      mynodeset[length(myNodeSet) - 1] := fderivednodeset[i];
    end;
  end;
  fderivednodeset:=mynodeset;
end;

procedure TuibXMLDocument.logNodeSets;
var
  i, basejindex, j: integer;
  count_not_nil: integer;
  count_not_nil_2: integer;

begin
  cleanUpActNodeSet();
  cleanUpDerivedNodeSet();
  LogDatei.log('', LLinfo);
  LogDatei.log('actNodeSet: ', LLinfo);
  count_not_nil := 0;
  for i := 0 to length(actNodeSet) - 1 do
  begin
    if actnodeset[i] = nil then
      LogDatei.log(extraindent + 'node ' + IntToStr(i) + ' null ', LLinfo)
    else
    begin
      LogDatei.log(extraindent + 'node ' + IntToStr(i) +
        ' elementname: "' + actNodeSet[i].NodeName + '"', LLinfo);
      Inc(count_not_nil);
    end;
  end;

  LogDatei.log('Non-null element(s) in act node set: ' + IntToStr(count_not_nil), LLinfo);

  count_not_nil_2 := 0;
  LogDatei.log('derivedNodeSet: ', LLinfo);

  for i := 0 to length(derivedNodeSet) - 1 do
  begin
    if derivednodeset[i] = nil then
      LogDatei.log(extraindent + 'node ' + IntToStr(i) + ' null ' , LLinfo)
    else
    begin
      LogDatei.log(extraindent + 'node ' + IntToStr(i) +
        ' elementname: "' + derivedNodeSet[i].NodeName + '"', LLinfo);
      Inc(count_not_nil_2);
    end;
  end;

  LogDatei.log('Non-null element(s) remaining in children node set: ' +
    IntToStr(count_not_nil_2), LLinfo);
  LogDatei.log('', LLinfo);
  LogDatei.log('    -------', LLinfo);
end;

procedure TuibXMLDocument.logActNodeSet;
var
  i: integer;
  count_not_nil: integer;

begin
  cleanUpActNodeSet();
  LogDatei.log( '', LLinfo);
  LogDatei.log( 'actNodeSet: ', LLinfo);
  count_not_nil := 0;
  for i := 0 to length(actNodeSet) - 1 do
  begin
    if actnodeset[i] = nil then
      LogDatei.log( extraindent + 'node ' + IntToStr(i) + ' null ', LLinfo)
    else
    begin
      LogDatei.log( extraindent + 'node ' + IntToStr(i) +
        ' elementname: "' + actNodeSet[i].NodeName + '"', LLinfo);
      Inc(count_not_nil);
    end;
  end;
  LogDatei.log('Non-null element(s) in act node set: ' + IntToStr(count_not_nil), LLinfo);

end;


//*************  Filters on Nodesets ********************************
function TuibXMLDocument.filterByAttributeList
                   (var attributenames : Tstringsarray;
                    var attributevalueExists : Tbooleansarray;
                    var attributevalues : TStringsArray;
                    attributes_strict : boolean) : Boolean;
// TODO - muss noch umgearbeitet werden??
  var
  i, n, j, basejindex, k, numberOfAttributes: Integer;

  b0, b1, b2 : boolean; // results of the crucial evaluations for each attribute

  goon : Boolean;
  attributename : String; // ergänzt, warum feht es?
  attributeList: TList;

begin
  result := true;
  numberOfAttributes := length(attributenames);

  if (numberOfAttributes = 0) and not attributes_strict
  then
  begin
    LogDatei.log ('no filtering by attributes requested', LLWarning);
    exit;
  end;


  LogDatei.log ('retaining child elements with the following attribute(s):', LLinfo);
  for k := 0 to numberOfAttributes - 1
  do
  begin
    if attributevalueExists[k]
    then
      LogDatei.log ('   "' + attributenames[k] + '" value="' + attributevalues[k] + '"', LLinfo)
    else
      LogDatei.log ('   "' + attributenames[k] + '"', LLinfo)
  end;


  basejindex := 0;

  i := 0;

  while i < length(actNodeSet)
  do
  Begin

     if actNodeSet[i] <> nil
     then
     begin

       n := actNodeSet[i].childnodes.count;

       for j:=0 to n-1
       do
       begin

         goon := true;

         if (FderivedNodeSet[basejindex + j] = nil)
         then
           goon := false;

         if goon
         then
         begin
           if attributes_strict
              // TODO
              //and
              //( actNodeSet[i].childnodes[j].AttributeNodes.Count <> length (attributenames) )
           then
           begin
             FderivedNodeSet[basejindex + j] := nil;
             LogDatei.log ('node ' + inttostr (basejindex + j) + ' not accepted: Number of attributes does not match', LLinfo);
             goon := false;
           end;

           k := 0;
           while goon and (k < numberOfAttributes)
           do
           begin
             // TODO
             //getNamespaceAndBasename (attributenames[k], uri, attributename);
             attributename:= '';  // nur damit es übersetzt, muss noch umgebaut und getestet werden
             //b1 := actNodeSet[i].childnodes.Item[j].HasAttributes (attributename);
             if b1
             then
               //b2 := actNodeSet[i].childnodes.Item[j].getattributes(attributename) = attributevalues[k]
             else
               b2 := false;

             if not b1
             then
             begin
                FderivedNodeSet[basejindex + j] := nil;

                LogDatei.log ('node ' + inttostr (basejindex + j) + ' not accepted: No attribute "' + attributenames[k] + '"', LLinfo);
                goon := false;
             end

             else
             begin
                if attributevalueExists[k] and not b2
                then
                begin
                  FderivedNodeSet[basejindex + j] := nil;

                  LogDatei.log ('node ' + inttostr (basejindex + j)
                     + ' not accepted: Not the required value "' + attributevalues[k] + '" for attribute "'
                      + attributenames[k] + '"', LLinfo);
                  goon := false;
                end
             end;

             inc (k);

           end;
         end;

       end;

       basejindex := basejindex + n;

     end;

     inc (i);
  end;
end;



function TuibXMLDocument.filterByAttributeName_existing (name: string) : Boolean;
var
  i, n, j, basejindex: Integer;
  b0, b1 : boolean;

begin
  LogDatei.log ('retaining child elements with attribute "' + name + '"', LLinfo);
  result:=true;
  basejindex := 0;

  i := 0;

  while i < length(actNodeSet)
  do
  Begin

     if actNodeSet[i] <> nil
     then
     begin
       n := actNodeSet[i].childnodes.count;

       for j:=0 to n-1
       do
       begin
         actnode:= actNodeSet[i].ChildNodes.Item[j];
         b1 := hasAttribute(name);
         b0 := FderivedNodeSet[basejindex + j] <> nil;

         if  b1 and b0
         then
            FderivedNodeSet[basejindex + j] := actNodeSet[i].childnodes.Item[j]
         else
            FderivedNodeSet[basejindex + j] := nil;
       end;
       basejindex := basejindex + n;
     end;
     inc (i);
  end;
end;


function TuibXMLDocument.filterByAttribute_existing (name: string; value : string) : Boolean;
var
  i, n, j, basejindex: Integer;
  b0, b1, b2 : boolean;


begin
  LogDatei.log ('retaining child elements with attribute "' + name + '" value: "' + value + '"', fdebuglevel );
  result:=true;
  basejindex := 0;

  i := 0;

  while i < length(actNodeSet)
  do
  Begin

     if actNodeSet[i] <> nil
     then
     begin

       n := actNodeSet[i].childnodes.count;

       for j:=0 to n-1
       do
       begin
         actnode:= actNodeSet[i].ChildNodes.Item[j];
         b0 := FderivedNodeSet[basejindex + j] <> nil;
         b1 := hasAttribute(name);
         b2 := '"' + getAttributeValue(name) + '"' = value;

         if b0 and b1 and b2
         then
            FderivedNodeSet[basejindex + j] := actnode
         else
            FderivedNodeSet[basejindex + j] := nil;
       end;

       basejindex := basejindex + n;

     end;

     inc (i);
  end;

end;

function TuibXMLDocument.filterByText (textvalue: string) : Boolean;
// nodeset filter: after filtering the derived nodeset contains only elements with
// text_content = textvalue
var
  i, n, j, basejindex: Integer;
  comparetext : String;
  myparentNode: TDOMNode;
begin
  myparentNode:= actNode;
  filterByText := true;

  LogDatei.log ('retaining child elements with text  "' + textvalue + '"', LLinfo);

  basejindex := 0;
  i := 0;
  while i < length(actNodeSet)
  do
  begin

     if actNodeSet[i] <> nil
     then
     begin

       n := actNodeSet[i].childnodes.count;

       for j:=0 to n-1
       do
       begin
         actnode:= actNodeSet[i].childnodes.Item[j];
         if actnode.NodeType = TEXT_NODE
         then
           comparetext := actnode.TextContent
         else
           comparetext := '';

         if AnsiCompareStr ( textvalue, comparetext ) = 0
         then
         begin
            FderivedNodeSet[basejindex + j]:= actnode;
         end

         else
            FderivedNodeSet[basejindex + j] := nil;
       end;

       basejindex := basejindex + n;

     end;

     inc (i);
  end;
  cleanUpActNodeSet();  // eliminate nil elements
  if getCountDerivedNotNil() > 0 then
    begin
      actnode:= FderivedNodeSet[0];
      filterByText:= true;
      if length(FderivedNodeSet) > 1 then
        LogDatei.log('more than one item has TEXT_CONTENT ' +
            textvalue + ', the first item becomes actNode', oslog.LLwarning)
      else
        LogDatei.log('item with TEXT_CONTENT ' +  actNode.TextContent
             + ' found, this item becomes actNode', oslog.LLinfo);
    end
  else
    begin
      filterByText:= false;
      actNode:= myparentNode;
      LogDatei.log('none of the items has TEXT_CONTENT ' +
            textvalue + ',  name of actNode is ' + actNode.NodeName, oslog.LLwarning);
    end;
end;

function TuibXMLDocument.filterByChildElement (elementname: string) : Boolean;
// nodeset filter: after filtering the derived nodeset contains only elements with
// node name = elementname
var
  i, n, j, basejindex: Integer;
begin
  filterByChildElement := false;

  LogDatei.log ('retaining child elements with name = "' + elementname + '"', LLInfo);
  basejindex := 0;
  i := 0;
  while i < length(actNodeSet)
  do
  Begin
     if actNodeSet[i] <> nil
     then
     begin
       n := actNodeSet[i].childnodes.count;
       for j:=0 to n-1
       do
       begin
         actNode:= actNodeSet[i].childnodes.Item[j];
         if (actNode.NodeName = elementname) then
           begin
             FderivedNodeSet[basejindex + j] := actNode;
             filterByChildElement:= true;
           end
         else
            FderivedNodeSet[basejindex + j] := nil;
       end;
       basejindex := basejindex + n;
     end;

     inc (i);
  end;
  cleanUpDerivedNodeSet();
  if length(FderivedNodeSet) > 0 then
    actnode:=FderivedNodeSet[0].ParentNode;

end;

//*************  Node-Operations ***********************************
function TuibXMLDocument.nodeExists(nodePath: string; attributes_strict:boolean ): boolean;
// tells if a node exists without changing anything
// if attributes_strict=true: check all attributes, true if path and all
//                            attributes fit, false if anything is wrong
// if attributes_strict=false: check only node path,
//                             true if node path exists, false if not

var
  nodesInPath: array[0..50] of TDOMNode;
  attributesSL, pathes: TStringList;
  k,i,j: integer;
  endOfPath, found: boolean;
  leavingPath, thisnodeName : string;
  attributeList: TList;
begin
  nodeExists := False;
  attributeList := TList.Create;
  try
    begin
      // the root node
      nodesInPath[0] := XML.DocumentElement;
      stringsplit(nodepath, XML2PATHSEPARATOR, pathes);
      // walk the path
      // The Path looks like this:
      // nodedescription XML2PATHSEPARATOR nodedescripton (and so on)
      // nodedescription looks like this
      // nodename attributeName="attributeValue"  or
      // nodename (node without attributes)
      // (!) attributeValue may contain a XML2PATHSEPARATOR string
      // XML2PATHSEPARATOR = ' // '
      i := 1;
      endOfPath := False;
      found := True;
      leavingPath := nodePath;
      LogDatei.log('begin to open nodepath, exists?  ' + nodepath, LLinfo);
      while (i < pathes.Count + 1) and found do
      begin
        attributeList.Clear;
        logdatei.log('path element ' + IntToStr(i) + ' : ' + pathes[i - 1], LLinfo);
        thisnodeName := Trim(copy(pathes[i - 1], 1, pos(' ', pathes[i - 1]) - 1));
        logdatei.log('thisnodename ' + thisnodeName, LLinfo);
        leavingPath := copy(pathes[i - 1], pos(' ', pathes[i - 1]) + 1, length(pathes[i - 1]));
        logdatei.log( 'leavingPath ' + leavingPath, LLinfo);
        if (pos('=', pathes[i - 1]) > 0) then // only in this case attributes
          begin
            // split on blank, list of attributes
            makeAttributesSL(attributesSL, leavingPath);
            for k:=0 to attributesSL.Count-1 do
               logdatei.log( 'Attribute ' +attributesSL[k], LLinfo );
            logdatei.log( 'Anzahl Attribute ' + IntToStr(attributesSL.Count), LLinfo );
            j:=0;
            while j < attributesSL.Count do
            begin
              // List of [attributename, attributevalue]
              attributeList.Add;
              attributeList.Items[j].key := Trim(
                       copy(attributesSL[j], 1, pos('=', attributesSL[j]) - 1));
              attributeList.Items[attributeList.Count-1].value :=  Trim(
                       copy(attributesSL[j], pos('=', attributesSL[j]) + 1, length(attributesSL[j])));
              if AnsiStartsStr('"', attributeList.Items[j].value) then
                attributeList.Items[j].value := copy(attributeList.Items[j].value,
                      2, length(attributeList.Items[j].value));
              if AnsiEndsStr('"', attributeList.Items[j].value) then
                attributeList.Items[j].value := Trim(copy(attributeList.Items[j].value,
                      1, length(attributeList.Items[j].value)-1));
               inc(j);
              end;
          end
        else
          thisnodeName := Trim(pathes[i - 1]);


        LogDatei.log('node ' + IntToStr(i) + ': nodename ' +  thisnodename, LLInfo   );
        if attributes_strict then
          begin
            if not getNodeStrict(nodesInPath[i], nodesInPath[i - 1], thisnodeName, attributeList) then
            begin
              found := False;
              LogDatei.log( 'opennode: node with attributes_strict not found ' + IntToStr(i) + ': nodename: ' +
                thisnodeName + ', check nodename and attributes - exit function', LLwarning
                );
              // failed - make all final settings
              result:=false;
              attributeList.Free;
              exit;
            end
            else
            begin
              found := True;
              if actnode<>nil then
                 logdatei.log('Found node with attributes_strict' + IntToStr(i) + ': nodename: ' +
                   actNode.NodeName, LLinfo)
              else
                logdatei.log('Found more then one node ' + IntToStr(i) + ': ' + IntToStr(length(actnodeset)) + ' nodes'
                   , LLinfo);
            end
          end
        else
          begin   // only check nodenames
            if getNodeByName(nodesInPath[i], nodesInPath[i - 1], thisnodeName) then
              begin
                LogDatei.log( 'Found node ' + IntToStr(i) + ': nodename: ' +
                  thisnodename, LLinfo);
                found := True;
              end
              else
              begin
                found := False;
                LogDatei.log( 'not found node ' + IntToStr(i) + ': nodename: ' +
                  thisnodename, LLwarning);
              end;
          end;

        Inc(i);
      end;
      attributeList.Free;
      Result:= found;
    end;
  except
    on e: Exception do
    begin
      LogDatei.log('nodeExists: node not found' + ': nodename: ' + thisnodename, LLwarning);
      Result := False;
    end;
  end;
end;

function TuibXMLDocument.openNode(nodePath: string; attributes_strict: boolean): boolean;
// if attributes_strict = true all attributes have to exist
//                      = false, other attributes may exist, no matter
// set actNode
var
  nodesInPath: array[0..50] of TDOMNode;
  attributesSL, pathes: TStringList;
  i,j,k: integer;
  found: boolean;
  leavingPath, thisnodeName, attribute : string;
  attributeList: TList;
begin
  Result := True;
  attributeList := TList.Create;
  try
    // the root node
    nodesInPath[0] := XML.DocumentElement;
    stringsplit(nodepath, XML2PATHSEPARATOR, pathes);
    // walk the path
    // The Path looks like this:
    // nodedescription XML2PATHSEPARATOR nodedescripton (and so on)
    // nodedescription looks like this
    // nodename attributeName="attributeValue"  or
    // nodename                          (node without attributes)
    // (!) attributeValue may contain a XML2PATHSEPARATOR string
    // XML2PATHSEPARATOR = ' // '
    i := 1;

    found := True;
    leavingPath := nodePath;
    logdatei.log('begin to open nodepath  : ' + nodepath, LLinfo);
    logdatei.log('-- pathes.Count: ' + IntToStr(pathes.Count), oslog.LevelInfo);
    while i < pathes.Count + 1 do
    begin
      attributeList.Clear;
      logdatei.log('path element ' + IntToStr(i) + ' : ' + pathes[i - 1], LLinfo);
      thisnodeName := Trim(copy(pathes[i - 1], 1, pos(' ', pathes[i - 1]) - 1));
      logdatei.log('thisnodename ' + thisnodeName, LLinfo);
      leavingPath := copy(pathes[i - 1], pos(' ', pathes[i - 1]) + 1, length(pathes[i - 1]));
      logdatei.log( 'leavingPath ' + leavingPath, LLinfo);
      if (pos('=', pathes[i - 1]) > 0) then // only in this case attributes
      begin
        // split on blank, list of attributes
        makeAttributesSL(attributesSL, leavingPath);
        for k:=0 to attributesSL.Count-1 do
           logdatei.log( 'Attribute ' +attributesSL[k], LLinfo );
        logdatei.log( 'Anzahl Attribute ' + IntToStr(attributesSL.Count), LLinfo );
        j:=0;
        while j < attributesSL.Count do
        begin
          // List of [attributename, attributevalue]
          attributeList.Add;
          attributeList.Items[j].key := Trim(
                   copy(attributesSL[j], 1, pos('=', attributesSL[j]) - 1));
          attributeList.Items[attributeList.Count-1].value :=  Trim(
                   copy(attributesSL[j], pos('=', attributesSL[j]) + 1, length(attributesSL[j])));
          if AnsiStartsStr('"', attributeList.Items[j].value) then
            attributeList.Items[j].value := copy(attributeList.Items[j].value,
                  2, length(attributeList.Items[j].value));
          if AnsiEndsStr('"', attributeList.Items[j].value) then
            attributeList.Items[j].value := Trim(copy(attributeList.Items[j].value,
                  1, length(attributeList.Items[j].value)-1));
          // ????
          (*
          leavingPath := copy(leavingPath, pos(' ', leavingPath) + 1, length(leavingPath));
          if pos('"' + XML2PATHSEPARATOR, leavingPath) > 0 then
            attributeList.Items[attributeList.Count-1].value := copy(leavingPath, 1, pos('"' + XML2PATHSEPARATOR, leavingPath))
          else
            attributeList.Items[attributeList.Count-1].value := leavingPath;
          *)
          inc(j);
        end;
      end
      else
        thisnodeName := Trim(pathes[i - 1]);

      logdatei.log('node ' + IntToStr(i) + ': nodename ' +
        thisnodename
        ,LLinfo
        );
      (*
      j:=0;
      while (j< attributeList.Count) do
      begin
        logdatei.log( attributeList.Items[j].key + ' : ' + attributeList.Items[j].value, LLinfo );
        inc(j);
      end;
      *)
      if attributes_strict then
      begin
        if not getNodeStrict(nodesInPath[i], nodesInPath[i - 1], thisnodeName, attributeList) then
          begin
            found := False;
            LogDatei.log( 'opennode: node with attributes_strict not found ' + IntToStr(i) + ': nodename: ' +
              thisnodeName + ', check nodename and attributes - exit function', LLwarning
              //+ ' attributeName: ' + attributeName
              //+ ' attributeValue: ' + attributeValue
              );
            // failed - make all final settings
            result:=false;
            attributeList.Free;
            exit;
          end
          else
          begin
            found := True;
            if actnode<>nil then
               logdatei.log('Found node with attributes_strict' + IntToStr(i) + ': nodename: ' +
                 actNode.NodeName, LLinfo)
              // + ' attributeName: ' + attributeName
              //+ ' attributeValue: ' + attributeValue

            else
              logdatei.log('Found more then one node ' + IntToStr(i) + ': ' + IntToStr(length(actnodeset)) + ' nodes'
                 , LLinfo);
          end
       end
       else  // not strict!
       begin
         if attributeList.Count = 0 then
         begin
           attributeList.Add;
           attributeList.Items[0].key := '';
           attributeList.Items[0].value := '';
         end;
         //else  attributeList contains one pair

         if not getNodeByNameAndAttribute(nodesInPath[i], nodesInPath[i - 1], thisnodeName, attributeList.Items[0].key, attributeList.Items[0].value) then
           begin
            found := False;
            LogDatei.log( 'opennode: node not found ' + IntToStr(i) + ': nodename: ' +
              thisnodeName , LLwarning
              );
          end
          else
          begin
            found := True;
            logdatei.log('Found node ' + IntToStr(i) + ': nodename: ' +
               actNode.NodeName, LLinfo)
          end;
       end;
      Inc(i);
    end;

    // ??? hier noch unklar
    if found and (actnode<>nil) then  // ????
    begin
      //actNode := nodesInPath[i - 1];
      LogDatei.log('actNode know node ' + IntToStr(i-1) + ': nodename: ' +
        actNode.NodeName, LLinfo
        // TODO if multiple nodes with same textcontent, continous string of text content -
        );
    end
    else
    begin
      // was soll actNode sein?
      actNode:= nil;
      LogDatei.log( 'actNode=nil; opennode: node not found, maybe ' + IntToStr(i-1) + ': nodename: ' +
        thisnodename , LLwarning
        );
    end;
    Result:=found;
    attributeList.Free;
  except
    on e: Exception do
    begin
      Result := False;
      LogDatei.log('Could not open ' + nodepath + '; exception: ' + e.Message, LLerror);
    end;
  end;
  cleanupactnodeset();
end;

function TuibXMLDocument.makeNodePathWithTextContent(nodePath: string;
         text: string) : boolean;
var
    nodesInPath: array[0..50] of TDOMNode;
    attributesSL, pathes: TStringList;
    i,j,k: integer;
    found: boolean;
    leavingPath, thisnodeName : string;
    attributeList: TList;
begin
   LogDatei.log('begin to make node with path: ' +
                       nodePath + ' and  TEXT_CONTENT: ' + textContent, LLinfo);
   makeNodePathWithTextContent:= False;
   setTopNodeAsActNode();
   makeTopAsActNodeSet();
   Result := True;
   attributeList := TList.Create;
  try
    // the root node
    nodesInPath[0] := XML.DocumentElement;
    stringsplit(nodepath, XML2PATHSEPARATOR, pathes);
    // walk the path and create all nodes
    // The Path looks like this:
    // nodedescription XML2PATHSEPARATOR nodedescripton (and so on)
    // nodedescription looks like this
    // nodename attributeName="attributeValue"  or
    // nodename                          (node without attributes)
    // (!) attributeValue may contain a XML2PATHSEPARATOR string
    // XML2PATHSEPARATOR = ' // '
    i := 1;

    found := true;
    leavingPath := nodePath;
    logdatei.log('begin to open nodepath  : ' + nodepath, LLinfo);
    logdatei.log('-- pathes.Count: ' + IntToStr(pathes.Count), oslog.LevelInfo);
    while i < pathes.Count + 1 do
    begin
      attributeList.Clear;
      logdatei.log('path element ' + IntToStr(i) + ' : ' + pathes[i - 1], LLinfo);
      thisnodeName := Trim(copy(pathes[i - 1], 1, pos(' ', pathes[i - 1]) - 1));
      logdatei.log('thisnodename ' + thisnodeName, LLinfo);
      leavingPath := copy(pathes[i - 1], pos(' ', pathes[i - 1]) + 1, length(pathes[i - 1]));
      logdatei.log( 'leavingPath ' + leavingPath, LLinfo);
      if (pos('=', pathes[i - 1]) > 0) then // only in this case attributes
      begin
        // split on blank, list of attributes
        makeAttributesSL(attributesSL, leavingPath);
        for k:=0 to attributesSL.Count-1 do
           logdatei.log( 'Attribute ' +attributesSL[k], LLinfo );
        logdatei.log( 'Anzahl Attribute ' + IntToStr(attributesSL.Count), LLinfo );
        j:=0;
        while j < attributesSL.Count do
        begin
          // List of [attributename, attributevalue]
          attributeList.Add;

          attributeList.Items[j].key := Trim(
                   copy(attributesSL[j], 1, pos('=', attributesSL[j]) - 1));
          logdatei.log( ' attributeList.Items[j].key ' +  attributeList.Items[j].key, LLinfo);
          attributeList.Items[attributeList.Count-1].value :=  Trim(
                   copy(attributesSL[j], pos('=', attributesSL[j]) + 1, length(attributesSL[j])));
          if AnsiStartsStr('"', attributeList.Items[j].value) then
            attributeList.Items[j].value := copy(attributeList.Items[j].value,
                  2, length(attributeList.Items[j].value));
          if AnsiEndsStr('"', attributeList.Items[j].value) then
            attributeList.Items[j].value := Trim(copy(attributeList.Items[j].value,
                  1, length(attributeList.Items[j].value)-1));
           inc(j);
          end;
      end
      else
        thisnodeName := Trim(pathes[i - 1]);

      logdatei.log('node ' + IntToStr(i) + ': nodename ' +
        thisnodename
        ,LLinfo
        );


      if actNode<>nil then
            logdatei.log('actnode: ' + actnode.NodeName,LLinfo )
      else
            logdatei.log('actnode: is nil',LLinfo );

      if found then
        begin
        if (not getNodeStrict(nodesInPath[i], nodesInPath[i - 1], thisnodeName, attributeList)) then
            begin
              found := false;
              actNode:= nodesInPath[i - 1];
              LogDatei.log( 'makeNodePathWithTextContent: node not found ' + IntToStr(i) + ': nodename: ' +
                thisnodeName + ', Node will be created', LLInfo
                );
              makeNode(thisnodeName);
              k:=0;
              while k < attributeList.Count do
              begin
                addAttribute(attributeList.Items[k].key,attributeList.Items[k].value);
                inc(k);
              end;
            end
        else
            begin
              found := True;
              if actnode<>nil then
                 logdatei.log('Found node ' + IntToStr(i) + ': nodename: ' +
                   actNode.NodeName, LLinfo)
              else
                logdatei.log('Found more then one node ' + IntToStr(i) + ': ' + IntToStr(length(actnodeset)) + ' nodes'
                   , LLinfo);
            end
      end
      else
        begin
          LogDatei.log( 'makeNodePathWithTextContent: node not found ' + IntToStr(i) + ': nodename: ' +
              thisnodeName + ', Node will be created', LLInfo
              );
          makeNode(thisnodeName);
          k:=0;
          while k < attributeList.Count do
          begin
            addAttribute(attributeList.Items[k].key,attributeList.Items[k].value);
            inc(k);
          end;
        end;
      Inc(i);
    end;
    attributeList.Free;

    // ??? hier noch unklar, actNode sollte der letzte Knoten sein
    if (actnode<>nil) then  // ????
    begin
      //actNode := nodesInPath[i - 1];
      LogDatei.log('actNode know node ' + IntToStr(i-1) + ': nodename: ' +
        actNode.NodeName, LLinfo
        );
      actNode.TextContent:=text;
    end
    else
    begin
      // was soll actNode sein?
      actNode:= nil;
      LogDatei.log( 'actNode=nil; makeNodePathWithTextContent: node not found, maybe ' + IntToStr(i-1) + ': nodename: ' +
        thisnodename , LLwarning
        );
    end;
  except
    on e: Exception do
    begin
      Result := False;
      LogDatei.log('makeNodePathWithTextContent: Error in creating path ' + nodepath + ' with textcontent' + text + '; exception: ' + e.Message, LLerror);
    end;
  end;
  cleanupactnodeset();
end;

function TuibXMLDocument.makeNode(mynodeName: String) : boolean;
// create new node, append to actNode, set newnode as actNode
var
  newnode: TDOMNode;
begin
  LogDatei.log('begin to make node with nodename: ' +
    mynodeName, LLinfo);
  makeNode := False;
  try
    if actNode <> nil then
    begin
      newnode := XML.CreateElement(mynodeName);
      actNode.AppendChild(newnode);
      actNode := newnode;
      makeNode := True;
    end
    else
      LogDatei.log('actNode is nil. cannot make and append node', LLwarning);
  except
    LogDatei.log('error to make node with nodename: ' +
      mynodeName, LLerror);
  end;
end;

function TuibXMLDocument.makeNode(mynodeName,
  attributeName, attributeValue: string): boolean;
  // create new node, append to actNode, set newnode as actNode
var
  newnode: TDOMNode;
begin
  LogDatei.log('begin to make node with nodename: ' +
    mynodeName + ' attributeName: ' + attributeName +
    ' attributeValue: ' + attributeValue , LLinfo
    );
  makeNode := False;
  try
    if actNode <> nil then
    begin
      newnode := XML.CreateElement(mynodeName);
      if attributeName <> '' then
      begin
        TDOMElement(newnode).SetAttribute(attributeName, attributeValue);
      end;
      actNode.AppendChild(newnode);
      actNode := newnode;
      makeNode := True;
    end
    else
      LogDatei.log('actNode is nil. cannot make and append node', LLwarning);
  except
    LogDatei.log('error to make node with nodename: ' +
      mynodeName + ' attributeName: ' + attributeName +
      ' attributeValue: ' + attributeValue , LLerror
      );
  end;
end;

function TuibXMLDocument.makeNodeAndKeepActNode(mynodeName:string): boolean;
// create new node, append to actNode, actNode is kept
var
  newnode: TDOMNode;
begin
  LogDatei.log('begin to make node with nodename: ' +
    mynodeName , LLinfo);
  makeNodeAndKeepActNode := False;
  try
    if actNode <> nil then
    begin
      newnode := XML.CreateElement(mynodename);
      actNode.AppendChild(newnode);
      makeNodeAndKeepActNode := True;
    end
    else
      LogDatei.log('actNode is nil. cannot make and append node', LLwarning);
  except
    LogDatei.log('error to make node with nodename: ' +
      mynodeName, LLerror);
  end;
end;

function TuibXMLDocument.makeNodeAndKeepActNode(mynodeName,
  attributeName, attributeValue, text: string): boolean;
// create new node, append to actNode, actNode is kept
var
  newnode: TDOMNode;
begin
  LogDatei.log('begin to make node with nodename: ' +
    mynodeName + ' attributeName: ' + attributeName +
    ' attributeValue: ' + attributeValue , LLinfo
    );
  makeNodeAndKeepActNode := False;
  try
    if actNode <> nil then
    begin
      newnode := XML.CreateElement(mynodename);
      newnode.TextContent:=text;
      if attributeName <> '' then
      begin
        TDOMElement(newnode).SetAttribute(attributeName, attributeValue);
      end;
      actNode.AppendChild(newnode);
      makeNodeAndKeepActNode := True;
    end
    else
      LogDatei.log('actNode is nil. cannot make and append node', LLwarning);
  except
    LogDatei.log('error to make node with nodename: ' +
      mynodeName + ' attributeName: ' + attributeName +
      ' attributeValue: ' + attributeValue , LLerror
      );
  end;
end;

function TuibXMLDocument.makeNodes
                     ( mynodeName: String;
                     const textArray:TStringList)
                     :boolean;
// creates couple of nodes in actnode with equal names
// and different TextContent, actNode will be same after creation
var
  index: Integer;
begin
  if textArray.Count>0 then
  begin
    makeNodes:=true;
    for index := 0 to textArray.Count-1 do
    begin
     makeNodeAndKeepActNode(mynodeName,'','', textArray[index]);
    end
  end
  else
  begin
    LogDatei.log('length of Array is 0: ', LLerror);
    makeNodes:= false;
  end;
end;

// überladen!!!
procedure TuibXMLDocument.delNode(nodePath: string);
var
  removeNode: TDOMNode;
begin
  LogDatei.log('begin to del Node: ' + nodePath, LLinfo);
  openNode(nodePath, false);  // not strict
  if actNode<> nil then
    begin
      removeNode := actNode;
      actNode := actNode.ParentNode;
      try
        removenode.Free;
      except
        LogDatei.log('Error in delNode: ' + nodePath + '. Node was not removed', LLerror);
      end;
    end
  else
    LogDatei.log('Error in delNode: ' + nodePath + ', node not found', LLerror);
end;

procedure TuibXMLDocument.delNode;
// aktnode (and all childs) will be deleted, afterwards aktnode will be parent
// before del node check node with nodeExists
var
  removeNode: TDOMNode;
begin
  if actNode<>nil then
    begin
      LogDatei.log('begin to del Node: ' + actNode.NodeName, LLinfo);
      removeNode := actNode;
      actNode := actNode.ParentNode;
      try
        removenode.Free;
      except
        LogDatei.log('Error in delNode. Node was not removed', LLerror);
      end;
    end
  else
    LogDatei.log('delNode: actNode is nil', LLwarning);
end;

procedure TuibXMLDocument.setTopNodeAsActNode();
// set top node as actual node
begin
  actNode :=  getDocumentElement();
end;

procedure TuibXMLDocument.setFirstChildAsActNode();
// set first child as actual node
begin
  if actNode <> nil then
    actNode := actNode.FirstChild;
end;

procedure TuibXMLDocument.setParentNodeAsActNode();
// set parent node as actual node
begin
  if actNode <> nil then
    actNode := actNode.ParentNode
end;

procedure TuibXMLDocument.setNodeTextActNode(Text: string);
begin
    LogDatei.log('begin to set text to actNode: ' + Text, LLinfo);
    if actNode <> nil then
    begin
      actNode.TextContent := Text;
      LogDatei.log('setNodeTextActNode - TextContent is: ' + actNode.TextContent, LLinfo)
    end
    else
      LogDatei.log('actNode is nil, text not set: ' + Text, LLwarning);
end;

function TuibXMLDocument.setActNodeIfText(textvalue: string): boolean;
// get first and hopefully unique node with text_content = nodeText
// set this Node as actNode

var
  i, j, n, basejindex: integer;
  comparetext: string;
  myparentNode: TDOMNode;

begin
  myparentNode:= actNode;
  setActNodeIfText := False;
  LogDatei.log('set child element of aktnode as aktnode, text has to be "' + textvalue +
    '"', oslog.LLinfo);

  basejindex := 0;
  i := 0;
  while i < length(actNodeSet)
  do
  begin

     if actNodeSet[i] <> nil
     then
     begin

       n := actNodeSet[i].childnodes.count;

       for j:=0 to n-1
       do
       begin
         actnode:= actNodeSet[i].childnodes.Item[j];
         if actnode.NodeType = ELEMENT_NODE
         then
           comparetext := actnode.TextContent
         else
           comparetext := '';

         if AnsiCompareStr ( textvalue, comparetext ) = 0
         then
         begin
            FderivedNodeSet[basejindex + j]:= actnode;
         end

         else
            FderivedNodeSet[basejindex + j] := nil;
       end;

       basejindex := basejindex + n;

     end;

     inc (i);
  end;
  cleanUpDerivedNodeSet();
  if getCountDerivedNotNil() > 0 then
    begin
      actnode:= FderivedNodeSet[0];
      setActNodeIfText:= true;
      if length(FderivedNodeSet) > 1 then
        LogDatei.log('more than one item has TEXT_CONTENT ' +
            textvalue + ', the first item becomes actNode', oslog.LLwarning)
      else
        LogDatei.log('item with TEXT_CONTENT ' +  actNode.TextContent
             + ' found, this item becomes actNode', oslog.LLinfo);
    end
  else
    begin
      setActNodeIfText:= false;
      actNode:= myparentNode;
      LogDatei.log('none of the items has TEXT_CONTENT ' +
            textvalue + ',  name of actNode is ' + actNode.NodeName, oslog.LLwarning);
    end;
end;

function TuibXMLDocument.getNodeStrict(var newNode: TDOMNode; myparentNode: TDOMNode;
  mynodeName: string; attributeList : TList): boolean;
// private
// nodename and all attributes have to fit
// if not found: actnode = myparentnode - result false
// if found and unique : actnode = node found - result true
// if found and not unique : actnode = nil, check actnodeset - result true
var
  n, j, i, al: integer;
  attributename, attributevalue : string;
  actattributename, actattributevalue : string;
  boolarray : array [0..9] of boolean;
  namefound, attributesfound: boolean;
  attributecount1,attributecount2 : integer;
begin
  Result := False;

  logdatei.log('begin to get node  nodename: ' + mynodename + ' with attributes: ', LLinfo );
  for al:= 0 to attributeList.Count-1 do
    logdatei.log(attributelist.Items[al].key + ' : ' + attributelist.Items[al].value, LLinfo );
  // find nodes with name
  namefound:= false;
  try
    if (myparentNode <> nil) then
      begin
        j := 0;
        i:=0;
        // find nodes with nodename
        while (myparentNode.hasChildNodes) and (j < myparentNode.ChildNodes.Count)
               do
        begin
          if (myparentNode.ChildNodes.Item[j].NodeName = mynodeName) then
            begin
              namefound:= true;
              //newNode := myparentNode.ChildNodes.Item[j];
              setLengthActNodeset(i+1);
              actNode := myparentNode.ChildNodes.Item[j];
              actNodeSet[i]:=actNode;
              inc(i);
            end;
          inc(j);
        end;
      end;
  finally
  end;

  logdatei.log('node(s) found with name ' + mynodeName + ': ' + IntToStr(length(actNodeSet)), oslog.LLinfo);

  if namefound then
  begin
    //result:= true;
    if attributeList.Count<10 then  // only 10 attributes
    begin
      j:=0;
      n:=1;
      while j<length(actNodeSet) do  // check attributes for node j
      begin
        for al:=0 to 9 do
          boolarray[al]:=false;
        for al:=0 to attributelist.Count-1 do
          attributelist.Items[al].isvalid:=false;
        logdatei.log(' ', oslog.LLinfo);
        logdatei.log(IntToStr(N) + ' -> find attributes for node ' + actnodeset[j].NodeName + ', number of attributes ' + IntToStr(attributeList.Count) , LLinfo );
        if actnodeset[j].HasAttributes then
        begin
          al:=0;
          if attributeList<> nil then
            while (al<attributeList.Count) do  // proof attributes key/value
            begin
              attributename:=attributelist.Items[al].key;
              attributevalue:=attributelist.Items[al].value;
              // check attributes
              for i := 0 to actnodeset[j].Attributes.Length - 1 do
              begin
                actattributename:=actnodeset[j].Attributes[i].NodeName;
                actattributevalue:=actnodeset[j].Attributes[i].TextContent;
                if (actattributename = attributeName)
                and (actattributevalue = attributeValue) then
                begin
                  logdatei.log('attribut found ' + attributename + ' ' + attributevalue, LLinfo );
                  boolarray[al]:=true;
                  attributelist.Items[al].isvalid:=true;
                end
                //else attributelist.Items[al].isvalid:=false;
              end;
              Inc(al);
            end;

        end; // has attributes

        logdatei.log('all attributes have to fit, nodename ' + actnodeset[j].NodeName , oslog.LLinfo);

        attributecount1 := attributeList.Count;
        attributecount2 := actnodeset[j].Attributes.Length;
        if (attributecount1=attributecount2) then // check if all attributes fit
          begin
            attributesfound:=true;
            // to max(attributeList.Count-1, myparentNode.ChildNodes.Item[j].Attributes.Length - 1)
            for al:=0 to attributeList.Count-1 do
            begin
              if attributelist.Items[al].isvalid then logdatei.log('key/value found ' + attributelist.Items[al].key + ':' + attributelist.Items[al].value, oslog.LLinfo)
              else logdatei.log('key/value not found ' + attributelist.Items[al].key + ':' + attributelist.Items[al].value , oslog.LLDebug2);
              attributesfound:= attributesfound AND boolarray[al]; //
            end;
            if not attributesfound then
            begin
              logdatei.log('one or more attributes does not match, nodename ' + actnodeset[j].NodeName, oslog.LLDebug2);
              // remove node
              actnodeset[j]:=nil;
              j:=j-1;
            end
          end
        else // strict: identical number of attributes!
          begin
            logdatei.log('Attribute count mismatch: given by path: '+inttostr(attributecount1)+' but node has: '+inttostr(attributecount2), oslog.LLwarning);
            actnodeset[j]:=nil;
            j:=j-1;
          end;
        cleanupactnodeset();
        inc(j);
        inc(n);
      end;  // end traverse actNodeSet
      //
      logdatei.log('actnodeset after retrieving key/value ', oslog.LLinfo);
      logActNodeSet;
      if  length(actnodeset) > 1 then
      begin
        logdatei.log('There is more than one mathing node here - just taking the first', oslog.LLWarning);
        for j := 1 to length(actnodeset) - 1 do actnodeset[j]:=nil;
        cleanupactnodeset();
      end;
      if  length(actnodeset) = 1 then
        begin
          actnode:=actnodeset[0];
          newNode := actnodeset[0];  // ??
          logdatei.log('result true, actNode and newnode is ' + actNode.NodeName, oslog.LLinfo) ;
          result:=true;
        end
        else
        begin
          actnode:=nil;
          logdatei.log('result false, actnode is nil, lenght of actNodeSet is ' + IntToStr(length(actnodeset)), oslog.LLinfo) ;
        end
    end
   else
      logdatei.log('handling of more then 10 attributes not implemented', oslog.LLerror);
  end // end nodename found
  else
    begin
      result:=false;
      actNode:=myparentnode;
      logdatei.log('node name not found, actnode is parentnode', oslog.LLerror);
    end
end;


function TuibXMLDocument.getNodeTextActNode() : String;
// get text at the actual node
begin
  getNodeTextActNode:='';
  if actNode <> nil then
  begin
    getNodeTextActNode:= actNode.TextContent;
    LogDatei.log('get text from actNode: ' + actNode.TextContent, LLinfo)
  end
  else
    LogDatei.log('actNode is nil, can not get text: ', LLwarning);
end;

function TuibXMLDocument.getNodeNameActNode ( ) : string;
begin
  getNodeNameActNode:='';
  if actNode <> nil then
  begin
    getNodeNameActNode:= actNode.NodeName;
    LogDatei.log('get nodeName from actNode: ' + actNode.NodeName, LLinfo)
  end
  else
    LogDatei.log('actNode is nil, can not get nodeName ', LLwarning);
end;

function TuibXMLDocument.getNodeByName(var newNode: TDOMNode; myparentNode: TDOMNode;
  mynodeName: string): boolean;
// private
var
  j, i: integer;
begin
  getNodeByName := False;
  logdatei.log('begin to get node  nodename: ' + mynodename , LLinfo );
  try
    if (myparentNode <> nil) then
    begin
      j := 0;
      while (myparentNode.hasChildNodes) and (j < myparentNode.ChildNodes.Count) and
        (getNodeByName = False) do
      begin
        // compare nodenames
        if (myparentNode.ChildNodes.Item[j].NodeName = mynodeName) then
          begin
            newNode := myparentNode.ChildNodes.Item[j];
            actNode := myparentNode.ChildNodes.Item[j];
            getNodeByName := True;
          end;
        Inc(j);
      end;
    end
    else
      logdatei.log('parentnode not valid', oslog.LLerror);
  finally

  end;
end;

function TuibXMLDocument.getNodeByNameAndAttribute(var newNode: TDOMNode; myparentNode: TDOMNode;
  mynodeName: string; attributename: string; attributevalue : string): boolean;
// private
// for name and only one attribute
var
  j, i: integer;
begin
  getNodeByNameAndAttribute := False;
  logdatei.log('begin to get node  nodename: ' + mynodename + ' with attributes: ', LLinfo );

  try
    if (myparentNode <> nil) then
    begin
      j := 0;
      while (myparentNode.hasChildNodes) and (j < myparentNode.ChildNodes.Count) and
        (getNodeByNameAndAttribute = False) do
      begin
        // compare attributes if given in parameter and existing
        if (myparentNode.ChildNodes.Item[j].NodeName = mynodeName) then
          if (myparentNode.ChildNodes.Item[j].HasAttributes)
              and (attributename <> '') then
          begin
            for i := 0 to myparentNode.ChildNodes.Item[j].Attributes.Length - 1 do
            begin
              if (myparentNode.ChildNodes.Item[j].Attributes[i].NodeName =
                attributeName) and (myparentNode.ChildNodes.Item[
                j].Attributes[i].TextContent = attributeValue) then
              begin
                newNode := myparentNode.ChildNodes.Item[j];
                actNode := myparentNode.ChildNodes.Item[j];
                getNodeByNameAndAttribute := True;
              end;
            end;
          end
          else   // also found if there are no attributes but name found
          begin
            newNode := myparentNode.ChildNodes.Item[j];
            actNode := myparentNode.ChildNodes.Item[j];
            getNodeByNameAndAttribute := True;
          end;
        Inc(j);
      end;
    end
    else
      logdatei.log('parentnode not valid', oslog.LLerror);
  finally

  end;
end;


//*************  XML Attribute-Handling ***********************************
function TuibXMLDocument.countAttributes ( myxmlnode: TDOMNode ) : integer;
begin
  if myxmlnode.HasAttributes then
    Result := myxmlnode.Attributes.Length
  else
    Result := 0;
end;

function TuibXMLDocument.hasAttribute(attributename: string): boolean;
var
  i: integer;
begin
  Result := False;
  if (actNode<>nil) then
  begin
    if (actNode.HasAttributes) then
    begin
      for i := 0 to actNode.Attributes.Length - 1 do
      begin
        if (actNode.Attributes[i].NodeName = attributename) then
        begin
          Result := True;
          LogDatei.log('actNode has attribute with name: '
            + attributeName, LLinfo);
        end;
      end;
    end;
    if Result = False then
      LogDatei.log('actNode has no attribute with name: '
        + attributeName,  LLwarning);
  end
  else
    LogDatei.log('hasAttribute failed, actNode is nil: ' +
        attributeName, LLerror);
end;

procedure TuibXMLDocument.setAttribute(attributeName, attributeValue: string);
// set if exists, otherwise create
var
  i: integer;
  found: boolean;
begin
  LogDatei.log('begin setAttribute name: ' +
    attributeName + ', value: ' + attributeValue, oslog.LLinfo);
  found:= false;
  if (actNode<>nil) then
  begin
    if actNode.HasAttributes then
    begin
      for i := 0 to actNode.Attributes.Length - 1 do
        if actNode.Attributes[i].NodeName = attributeName then
          begin
            actNode.Attributes[i].TextContent := attributevalue;
            LogDatei.log('setAttribute with name: ' +
              attributeName + ' value: ' + attributeValue, LLinfo);
            found:= true;
          end
    end;
    if not found then
      begin
        TDOMElement(actNode).SetAttribute(attributeName, attributeValue);
        LogDatei.log('setAttribute, create attribute with name: ' +
          attributeName + ' value: ' + attributeValue, LLinfo);
      end
  end
  else
    LogDatei.log('setAttribute failed, actNode ist nil: ' +
        attributeName + ' value: ' + attributeValue, LLerror);
end;

procedure TuibXMLDocument.addAttribute(attributeName, attributeValue: string);
// only add attribute if attribute does not exist
begin
  LogDatei.log('begin to add attribute: name: ' +
    attributeName + ' value: ' + attributeValue, LLinfo);
  if (actNode<>nil) then
    if NOT(TDOMElement(actNode).hasAttribute(attributeName)) then
      TDOMElement(actNode).SetAttribute(attributeName, attributeValue)
    else
  else
    LogDatei.log('addAttribute failed, actNode ist nil: name' +
        attributeName + ' value: ' + attributeValue, LLerror);
end;

procedure TuibXMLDocument.delAttribute(attributeName: string);
begin
  LogDatei.log('begin to del attribute: name: ' + attributeName, LLinfo);
  if (actNode<>nil) then
    if (actNode.HasAttributes) then
      TDOMElement(actNode).RemoveAttribute(attributeName)
    else
      LogDatei.log('delAttribute failed, name: ' +
        attributeName + 'does not exist', LLerror)
  else
    LogDatei.log('delAttribute failed, actNode ist nil: name: ' +
        attributeName,  LLerror);
end;


function TuibXMLDocument.getAttributeValue(attributeName: string): string;
  // get the attribute value at the actual node
  // ATTENTION: it returns an empty string:
  // - if there is no attribute with this name
  // - if the value of this attribute is an empty string
begin
  LogDatei.log('begin to get value of attribute: name: '
    + attributeName, LLinfo);
  getAttributeValue := '';
  if (actNode <> nil) and actNode.HasAttributes then
    getAttributeValue := TDOMElement(actNode).GetAttribute(attributeName)
  else
    LogDatei.log('getAttribute failed, name: ' +
        attributeName + 'does not exist or actNode is nil',  LLwarning)

end;

procedure TuibXMLDocument.makeAttributesSL (var attributeStringList: TStringList; attributePath : String);
// private
var
  i: integer;
  attribute : String;
  leavingpath: String;
begin
  logdatei.log('attribute path element : ' + attributePath, LLinfo);
  attributeStringList:= TStringList.Create;
  i:=1;
  while (length(attributePath)>0) do
  begin
    if Length(attributePath)-Length(StringReplace(attributePath, '"','', [rfReplaceAll, rfIgnoreCase])) = 2  then
    begin // only one remaining attribute
      AttributeStringList.Add(Trim(attributePath));
      attributePath:='';
    end
    else
    begin
      // find with '" ' the end of an attribute
      attribute:= Trim(copy(attributePath, 1, pos('" ', attributePath) ));
      //logdatei.log('attribute ' + IntToStr(i) + ': ' + attribute, LLinfo);
      leavingPath := copy(attributePath, pos('" ', attributePath) + 1, length(attributePath));
      //logdatei.log( 'leavingPath ' + leavingPath, LLinfo);
      AttributeStringList.Add(attribute);
      attributePath:=leavingPath;
    end;
    inc(i);
  end;

end;


end.

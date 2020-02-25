unit OpsiHTMLMessageBody;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, OpsiHTTPMessageBody;

type

  { TOpsiHTMLMessageBody }

  TOpsiHTMLMessageBody = class(TOpsiHTTPMessageBody)
    HTML : TStringList;
    constructor Create(aHTML: TStringList);
    constructor Create(aURI: string; aPeerName: string);//creates a htmltestside giving back URI and PeerName
    procedure SaveToMemoryStream(aMemoryStream: TMemoryStream);override;
  end;

implementation

{ TOpsiHTMLMessageBody }

constructor TOpsiHTMLMessageBody.Create(aHTML: TStringList);
begin
  inherited Create;
  HTML := aHTML;
end;

constructor TOpsiHTMLMessageBody.Create(aURI: string; aPeerName: string);
begin
  inherited Create;
  HTML := TStringList.Create;
  HTML.Add('<html>');
  HTML.Add('<head></head>');
  HTML.Add('<body>');
  HTML.Add('<h2>This document is generated by opsiclientd-light for mac!</h2>');
  HTML.Add('Request Uri: ' + aUri);
  HTML.Add('<br>');
  if aPeerName = '' then
    HTML.Add('No client certificate received')
  else
    HTML.Add('Client certificate received from ' + aPeerName);
  HTML.Add('</body>');
  HTML.Add('</html>');
end;

procedure TOpsiHTMLMessageBody.SaveToMemoryStream(aMemoryStream: TMemoryStream);
begin
  HTML.SaveToStream(aMemoryStream);
end;

end.


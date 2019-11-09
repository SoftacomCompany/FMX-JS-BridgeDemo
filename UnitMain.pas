unit UnitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.WebBrowser,
  System.IOUtils, FMX.StdCtrls,
  SG.ScriptGate, FMX.Controls.Presentation;

type
  TfrmMain = class(TForm)
    wbWebBrowser: TWebBrowser;
    tDemoDeviceToken: TTimer;
    Panel1: TPanel;
    Label1: TLabel;
    lblSomeText: TLabel;
    lblValueFromJavaScript: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure tDemoDeviceTokenTimer(Sender: TObject);
  private var
    FScriptGate: TScriptGate;
    { Private declarations }
  public
    { Public declarations }
    // Procedure called from JavaScript code.
    procedure SendToHost;
    // Procedure receives data from JavaScript code.
    procedure SendToHostValue(Value: String);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    var url :=
        {$IFDEF  MSWINDOWS}
            ExtractFilePath(ParamStr(0)) + 'www\index.html';
        {$ENDIF}
        {$IFDEF ANDROID}
            'file:///' + System.IOUtils.TPath.GetTempPath + PathDelim + 'www' + 'index.html';
            FPermission := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
        {$ENDIF}

    wbWebBrowser.URL := url;
    FScriptGate := TScriptGate.Create(Self, wbWebBrowser,'fmx-js');
    wbWebBrowser.Navigate;
end;

procedure TfrmMain.SendToHost;
begin
    lblSomeText.Text := '"SendToHost" method called.';
end;

procedure TfrmMain.SendToHostValue(Value: String);
begin
    lblValueFromJavaScript.Text := 'Value from JavaScript: ' + Value;
end;

procedure TfrmMain.tDemoDeviceTokenTimer(Sender: TObject);
begin
    // Here we will generate some fake data for demonstration.

    // Imagine, we retrieved here Push Notifications token, which we want to
    // send to the server using JavaScript REST API calls implementation.

    var deviceToken := 'KGKYHHGHHJ76KGHKGHG7';
    FScriptGate.CallScript('document.getElementById("text1").innerText = "Device token: ' + deviceToken + '";' ,nil);
end;

end.

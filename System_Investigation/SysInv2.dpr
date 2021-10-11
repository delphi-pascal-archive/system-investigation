program SysInv2;

uses
  Forms,
  Windows,
  Messages,
  AboutDlg in 'Src\AboutDlg.pas' {AboutForm},
  SplashDlg in 'Src\SplashDlg.pas' {SplashForm},
  ExecFile in 'Src\ExecFile.pas',
  GetInfo in 'Src\GetInfo.pas',
  MainDlg in 'Src\MainDlg.pas' {MainForm};

// added for OnlyOneInstance
const
  CM_RESTORE = WM_USER + $1000;
var
  RvHandle : hWnd;
  {$R *.RES}

begin
  // If there's another instance already running, activate that one then
  // exit from this. If not normal execution start
  RvHandle := FindWindow('SysInv2', NIL);
  if RvHandle > 0 then begin
     PostMessage(RvHandle, CM_RESTORE, 0, 0);
     Exit;
  end;

  // create then execute the timed splash screen, then close himself 
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Update;

  // follows normal program startup code
  Application.Initialize;
  Application.Title := 'System Investigation 2';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.

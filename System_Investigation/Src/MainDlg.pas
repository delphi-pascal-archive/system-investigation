{-------------------------------------------------------------------------------
  PROJECT   : SysInv 2
  FILE      : MainDlg
  DATE      : 24.DIC.1999
  VERSION   : 1.0d
  AUTHOR    : Riccardo "Rico" Pareschi
  COMPANY   : RicoSoft
  NOTE      :
}
unit MainDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, Buttons, Grids, Mask, OleCtrls, SHDocVw, ShlObj;

const
  // added for one instance, called from message handler
  CM_RESTORE = WM_USER + $1000;

type
  TMainForm = class(TForm)
    PageCt: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    RootPathNameStx: TStaticText;
    VolumeNameStx: TStaticText;
    VolumeSerialNumberStx: TStaticText;
    FileSystemNameStx: TStaticText;
    Label3: TLabel;
    CurrentDirectoryStx: TStaticText;
    SystemDirectoryStx: TStaticText;
    Label5: TLabel;
    Label6: TLabel;
    WindowsDirectoryStx: TStaticText;
    Label8: TLabel;
    DrivesStx: TStaticText;
    DrivesRG: TRadioGroup;
    SectorsPerClusterStx: TStaticText;
    BytesPerSectorStx: TStaticText;
    FreeClustersStx: TStaticText;
    TotalClustersStx: TStaticText;
    ClusterSizeStx: TStaticText;
    FreeBytesStx: TStaticText;
    TotalBytesStx: TStaticText;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    AvailBytesStx: TStaticText;
    Label16: TLabel;
    Panel2: TPanel;
    ExitSB: TSpeedButton;
    TabSheet4: TTabSheet;
    StatBar: TStatusBar;
    AboutSB: TSpeedButton;
    GroupBox1: TGroupBox;
    ProcOemIdStx: TStaticText;
    ProcNumStx: TStaticText;
    ProcTypeStx: TStaticText;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    GroupBox2: TGroupBox;
    MemTotalStx: TStaticText;
    MemAvailableStx: TStaticText;
    MemUsageStx: TStaticText;
    SwapFileSettingStx: TStaticText;
    SwapFileSizeStx: TStaticText;
    SwapFileUsageStx: TStaticText;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    ProcVersStx: TStaticText;
    Label29: TLabel;
    WinTempPathStx: TStaticText;
    NetComputerNameStx: TStaticText;
    NetUserNameStx: TStaticText;
    Label28: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    DriveTypeStx: TStaticText;
    Label38: TLabel;
    StringGrid: TStringGrid;
    Label36: TLabel;
    Bevel1: TBevel;
    PathName: TMaskEdit;
    ExecuteBtn: TButton;
    GroupBox3: TGroupBox;
    SystemDefLangIDStx: TStaticText;
    Label35: TLabel;
    Label37: TLabel;
    UserDefLangIDStx: TStaticText;
    TabSheet5: TTabSheet;
    HelpRE: TRichEdit;
    EditFileInfo: TEdit;
    Label39: TLabel;
    FindFileBtn: TSpeedButton;
    FileInfoOpenDlg: TOpenDialog;
    GroupBox4: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Label40: TLabel;
    FilePathStx: TStaticText;
    Label41: TLabel;
    LongFileNameStx: TStaticText;
    Label42: TLabel;
    ShortFileNameStx: TStaticText;
    Label43: TLabel;
    DateTimeStx: TStaticText;
    Label46: TLabel;
    FileSizeByStx: TStaticText;
    GroupBox5: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    VersionStx: TStaticText;
    PlattformStx: TStaticText;
    UserNameStx: TStaticText;
    CompanyNameStx: TStaticText;
    SerialNoStx: TStaticText;
    Label44: TLabel;
    TotalVirtualStx: TStaticText;
    Label45: TLabel;
    AvailVirtualStx: TStaticText;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    GroupBox6: TGroupBox;
    Label47: TLabel;
    Label48: TLabel;
    BiosDateStx: TStaticText;
    BiosNameStx: TStaticText;
    Label49: TLabel;
    ProgramFilesDirStx: TStaticText;
    Label50: TLabel;
    CommonFilesDirStx: TStaticText;
    Label51: TLabel;
    MediaFilesDirStx: TStaticText;
    Label52: TLabel;
    TabSheet6: TTabSheet;
    FolderMemo: TMemo;

    {-o-}
    procedure LoadAniCursor;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RestoreRequest(var message: TMessage); message CM_RESTORE;
    procedure ShowInfo;
    procedure GetSpecialFolders;

    {-o-}
    procedure PageCtChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrivesRGClick(Sender: TObject);
    procedure ExitSBClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AboutSBClick(Sender: TObject);
    procedure ExecuteBtnClick(Sender: TObject);
    procedure FindFileBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  SaveCursor:   TCursor;
{- o }
{------------------------------------------------------------------------------}
{                                                                              }
{------------------------------------------------------------------------------}
implementation

uses GetInfo, AboutDlg, ExecFile;
{$R *.DFM}

{-------------------------------------------------------------------------------
  loading an ani cursor, Borland Info
}
procedure TMainForm.LoadAniCursor;
var AniCursorHandle: THandle;
begin
  AniCursorHandle :=
     LoadImage(0, PChar(ExtractFilePath(Application.ExeName)+'SysInv2.ani'),
     IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE or LR_LOADFROMFILE);

  if AniCursorHandle <> 0 then begin
     Screen.Cursors[1] := AniCursorHandle;
     Screen.Cursor := 1;
  end;
end; {.LoadAniCursor}


{-------------------------------------------------------------------------------
 OnlyOneInstance from an Rob de Veij job
 remember to add Windows & Messages to project main code
 -------------------------------------------------------------------------------
 Create params of the main window then assign a WinClassName that will be
 checked at the start of the project
}
procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WinClassName := 'SysInv2';
end; {- o }


{-------------------------------------------------------------------------------
 OnlyOneInstance
 Handle CM_RESTORE Message (Restore Application)
 -------------------------------------------------------------------------------
 If an instance is already running then the apps get focus or maximized
}
procedure TMainForm.RestoreRequest(var message: TMessage);
begin
  if IsIconic(Application.Handle) = TRUE then
     Application.Restore
  else Application.BringToFront;
end; {- o }


{-------------------------------------------------------------------------------
}
procedure TMainForm.ShowInfo;
var i: integer;
begin
  RPName := DrivesRG.Items[DrivesRG.ItemIndex]+'\';

  // get the informations
  Get_Info;
  GetSpecialFolders;
  with SystemInfoRec do begin
    VersionStx.Caption     := ' '+Version;
    PlattformStx.Caption   := ' '+Plattform ;
    ProcOemIdStx.Caption   := Format('%d',[ProcOemId])+' ';
    ProcNumStx.Caption     := Format('%d',[ProcNum])+' ';
    ProcTypeStx.Caption    := ' '+ProcType;
    ProcVersStx.Caption    := ' '+ProcVers;

    MemTotalStx.Caption        := FloatToStrF(MemTotal+0.0,ffNumber,12,0)+' ';
    MemAvailableStx.Caption    := FloatToStrF(MemAvailable+0.0,ffNumber,12,0)+' ';
    MemUsageStx.Caption        := Format('%d %%',[MemUsage])+' ';
    SwapFileSettingStx.Caption := FloatToStrF(SwapFileSetting+0.0,ffNumber,12,0)+' ';
    SwapFileSizeStx.Caption    := FloatToStrF(SwapFileSize+0.0,ffNumber,12,0)+' ';
    SwapFileUsageStx.Caption   := Format('%d %%',[SwapFileUsage])+' ';
    TotalVirtualStx.Caption    := FloatToStrF(TotalVirtual+0.0,ffNumber,12,0)+' ';
    AvailVirtualStx.Caption    := FloatToStrF(AvailVirtual+0.0,ffNumber,12,0)+' ';

    UserNameStx.Caption    := ' '+UserName;
    CompanyNameStx.Caption := ' '+CompanyName;
    SerialNoStx.Caption    := ' '+copy(SerialNo, 1, 5)+'-'+
                                  copy(SerialNo, 6, 3)+'-'+
                                  copy(SerialNo, 9, 7)+'-'+
                                  copy(SerialNo,16, 5);

    SystemDefLangIDStx.Caption := SystemDefLangID;
    UserDefLangIDStx.Caption := UserDefLangID;
    BiosDateStx.Caption := BiosDate;
    BiosNameStx.Caption := BiosName;
  end; // SystemInfoRec

  with VolumeInfoRec do begin
    RootPathNameStx.Caption       := ' '+RootPathName;
    VolumeNameStx.Caption         := ' '+VolumeName;
    VolumeSerialNumberStx.Caption := ' '+VolumeSerialNumber;
    FileSystemNameStx.Caption     := ' '+FileSystemName;
    CurrentDirectoryStx.Caption   := ' '+CurrentDirectory;
    SystemDirectoryStx.Caption    := ' '+SystemDirectory;
    WindowsDirectoryStx.Caption   := ' '+WindowsDirectory;
    ProgramFilesDirStx.Caption    := ' '+ProgramFilesDir;
    CommonFilesDirStx.Caption     := ' '+CommonFilesDir;
    MediaFilesDirStx.Caption      := ' '+MediaPath;

    DrivesStx.Caption             := ' '+Drives;
    DriveTypeStx.Caption          := ' '+DriveType;
    SectorsPerClusterStx.Caption  := FloatToStrF(SectorsPerCluster+0.0,ffNumber,12,0)+' ';
    BytesPerSectorStx.Caption     := FloatToStrF(BytesPerSector+0.0,ffNumber,12,0)+' ';
    FreeClustersStx.Caption       := FloatToStrF(FreeClusters+0.0,ffNumber,12,0)+' ';
    TotalClustersStx.Caption      := FloatToStrF(TotalClusters+0.0,ffNumber,12,0)+' ';
    ClusterSizeStx.Caption        := FloatToStrF(ClusterSize+0.0,ffNumber,12,0)+' ';
    FreeBytesStx.Caption          := FloatToStrF(FreeBytes+0.0,ffNumber,12,0)+' ';
    TotalBytesStx.Caption         := FloatToStrF(TotalBytes+0.0,ffNumber,12,0)+' ';
    AvailBytesStx.Caption         := FloatToStrF(AvailBytes+0.0,ffNumber,12,0)+' ';
  end; // VolumeInfoRec

  with GenericInfoRec do begin
    WinTempPathStx.Caption     := ' '+WinTempPath;
    NetComputerNameStx.Caption := ' '+NetComputerName;
    NetUserNameStx.Caption     := ' '+NetUserName;
  end; // GenericInfoRec

  StringGrid.Cells[0, 0] := 'Title';
  StringGrid.Cells[1, 0] := 'Value';
  for i := 1 to 25 do begin
      StringGrid.Cells[0, i] := LocaleRec[i].Title;
      StringGrid.Cells[1, i] := LocaleRec[i].Value;
  end;

  // setting the path of the test file for Exec function
  PathName.Text := VolumeInfoRec.WindowsDirectory+'\Notepad.exe';
end; {- o }

{-------------------------------------------------------------------------------
  Execute the MyExec to load & execute a program or batch file
}
procedure TMainForm.ExecuteBtnClick(Sender: TObject);
var Status: Dword;
    Msg:    string;
begin
  Status := MyExec(PathName.Text, SW_NORMAL, True);
  case Status of
    0000 : Msg := 'Ok';
    0001 : Msg := 'Incorrect function';
    0002 : Msg := 'The system cannot find the file specified';
    0003 : Msg := 'The system cannot find the path specified';
    0004 : Msg := 'The system cannot open the file';
    0005 : Msg := 'Access is denied';
    0011 : Msg := 'An attempt was made to load a program with an incorrect format';
  end;
  Application.MessageBox(Pchar(Format('MyEsec status = %d, %s',[Status, Msg])),
                         'Message',MB_OK);
end; {- o }

{-------------------------------------------------------------------------------
  Execute the File Open Dialog & if Ok show all possible infos
}
procedure TMainForm.FindFileBtnClick(Sender: TObject);
begin
  with FileInfoOpenDlg, FileInfoRec do begin
    InitialDir := ExtractFilePath(Application.ExeName);  // set initial path
    // set open options
    Options := [ofFileMustExist,    // check if file exist
                ofShareAware,       // ignores sharing errors
                ofShowHelp];        // show help icon
    Filter := 'All files (*.*)|*.*';                     // set filter
    FilterIndex := 1;                                    // select filter
    Title := 'Select a file to analize';                 // set a custom title
    if Execute then begin
       EditFileInfo.Text := FileName;
       Get_FileInfo(FileName);
       with FileInfoRec do begin
         FilePathStx.Caption      := FilePathName;
         LongFileNameStx.Caption  := LongFileName;
         ShortFileNameStx.Caption := ShortFileName;
         DateTimeStx.Caption  := FormatDateTime('dd/mm/yyyy -  hh:nn:ss',FileDateTime);
         FileSizeByStx.Caption := FormatFloat('###,###,###,###',FileSize);
         CheckBox1.Checked := FileAttributes and FILE_ATTRIBUTE_ARCHIVE <> 0;
         CheckBox2.Checked := FileAttributes and FILE_ATTRIBUTE_COMPRESSED <> 0;
         CheckBox3.Checked := FileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0;
         CheckBox4.Checked := FileAttributes and FILE_ATTRIBUTE_HIDDEN <> 0;
         CheckBox5.Checked := FileAttributes and FILE_ATTRIBUTE_NORMAL <> 0;
         CheckBox6.Checked := FileAttributes and FILE_ATTRIBUTE_OFFLINE <> 0;
         CheckBox7.Checked := FileAttributes and FILE_ATTRIBUTE_READONLY <> 0;
         CheckBox8.Checked := FileAttributes and FILE_ATTRIBUTE_SYSTEM <> 0;
         CheckBox9.Checked := FileAttributes and FILE_ATTRIBUTE_TEMPORARY <> 0;
       end;
    end; // if Execute
  end; // with
end;


{-------------------------------------------------------------------------------
  get special windows folders (95,98 and NT since Sp5)
}
procedure TMainForm.GetSpecialFolders;
const xTab = #13#10#32#32;
begin
  with FolderMemo.Lines do begin
    Clear;
    Append( 'SPECIAL WINDOWS FOLDERS (for the current user)' );
    Append( '==============================================' );
    Append( 'Controls:'+xTab+Get_ShellPath(CSIDL_CONTROLS) );
    Append( 'Desktop Dir:'+xTab+Get_ShellPath(CSIDL_DESKTOPDIRECTORY) );
    Append( 'Fonts:'+xTab+Get_ShellPath(CSIDL_FONTS) );
    Append( 'Drives:'+xTab+Get_ShellPath(CSIDL_DRIVES) );
    Append( 'Bucket:'+xTab+Get_ShellPath(CSIDL_BITBUCKET) );
    Append( 'Desktop:'+xTab+Get_ShellPath(CSIDL_DESKTOP) );
    Append( 'Net Hood:'+xTab+Get_ShellPath(CSIDL_NETHOOD) );
    Append( 'Network:'+xTab+Get_ShellPath(CSIDL_NETWORK) );
    Append( 'Personal:'+xTab+Get_ShellPath(CSIDL_PERSONAL) );
    Append( 'Printers:'+xTab+Get_ShellPath(CSIDL_PRINTERS) );
    Append( 'Programs:'+xTab+Get_ShellPath(CSIDL_PROGRAMS) );
    Append( 'Recent:'+xTab+Get_ShellPath(CSIDL_RECENT) );
    Append( 'Send To:'+xTab+Get_ShellPath(CSIDL_SENDTO) );
    Append( 'Start Menu:'+xTab+Get_ShellPath(CSIDL_STARTMENU) );
    Append( 'Start Up:'+xTab+Get_ShellPath(CSIDL_STARTUP) );
    Append( 'Templates:'+xTab+Get_ShellPath(CSIDL_TEMPLATES) );
  end;
end; {.Get_Directories}


{------------------------------------------------------------------------------}
{ RAD FUNCTIONS                                                                }
{------------------------------------------------------------------------------}



{-------------------------------------------------------------------------------
}
procedure TMainForm.PageCtChange(Sender: TObject);
begin
  //
  with StatBar.Panels[1] do
    case PageCt.ActivePage.PageIndex of
      0: Text := 'Volume information & System Path';
      1: Text := 'Windows & machine Information';
      2: Text := 'Generic & Localize Infos with Exec function test';
      3: Text := 'Get all infos about a selected file';
      4: Text := 'A simple small help in rtf format';
     end; // case
end; {- o }


{-------------------------------------------------------------------------------
}
procedure TMainForm.FormCreate(Sender: TObject);
var
  i: byte;
  Fn: string;
begin
  //  define the page and panels...
  PageCt.ActivePage := TabSheet1;
  // AboutFileVer defined in AboutDlg
  StatBar.Panels[0].Text := 'SysInv version '+AboutFileVer;
  StatBar.Panels[1].Text := 'Volume information & System Path';

  // only at startup
  Get_DriveNames;

  // fill the radio group
  for i := 0 to 25 do
      if DrivesArr[i] > 0 then
         DrivesRG.Items.Add(Chr(DrivesArr[i])+':');
  DrivesRG.ItemIndex := 1;

  // load the .rtf help file
  Fn := ExtractFilePath(Application.ExeName)+'SysInv2.rtf';
  if FileExists(Fn) then
     HelpRE.Lines.LoadFromFile(Fn);

  // assign the name for AppInfo in AboutDlg
  AboutFileName := Application.ExeName;

  // Fill all the tabs
  ShowInfo;
end; {- o }

{-------------------------------------------------------------------------------
}
procedure TMainForm.FormShow(Sender: TObject);
begin
  SaveCursor := Screen.Cursor;
  LoadAniCursor;
end; {- o }

{-------------------------------------------------------------------------------
}
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end; {- o }

{-------------------------------------------------------------------------------
}
procedure TMainForm.DrivesRGClick(Sender: TObject);
begin
  ShowInfo;
end; {- o }


{-------------------------------------------------------------------------------
}
procedure TMainForm.ExitSBClick(Sender: TObject);
begin
   Close;
end; {- o }


{-------------------------------------------------------------------------------
}
procedure TMainForm.AboutSBClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end; {- o }



end.

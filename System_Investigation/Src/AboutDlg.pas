{-------------------------------------------------------------------------------
  PROJECT   : SysInv 2
  FILE      : AboutDlg
  DATE      : 16.APR.2000
  VERSION   : 1.0c
  AUTHOR    : Riccardo "Rico" Pareschi
  COMPANY   : RicoSoft
  NOTE      : an about box ...
}
unit AboutDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    OKBtn: TButton;
    CompanyNameStx: TStaticText;
    FileDescriptionStx: TStaticText;
    FileVersionStx: TStaticText;
    LegalCopyrightStx: TStaticText;
    OriginalFilenameStx: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Memo1: TMemo;
    Bevel1: TBevel;
    //
    procedure ExtractVerInfo;
    //
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;
  AboutFileVer,
  AboutFileName: string;
  
implementation

{$R *.DFM}


{-------------------------------------------------------------------------------
  Here the core code of my Freeware TAppVerInfo component

  GetVervalue:
  The first four digits of the string 0410 04E4 is the key code for Italy
  To avoid problems with other languages I've tried to get the SystemLangID
}
procedure TAboutForm.ExtractVerInfo;
var Size  : DWord;
    VSize : DWord;
    VData : Pointer;
    VVers : Pointer;
    Len   : DWord;

    function GetVerValue(Value : string): string;
    var LangID: string;
    begin

      LangID := Format('%.4x',[GetSystemDefaultLangID])+'04E4';

      if VerQueryValue(VData,
                       pChar(Format('\StringFileInfo\%s\%s', [LangID, Value])),
                       VVers, Len) then
                                   if Len > 0 then Result := StrPAs(VVers);
    end; {- GetVerValue }
    
begin
  VSize := GetFileVersionInfoSize(Pchar(AboutFileName), Size);
  if VSize <> 0 then begin
     GetMem(VData, VSize);
     try
       if GetFileVersionInfo(Pchar(AboutFileName), 0, VSize, VData) then
          begin
            CompanyNameStx.Caption      := ' '+GetVerValue('CompanyName');
            FileDescriptionStx.Caption  := ' '+GetVerValue('FileDescription');
            FileVersionStx.Caption      := ' '+GetVerValue('FileVersion');
            LegalCopyrightStx.Caption   := ' '+GetVerValue('LegalCopyright');
            OriginalFilenameStx.Caption := ' '+GetVerValue('OriginalFilename');
            //
            AboutFileVer := GetVerValue('FileVersion');
          end;
     finally
       FreeMem(VData, VSize);
     end; // try...Finally
  end; // if Vsize
end; {- ExtractVerInfo }



{-------------------------------------------------------------------------------
}
procedure TAboutForm.FormCreate(Sender: TObject);
begin
  ExtractVerInfo;
end; {- FormCreate }

end.





























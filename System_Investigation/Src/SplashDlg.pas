{-------------------------------------------------------------------------------
  PROJECT   : SysInv 2
  FILE      : SplashDlg
  DATE      : 14.FEB.1999
  VERSION   : 1.0a
  AUTHOR    : Riccardo "Rico" Pareschi
  COMPANY   : RicoSoft
  NOTE      :
}
unit SplashDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TSplashForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Animate1: TAnimate;
    Timer1: TTimer;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SplashForm:    TSplashForm;

implementation

{$R *.DFM}

{-------------------------------------------------------------------------------
}
procedure TSplashForm.FormShow(Sender: TObject);
begin
  Animate1.Play(1, 23, 0);
end; {- o }

{-------------------------------------------------------------------------------
}
procedure TSplashForm.Timer1Timer(Sender: TObject);
begin
  Close;
end; {- o }

{-------------------------------------------------------------------------------
}
procedure TSplashForm.OKBtnClick(Sender: TObject);
begin
  Close;
end; {- o }


{-------------------------------------------------------------------------------
}
procedure TSplashForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Animate1.Stop;
  Free;
end; {- o }

end.



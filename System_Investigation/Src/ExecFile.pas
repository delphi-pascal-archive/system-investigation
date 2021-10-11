{-------------------------------------------------------------------------------
  PROJECT   : SysInv 2
  FILE      : ExecFile
  DATE      : 29.GEN.1999
  VERSION   : 1.0a
  AUTHOR    : Riccardo "Rico" Pareschi
  COMPANY   : RicoSoft
  NOTE      : this unit execute a program
}
unit ExecFile;

interface

uses
  Windows, SysUtils;

  function MyExec(Fn: string; Sw: word; WaitExec: boolean): Dword;


implementation


{-------------------------------------------------------------------------------
  I need to call a program or batch file so I've build this proc

  Fn = FileName
  Sw = SW_SHOWMINIMIZED or SW_NORMAL;
  WaitExec = wait for completation true/false
}
function MyExec(Fn: string; Sw: word; WaitExec: boolean): Dword;
var SI: TStartUpInfo;
    PI: TProcessInformation;
    St: longword;
    Ec: longint;
    Er: Dword;
begin
  // initialize to avoid warnings
  Er := 0;

  // setting the TStartUpInfo record
  with SI do begin
    cb := sizeof(SI);
    lpReserved := nil;
    lpDesktop := nil;
    lpTitle := nil;
    dwX := STARTF_USEPOSITION;
    dwY := STARTF_USEPOSITION;
    dwXSize := STARTF_USESIZE;
    dwYSize := STARTF_USESIZE;
    dwXCountChars := STARTF_USECOUNTCHARS;
    dwYCountChars := STARTF_USECOUNTCHARS;
    dwFillAttribute := FOREGROUND_BLUE;
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := Sw;
    cbReserved2 := 0;
    lpReserved2 := nil;
    hStdInput := 0;
    hStdOutput := 0;
    hStdError := 0;
  end;

  // create the process; putting the filename (and parameters if exist) in the
  // lpCommandLine instead of the lpApllicationName is more robust either on 16
  // or 32 bit environment
  if CreateProcess(nil, Pchar(Fn),
     nil, nil, False,
     NORMAL_PRIORITY_CLASS,
     nil, nil, SI, PI) then ;

  // with open the process, I get the handle
  //OpenProcess(PROCESS_ALL_ACCESS, False, PI.hProcess);

  // wait the completation flag
  if WaitExec then begin
     repeat
       GetExitCodeProcess(PI.hProcess, St);
     until (St<>STILL_ACTIVE);
     Er := GetLastError;
     Ec := 0;
     TerminateProcess(PI.hProcess, Ec);
  end else GetExitCodeProcess(PI.hProcess, St);

  result := Er;
end; {- o }


end.




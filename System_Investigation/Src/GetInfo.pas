{-------------------------------------------------------------------------------
  PROJECT   : SysInv 2
  FILE      : GetInfo
  DATE      : 10.GEN.2000
  VERSION   : 1.0a
  AUTHOR    : Riccardo "Rico" Pareschi
  COMPANY   : RicoSoft
  NOTE      : this unit extract all infos
}
unit GetInfo;

interface

uses
  Windows, Messages, SysUtils, Dialogs, Registry, ShlObj;


type
   // this is the main systeminfo record
   SystemInfoRecord = record
     // Os
     Version:         string;
     Plattform:       string;
     PlattformId:     Dword;
     // Processor
     ProcOemId:       word;
     ProcNum:         word;
     ProcType:        string;
     ProcVers:        string;
     // Memory
     MemTotal:        Dword;
     MemAvailable:    Dword;
     MemUsage:        Dword;
     TotalVirtual:    Dword;
     AvailVirtual:    Dword;
     SwapFileSetting: Dword;
     SwapFileSize:    Dword;
     SwapFileUsage:   Dword;
     // Registration
     UserName:        string;
     CompanyName:     string;
     SerialNo:        string;
     // Language ID's
     SystemDefLangID: string;
     UserDefLangID:   string;
     // Bios info
     BiosDate:        string;
     BiosName:        string;
   end;

   // disk related record
   VolumeInfoRecord = record
     RootPathName:           string;
     VolumeName:             string;
     VolumeSerialNumber:     string;
     MaxComponentLength:     DWORD;
     FileSystemFlags:        DWORD;
     FileSystemName:         string;
     DriveType:              string;
     // Folders
     CurrentDirectory:       string;
     SystemDirectory:        string;
     WindowsDirectory:       string;
     ProgramFilesDir:        string;
     CommonFilesDir:         string;
     MediaPath:              string;
     // Drives on system
     Drives:                 string;
     // Drive infos
     SectorsPerCluster:      DWord;
     BytesPerSector:         DWord;
     FreeClusters:           DWord;
     TotalClusters:          DWord;
     ClusterSize:            DWord;
     AvailBytes:             LONGLONG;
     FreeBytes:              LONGLONG;
     TotalBytes:             LONGLONG;
   end;

   //
   GenericInfoRecord = record
     WinTempPath:          string;
     NetComputerName:      string;
     NetUserName:          string;
   end;

   //
   LocaleRecord = record
     Title:           string;
     Value:           string;
   end;

   //
   FileInfoRecord = record
     FilePathName:      string;
     FileAttributes:    Dword;
     FileDateTime:      TDateTime;
     FileSize:          Dword;
     LongFileName:      string;
     ShortFileName:     string;
   end;

var
   SystemInfoRec:  SystemInfoRecord;
   VolumeInfoRec:  VolumeInfoRecord;
   GenericInfoRec: GenericInfoRecord;
   FileInfoRec:    FileInfoRecord;
   LocaleRec:      array[1..25] of LocaleRecord;

   CurRegKey:      PChar;
   TempPChar:      PChar;
   TempDword:      Dword;

   RPName:         string;
   DrivesArr:      array[0..25] of integer;
   PlattId:        Dword;           		// used in other routines

   procedure Get_DriveNames;
   procedure Get_Info;
   procedure Get_FileInfo(Fname: string);
   function  Get_ShellPath(nFolder: Integer): String;

{-------------------------------------------------------------------------------}
implementation


{-------------------------------------------------------------------------------
}
function Plat(Pl: DWORD): string;
begin
  case Pl of
    VER_PLATFORM_WIN32s:        result := 'Win32s on Windows 3.1x';
    VER_PLATFORM_WIN32_WINDOWS: result := 'Windows 95/98';
    VER_PLATFORM_WIN32_NT:      result := 'Windows NT';
    else                        result := 'Unknow';
  end;
end; {.Plat}


{-------------------------------------------------------------------------------
}
procedure GetAllSystemInfo;
var OS: TOSVersionInfo;
    SI: TSystemInfo;
    MS: TMemoryStatus;
begin
  with SystemInfoRec do begin

    // get win plattform & version
    with OS do begin
      dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
      if GetVersionEx(OS) then begin
         Version := Format('%d.%d (%d.%s)',[dwMajorVersion, dwMinorVersion,
                                           (dwBuildNumber and $FFFF), szCSDVersion]);
         Plattform   := Plat(dwPlatformId);
         PlattformId := dwPlatformId;
      end;
    end; // with OS

    // get processor type & info
    with SI do begin
      GetSystemInfo(SI);
      ProcOemId := dwOemId;
      ProcNum   := dwNumberOfProcessors;
      case dwProcessorType of
         386  : ProcType := ' 386';
         486  : ProcType := ' 486';
         586  : ProcType := ' Pentium';
         4000 : ProcType := ' MIPS Risc 4000';
         21064: ProcType := ' ALPHA';
      end;
      ProcVers := Format('Level %d  Rev. %d.%d',
                  [wProcessorLevel, hi(wProcessorRevision), lo(wProcessorRevision)]);
    end; // with SI

    // Get memory status & dim
    with MS do begin
      dwLength := sizeof(TMemoryStatus);
      GlobalMemoryStatus(MS);

      MemTotal        := dwTotalPhys;
      MemAvailable    := dwAvailPhys;
      MemUsage        := 100-trunc(dwAvailPhys/dwTotalPhys*100);
      SwapFileSetting := dwTotalPageFile;
      SwapFileSize    := dwAvailPageFile;
      SwapFileUsage   := 100-trunc(dwAvailPageFile/dwTotalPageFile*100);

      TotalVirtual    := dwTotalVirtual;
      AvailVirtual    := dwAvailVirtual;
   end; // with MS

    // get registration info
    case PlattId of
      VER_PLATFORM_WIN32_WINDOWS :
            CurRegKey := '\SOFTWARE\Microsoft\Windows\CurrentVersion';
      VER_PLATFORM_WIN32_NT      :
            CurRegKey := '\SOFTWARE\Microsoft\Windows NT\CurrentVersion';
      else  CurRegKey := nil;
    end;
    with TRegistry.Create do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey(CurRegKey, False) then begin
         UserName := ReadString('RegisteredOwner');
         CompanyName := ReadString('RegisteredOrganization');
         SerialNo :=  ReadString('ProductID');
         CloseKey;
      end; // if
      if OpenKey('HARDWARE\DESCRIPTION\System', False) then begin
         BiosDate := ReadString('SystemBiosDate');
         BiosName := ReadString('Identifier');
         CloseKey;
      end;
    finally
      Free;
    end; // try
    SystemDefLangID := Format('$%.4x',[GetSystemDefaultLangID]);
    UserDefLangID   := Format('$%.4x',[GetUserDefaultLangID]);
  end; // SystemInfoRec
end; {.GetAllSystemInfo}


{-------------------------------------------------------------------------------
}
procedure GetVolumeInfo;
var
  VolumeNameBuffer: PChar;
  VolumeNameSize: DWORD;
  FileSystemNameBuffer: PChar;
  FileSystemNameSize: DWORD;
  VolSerial: DWORD;
  BufLen : DWORD;

begin
  BufLen := MAX_PATH + 1;
  GetMem(VolumeNameBuffer, BufLen);
  GetMem(FileSystemNameBuffer, BufLen);
  try
    with VolumeInfoRec do begin
      VolumeNameSize := BufLen;
      FileSystemNameSize := BufLen;

      // Get volume info with no automatic error
      SetErrorMode(SEM_NOOPENFILEERRORBOX);
      if GetVolumeInformation(PChar(RPName),
                              VolumeNameBuffer,
                              VolumeNameSize,
                              @VolSerial,
                              MaxComponentLength,
                              FileSystemFlags,
                              FileSystemNameBuffer,
                              FileSystemNameSize) then begin
         //
         RootPathName       := RPName;
         VolumeName         := StrPas(VolumeNameBuffer);
         VolumeSerialNumber := IntToHex(HiWord(VolSerial), 4) + '-' +
                               IntToHex(LoWord(VolSerial), 4);
         FileSystemName     := StrPas(FileSystemNameBuffer);

         // Get Drive type 
         case GetDriveType(PChar(RPName)) of
           0:               DriveType := 'Undetermined';
           1:	              DriveType := 'The root dir does not exist';
           DRIVE_REMOVABLE: DriveType := 'Removable';
           DRIVE_FIXED:	    DriveType := 'Fixed Disk';
           DRIVE_REMOTE:	  DriveType := 'Remote (network) drive';
           DRIVE_CDROM:	    DriveType := 'CD-ROM drive';
           DRIVE_RAMDISK:	  DriveType := 'RAM disk';
         end; // case
      end else // if Get...
         ShowMessage('Attention disk unvailable or damaged!');
    end;
  finally
    FreeMem(VolumeNameBuffer);
    FreeMem(FileSystemNameBuffer);
  end; // try
end; {.GetVolumeInfo}


{-------------------------------------------------------------------------------
}
procedure GetDirectories;
var
   BufLen : DWORD;
   Buffer : PChar;
begin
  with VolumeInfoRec do begin
    BufLen := MAX_PATH+1;
    GetMem(Buffer, BufLen);
    try
      if GetSystemDirectory(Buffer, BufLen) > 0 then
         SystemDirectory := StrPas(Buffer);
      if GetWindowsDirectory(Buffer, BufLen) > 0 then
         WindowsDirectory := StrPas(Buffer);
      if GetCurrentDirectory(BufLen, Buffer) > 0 then
         VolumeInfoRec.CurrentDirectory := StrPas(Buffer);
    finally
      FreeMem(Buffer);
    end;

    with TRegistry.Create do
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion', False) then begin
         ProgramFilesDir := ReadString('ProgramFilesDir');
         CommonFilesDir  := ReadString('CommonFilesDir');
         MediaPath       := ReadString('MediaPath');
         CloseKey;
      end;
    finally
      Free;
    end; // try

  end; // with
end; {.GetDirectories}



{-------------------------------------------------------------------------------
  this proc must be execute once at startup
}
procedure Get_DriveNames;
var
   D1   : set of 0..25;
   D2   : integer;
   AA   : byte;
begin
   DWORD( D1 ) := GetLogicalDrives;
   AA := Ord('A');
   with VolumeInfoRec do begin
     Drives := '';
     for D2 := 0 to 25 do
        if D2 in D1 then begin
           // used to select a drive in MainDlg
           DrivesArr[D2] := D2 + AA;
           Drives := Drives + Chr(D2 + AA) + ': ';
        end;
   end;
end; {.Get_DriveNames}


{-------------------------------------------------------------------------------
}
procedure GetDriveSize;
begin
  with VolumeInfoRec do begin

    if GetDiskFreeSpace(PChar(RPName), SectorsPerCluster,
                        BytesPerSector, FreeClusters,
                        TotalClusters ) then begin
       ClusterSize := SectorsPerCluster * BytesPerSector;

       // this function works on Win95 Osr2 or later, Win98, NT 4.0 all version
       if NOT GetDiskFreeSpaceEx(PChar(RPName), AvailBytes, TotalBytes, @FreeBytes) then begin
          FreeBytes  := ClusterSize * FreeClusters;
          TotalBytes := ClusterSize * TotalClusters;
       end;
    end; // if
  end; {- with }
end; {.GetDriveSize}

{-------------------------------------------------------------------------------
  becouse I've decided to put this data in a grid I've load it on an array
}
procedure GetGenericInfo;
var
  BufLen: DWORD;
  Buffer: PChar;
begin
  with GenericInfoRec do begin
    BufLen := 255;
    GetMem(Buffer, BufLen);

    try
      // Get the User name
      if GetUserName(Buffer, BufLen) then
         NetUserName := String(Buffer)
      else NetUserName := 'none';

      // Get the Computer name
      BufLen := 255;
      if GetComputerName(Buffer, BufLen) then
         NetComputerName := String(Buffer)
      else NetComputerName := 'none';

      // Get Temporary environment
      BufLen := 255;
      ExpandEnvironmentStrings('%TEMP%', Buffer, BufLen);
      WinTempPath := String(Buffer);
    finally
      FreeMem(Buffer);
    end;

    // Get Locales
    GetMem(Buffer, BufLen);
    try
      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SLANGUAGE, Buffer, BufLen);
         LocaleRec[01].Value := Buffer;  LocaleRec[01].Title := 'Full localize language';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SENGLANGUAGE, Buffer, BufLen);
         LocaleRec[02].Value := Buffer;  LocaleRec[02].Title := 'Full language english name (Iso 639)';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVLANGNAME, Buffer, BufLen);
         LocaleRec[03].Value := Buffer;  LocaleRec[03].Title := 'Abbreviate language name (Iso 639)';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_ICOUNTRY, Buffer, BufLen);
         LocaleRec[04].Value := Buffer;  LocaleRec[04].Title := 'Country code (IBM code)';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SCOUNTRY, Buffer, BufLen);
         LocaleRec[05].Value := Buffer;  LocaleRec[05].Title := 'Full country code';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME, Buffer, BufLen);
         LocaleRec[06].Value := Buffer;  LocaleRec[06].Title := 'Abbreviate country code (Iso 3166)';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SLIST, Buffer, BufLen);
         LocaleRec[07].Value := Buffer;  LocaleRec[07].Title := 'List separator';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_IMEASURE, Buffer, BufLen);
         LocaleRec[08].Value := Buffer;  LocaleRec[08].Title := 'System of measurement';
         case LocaleRec[08].Value[1] of
           '0' : LocaleRec[08].Value := 'Decimal';
           '1' : LocaleRec[08].Value := 'Usa';
         end;

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SDECIMAL, Buffer, BufLen);
         LocaleRec[09].Value := Buffer;  LocaleRec[09].Title := 'Decimal separator';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_IDIGITS, Buffer, BufLen);
         LocaleRec[10].Value := Buffer;  LocaleRec[10].Title := 'Number of decimal digits';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SCURRENCY, Buffer, BufLen);
         LocaleRec[11].Value := Buffer;  LocaleRec[11].Title := 'Local monetary symbol)';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SINTLSYMBOL, Buffer, BufLen);
         LocaleRec[12].Value := Buffer;  LocaleRec[12].Title := 'International monetary symbol (Iso 4217)';
         
      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SMONDECIMALSEP, Buffer, BufLen);
         LocaleRec[14].Value := Buffer;  LocaleRec[13].Title := 'Currency decimal separator';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SMONTHOUSANDSEP, Buffer, BufLen);
         LocaleRec[14].Value := Buffer;  LocaleRec[14].Title := 'Currency thousand separator';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_ICURRDIGITS, Buffer, BufLen);
         LocaleRec[15].Value := Buffer;  LocaleRec[15].Title := 'Currency decimal digits';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_ICURRENCY, Buffer, BufLen);
         LocaleRec[16].Value := Buffer;  LocaleRec[16].Title := 'Positive currency mode';
         case LocaleRec[16].Value[1] of
           '0': LocaleRec[16].Value := 'Prefix, no separation';
           '1': LocaleRec[16].Value := 'Suffix, no separation';
           '2': LocaleRec[16].Value := 'Prefix, 1-char. separation';
           '3': LocaleRec[16].Value := 'Suffix, 1-char. separation';
         end;

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_INEGCURR, Buffer, BufLen);
         LocaleRec[17].Value := Buffer;  LocaleRec[17].Title := 'Negative currency mode';
         case LocaleRec[17].Value[1] of
           '0': LocaleRec[17].Value := '$1.1)';
           '1': LocaleRec[17].Value := '-$1.1';
           '2': LocaleRec[17].Value := '$-1.1';
           '3': LocaleRec[17].Value := '$1.1-';
           '4': LocaleRec[17].Value := '(1.1$)';
           '5': LocaleRec[17].Value := '-1.1$';
           '6': LocaleRec[17].Value := '1.1-$';
           '7': LocaleRec[17].Value := '1.1$-';
           '8': LocaleRec[17].Value := '-1.1 $ (space before $)';
           '9': LocaleRec[17].Value := '-$ 1.1 (space after $)';
         end;

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SDATE, Buffer, BufLen);
         LocaleRec[18].Value := Buffer;  LocaleRec[18].Title := 'Date separator';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_STIME, Buffer, BufLen);
         LocaleRec[19].Value := Buffer;  LocaleRec[19].Title := 'Time separator';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_STIMEFORMAT, Buffer, BufLen);
         LocaleRec[20].Value := Buffer;  LocaleRec[20].Title := 'Time format';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SSHORTDATE, Buffer, BufLen);
         LocaleRec[21].Value := Buffer;  LocaleRec[21].Title := 'Short date format';

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_IDATE, Buffer, BufLen);
         LocaleRec[22].Value := Buffer;  LocaleRec[22].Title := 'Short date order';
         case LocaleRec[22].Value[1] of
           '0': LocaleRec[22].Value := 'Month-Day-Year';
           '1': LocaleRec[22].Value := 'Day-Month-Year';
           '2': LocaleRec[22].Value := 'Year-Month-Day';
         end;

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_ILDATE, Buffer, BufLen);
         LocaleRec[23].Value := Buffer;  LocaleRec[23].Title := 'Long date order';
         case LocaleRec[23].Value[1] of
           '0': LocaleRec[23].Value := 'Month-Day-Year';
           '1': LocaleRec[23].Value := 'Day-Month-Year';
           '2': LocaleRec[23].Value := 'Year-Month-Day';
         end;

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_ITIME, Buffer, BufLen);
         LocaleRec[24].Value := Buffer;  LocaleRec[24].Title := 'Time format specifier';
         case LocaleRec[24].Value[1] of
           '0': LocaleRec[24].Value := 'AM / PM 12-hour format';
           '1': LocaleRec[24].Value := '24-hour format';
         end;

      GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_ICENTURY, Buffer, BufLen);
         LocaleRec[25].Value := Buffer;  LocaleRec[25].Title := 'Year format';
         case LocaleRec[25].Value[1] of
           '0': LocaleRec[25].Value := 'Abbreviated 2-digit century';
           '1': LocaleRec[25].Value := 'Full 4-digit century';
         end;

    finally
      FreeMem(Buffer);
    end;

  end; // GenericInfoRec
end; {GetGenericInfo}

{-------------------------------------------------------------------------------
  retrieve file info via FindData structure & funct
}
procedure Get_FileInfo(Fname: string);
var
  lpFindFileData: TWIN32FindData;
  Age: integer;
  BufLen : DWORD;
  Buffer : PChar;
begin
  // get file handle & return file info in TWIN32FindData
  FindFirstFile(Pchar(Fname), lpFindFileData);

  with lpFindFileData, FileInforec do begin
    FilePathName    := Fname;
    FileAttributes  := dwFileAttributes;
    LongFileName    := StrPas(cFileName);
    ShortFileName   := StrPas(cAlternateFileName);
    FileSize        := (nFileSizeHigh * MAXDWORD) + nFileSizeLow;
    Age := FileAge(LongFileName);
    if (Age > -1) then FileDateTime := FileDateToDateTime(Age);

// if you need to calculate the size; you can use Round or Trunc too
// Label1.Caption := FormatFloat('###,###,###,##0.0',FileSize);
// Label2.Caption := FormatFloat('###,###,##0.00',FileSize / 1024);
// Label3.Caption := FormatFloat('###,##0.000',(xBytes / 1024) / 1024);
// Label4.Caption := FormatFloat('##0.0000',((xBytes / 1024) / 1024) / 1024);

   BufLen := SizeOf(VS_VERSION_INFO)+1;
   GetMem(Buffer, BufLen);
   try
     if not(GetFileVersionInfo(Pchar(Fname),0,BufLen,Buffer)) then
        {Can't get VerInfo ressource}
     begin
     
     end;
    finally
     FreeMem(Buffer);
   end;


  end;
end; {.GetFileInfo}

{-------------------------------------------------------------------------------
  need ShlObj unit, get special windows folders, thanks to Helmut Schottmueller
}
function Get_ShellPath(nFolder: Integer): String;
var
  ppidl    : PItemIDList;
  szPath  : array[0..MAX_PATH] of Char;
begin
  SHGetSpecialFolderLocation(0, nFolder, ppidl);
  SHGetPathFromIDList(ppidl, szPath);
  Result := szPath;
end; {.getShellPath}

{-------------------------------------------------------------------------------
  retrieve alla infos
}
procedure Get_Info;
begin
  GetAllSystemInfo;
  PlattId := SystemInfoRec.PlattformId;
  GetDirectories;
  GetVolumeInfo;
  GetDriveSize;
  GetGenericInfo;
end; {.Get_Info}

end.



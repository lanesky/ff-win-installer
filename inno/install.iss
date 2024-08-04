#define MyAppName "FaceFusion"
#define MyAppName2 "FaceFusion(Skip Download)"
#define MyAppVersion "2.6.1"
#define MyAppPublisher "lanesky"
#define MyAppRunBatName "run.bat"
#define MyAppRunBatName2 "run-skip-download.bat"
#define MyAppInstallBatName "install.bat"
#define MyIcoName "ff.ico"
#define MyIcoPathInApp ".ico\ff.ico"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
WizardStyle=modern
AppPublisher={#MyAppPublisher}
DefaultDirName=C:\FaceFusion
DefaultGroupName={#MyAppName}
UninstallDisplayIcon={app}\{#MyIcoPathInApp}
OutputDir=.
ShowLanguageDialog=yes
OutputBaseFilename=FaceFusion_{#MyAppVersion}_Setup
SetupIconFile={#MyIcoName}
Compression=lzma
SolidCompression=yes

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"; InfoBeforeFile: "readme.txt"; 
Name: "zhs"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"; InfoBeforeFile: "readme-简体中文.txt";

[Files]
Source: "{#MyIcoName}"; DestDir: "{app}\.ico"; Flags: ignoreversion
Source: "readme.txt"; DestDir: "{app}"; Languages: en; Flags: isreadme
Source: "readme-简体中文.txt"; DestDir: "{app}"; Languages: zhs; Flags: isreadme

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppRunBatName}"; Parameters: ""; IconFilename: "{app}\{#MyIcoPathInApp}"
Name: "{group}\{#MyAppName2}"; Filename: "{app}\{#MyAppRunBatName2}"; Parameters: ""; IconFilename: "{app}\{#MyIcoPathInApp}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; IconFilename: "{app}\{#MyIcoPathInApp}"

[CustomMessages]
en.cloneRepo=Git: Clone the FaceFusion repository
zhs.cloneRepo=Git: 克隆FaceFusion仓库
en.createCondaEnv=Conda: Create FaceFusion environment
zhs.createCondaEnv=Conda: 创建FaceFusion环境
en.installFFmpeg=FFmpeg: Install FFmpeg 
zhs.installFFmpeg=FFmpeg: 安装FFmpeg
en.installAccelerator=Accelerator Dependencies: Install accelerator Dependencies
zhs.installAccelerator=显卡加速依赖包: 安装显卡加速依赖包
en.installApplication=Application Dependencies: Install FaceFusion Dependencies
zhs.installApplication=应用程序依赖包: 安装FaceFusion依赖包
en.ChooseAccelerator=Choose your preferred accelerator
zhs.ChooseAccelerator=选择您的首选加速器
en.ChooseGraphicsCard=Select an accelerator based on your graphics card
zhs.ChooseGraphicsCard=根据您的显卡选择加速器
en.SelectAppropriateAccelerator=Please select the appropriate accelerator:
zhs.SelectAppropriateAccelerator=请选择适当的加速器:
en.ChoosePlatformTools=Select platform tools to install
zhs.ChoosePlatformTools=选择要安装的平台工具
en.DownloadAndInstallGit=Downloading and installing Git
zhs.DownloadAndInstallGit=下载并安装Git（如果您的PC上没有安装）
en.DownloadAndInstallConda=Downloading and installing Miniconda
zhs.DownloadAndInstallConda=下载并安装Miniconda（如果您的PC上没有安装）
en.Default=Default
zhs.Default=默认
en.Note=Note
zhs.Note=注意
en.NextStepWillDownloadAndInstall=The next step will download and install Git and Conda to %1
zhs.NextStepWillDownloadAndInstall=下一步将下载并安装Git和Conda至 %1
en.FaceFusionNeedsGitAndCondaToRun=FaceFusion requires Git and Conda to run.
zhs.FaceFusionNeedsGitAndCondaToRun=FaceFusion需要Git和Conda来运行。
en.ConfirmIfYouWantToDownloadAndInstall=Do you want to download and install the following tools?
zhs.ConfirmIfYouWantToDownloadAndInstall=是否确认下载并安装以下工具？
en.InstallPlatformTools=Installing platform tools
zhs.InstallPlatformTools=安装平台工具
en.Starting=Starting...
zhs.Starting=开始...
en.StartingInstallation=Starting the installation of %1 to %2...
zhs.StartingInstallation=开始将 %1 安装至 %2...
en.InstallationCompletedSuccessfully=%1 installation completed successfully.
zhs.InstallationCompletedSuccessfully=%1 安装成功。
en.InstallationFailed=The installation of %1 failed.
zhs.InstallationFailed=%1 安装失败。
en.UninstallingExisting=Uninstalling existing %1...
zhs.UninstallingExisting=正在卸载现有的 %1...
en.ExistingUninstalled=Existing %1 uninstalled.
zhs.ExistingUninstalled=已卸载现有的 %1。
en.GitCloneFailed=Git clone failed with error code: %1
zhs.GitCloneFailed=Git克隆失败，错误代码: %1
en.CondaInitFailed=Conda initialization failed with error code: %1
zhs.CondaInitFailed=Conda初始化失败，错误代码: %1
en.CondaCreateEnvFailed=Conda environment creation failed with error code: %1
zhs.CondaCreateEnvFailed=Conda创建环境失败，错误代码: %1
en.RunScriptFailed=Script execution failed with error code: %1
zhs.RunScriptFailed=脚本执行失败，错误代码: %1


[Tasks]
Name: cloneRepo; Description: "{cm:cloneRepo}"; 
Name: createCondaEnv; Description: "{cm:createCondaEnv}";  
Name: installFFmpeg; Description: "{cm:installFFmpeg}"; 
Name: installAccelerator; Description: "{cm:installAccelerator}";   
Name: installApplication; Description: "{cm:installApplication}";


[Code]
var
  PlatformOptionPage: TInputOptionWizardPage; // Page for selecting platform tools to install
  AcceleratorPage: TInputOptionWizardPage; // Page for selecting the preferred accelerator
  DownloadPage: TDownloadWizardPage; // Page for downloading required tools
  PlatformInstallInstructionPage: TOutputMsgWizardPage; // Instruction page for platform tools installation
  PlatformInstallPage: TOutputMarqueeProgressWizardPage; // Progress page for platform tools installation
  
// Callback function for download progress 
function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
  if Progress = ProgressMax then
    Log(Format('Successfully downloaded file to {tmp}: %s', [FileName]));
  Result := True;
end;

// Initialize the wizard pages
procedure InitializeWizard;
begin
  // Create the accelerator selection page
  AcceleratorPage := CreateInputOptionPage(wpSelectDir,
    ExpandConstant('{cm:ChooseAccelerator}'), ExpandConstant('{cm:ChooseGraphicsCard}'),
    ExpandConstant('{cm:SelectAppropriateAccelerator}'), False, False);
  AcceleratorPage.AddEx(ExpandConstant('{cm:Default}'), 0, True);
  AcceleratorPage.AddEx('CUDA (NVIDIA)', 0, True);
  AcceleratorPage.AddEx('DirectML (AMD, Intel, NVIDIA)', 0, True);
  AcceleratorPage.AddEx('OpenVINO (Intel)', 0, True);
  AcceleratorPage.SelectedValueIndex := 0;
  
  // Create the platform tools selection page
  PlatformOptionPage := CreateInputOptionPage(AcceleratorPage.ID,
    ExpandConstant('{cm:ChoosePlatformTools}'), ExpandConstant('{cm:FaceFusionNeedsGitAndCondaToRun}'),
    ExpandConstant('{cm:ConfirmIfYouWantToDownloadAndInstall}'), False, False);
  PlatformOptionPage.Add(ExpandConstant('{cm:DownloadAndInstallGit}'));
  PlatformOptionPage.Add(ExpandConstant('{cm:DownloadAndInstallConda}'));
  PlatformOptionPage.Values[0] := True;
  PlatformOptionPage.Values[1] := True;

   // Create the instruction page for platform tools installation
  PlatformInstallInstructionPage := CreateOutputMsgPage(PlatformOptionPage.ID,
  ExpandConstant('{cm:Note}'), '',
  ExpandConstant('{cm:NextStepWillDownloadAndInstall, {localappdata}}'));
  
  // Create the download page for required tools
  DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
  
  // Create the progress page for platform tools installation
  PlatformInstallPage := CreateOutputMarqueeProgressPage(ExpandConstant('{cm:InstallPlatFormTools}'), ExpandConstant('{cm:Starting}'));
end;

// Determine if a page should be skipped
function ShouldSkipPage(PageID: Integer): Boolean;
var
  NeedInstallGit, NeedInstallConda: Boolean;
begin
  NeedInstallGit := PlatformOptionPage.Values[0] ;
  NeedInstallConda := PlatformOptionPage.Values[1];
  Result := (PageID = PlatformInstallInstructionPage.ID) and
            not (NeedInstallGit or NeedInstallConda);
end;

// Handle the Next button click event
function NextButtonClick(CurPageID: Integer): Boolean;
var
  ResultCode: Integer;
  NeedInstallGit, NeedInstallConda: Boolean;
begin  
  Result := True;

  NeedInstallGit := PlatformOptionPage.Values[0] ;
  NeedInstallConda := PlatformOptionPage.Values[1];
  
  if CurPageID = PlatformInstallInstructionPage.ID then begin
    if not NeedInstallGit and not NeedInstallConda then
     Result := False;
     Exit;

    DownloadPage.Clear;
    if NeedInstallGit then
      DownloadPage.Add('https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe', 'Git.exe', '');
    if NeedInstallConda then
      DownloadPage.Add('https://repo.anaconda.com/miniconda/Miniconda3-py310_24.3.0-0-Windows-x86_64.exe', 'Miniconda3.exe', '');
    DownloadPage.Show;
    
    try
      try
        DownloadPage.Download; 
      except
        if DownloadPage.AbortedByUser then
          Log('Aborted by user.')
        else
          SuppressibleMsgBox(AddPeriod(GetExceptionMessage), mbCriticalError, MB_OK, IDOK);
          Result := False;
          Exit;
      end;
    finally
      DownloadPage.Hide;
    end;
    
    PlatformInstallPage.Show;

    try
      if NeedInstallGit then
      begin
        PlatformInstallPage.Description := ExpandConstant('{cm:StartingInstallation, Git, {localappdata}}');    
        if not Exec(ExpandConstant('{tmp}\Git.exe'), ExpandConstant('/CURRENTUSER /VERYSILENT /DIR={localappdata}\Programs\Git'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode) then
        begin
          Log('Git installation failed with error code: ' + IntToStr(ResultCode));
          MsgBox(ExpandConstant('{cm:InstallationFailed, Git}'), mbError, MB_OK);
          Result := False;
          Exit;
        end;
        PlatformInstallPage.Description := ExpandConstant('{cm:InstallationCompletedSuccessfully, Git}');
      end;
      
      if NeedInstallConda then
      begin
        // Uninstall Conda (if exists)
        if DirExists(ExpandConstant('{localappdata}\Programs\Miniconda3')) then
        begin
          PlatformInstallPage.Description := ExpandConstant('{cm:UninstallingExisting, Conda}');
          Exec(ExpandConstant('{localappdata}\Programs\Miniconda3\Uninstall-Miniconda3.exe'), ExpandConstant('/S _?={localappdata}\Programs\Miniconda3'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
          DelTree(ExpandConstant('{localappdata}\Programs\Miniconda3'), True, True, True);
          PlatformInstallPage.Description := ExpandConstant('{cm:ExistingUninstalled, Conda}');
        end;
            
        PlatformInstallPage.Description := ExpandConstant('{cm:StartingInstallation, Conda, {localappdata}}');    
        if not Exec(ExpandConstant('{tmp}\Miniconda3.exe'), ExpandConstant('/InstallationType=JustMe /AddToPath=1 /S /D={localappdata}\Programs\Miniconda3'), '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode) then
        begin
          Log('Conda installation failed with error code: ' + IntToStr(ResultCode));
          MsgBox(ExpandConstant('{cm:InstallationFailed, Conda}'), mbError, MB_OK);
          Result := False;
          Exit;
        end;
        PlatformInstallPage.Description := ExpandConstant('{cm:InstallationCompletedSuccessfully, Conda}');      
      end;      
    finally
      PlatformInstallPage.Hide;
    end;
  end;
end;

// Create batch files for installation and running the application
procedure CreateInstallBatFiles;
var
  UseCuda, UseDirectMl, UseOpenVino: Boolean;
  Contents: String;
begin
  UseCuda := AcceleratorPage.SelectedValueIndex = 1;
  UseDirectMl := AcceleratorPage.SelectedValueIndex = 2;
  UseOpenVino := AcceleratorPage.SelectedValueIndex = 3;

  // Create install-ffmpeg.bat
  SaveStringToFile(ExpandConstant('{app}\install-ffmpeg.bat'), 
    '@echo off && conda activate facefusion && conda install conda-forge::ffmpeg=7.0.1 --yes ', False);

  // Create install-accelerator.bat
  if UseCuda then
    Contents := '@echo off && conda activate facefusion && conda install cudatoolkit=11.8 cudnn=8.9.2.26 conda-forge::gputil=1.4.0 conda-forge::zlib-wapi --yes '
  else if UseOpenVino then
    Contents := '@echo off && conda activate facefusion && conda install conda-forge::openvino=2023.1.0 --yes '
  else
    Contents := '';
  
  SaveStringToFile(ExpandConstant('{app}\install-accelerator.bat'), Contents, False);

  // Create install-application.bat
  if UseCuda then
    Contents := '@echo off && conda activate facefusion && cd src && python install.py --onnxruntime cuda-11.8 '
  else if UseDirectMl then
    Contents := '@echo off && conda activate facefusion && cd src && python install.py --onnxruntime directml '
  else if UseOpenVino then
    Contents := '@echo off && conda activate facefusion && cd src && python install.py --onnxruntime openvino '
  else
    Contents := '@echo off && conda activate facefusion && cd src && python install.py --onnxruntime default ';
  
  SaveStringToFile(ExpandConstant('{app}\install-application.bat'), Contents, False);

  // Create run.bat
  SaveStringToFile(ExpandConstant('{app}\{#MyAppRunBatName}'), 
    '@echo off && conda activate facefusion && cd src && python run.py', False);  
  
  // Create run.bat - skip-download
  SaveStringToFile(ExpandConstant('{app}\{#MyAppRunBatName2}'), 
    '@echo off && conda activate facefusion && cd src && python run.py --skip-download', False);
end;

// Clone the FaceFusion repository using Git
procedure CloneRepo;
var 
  ResultCode: Integer;
begin
  Log('Cloning repo');
  CreateDir(ExpandConstant('{app}\src'));
  if not Exec(ExpandConstant('{localappdata}\Programs\Git\bin\git.exe'), ExpandConstant(' clone https://github.com/facefusion/facefusion --branch 2.6.1 {app}\src') , '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode) then
  begin
    Log('Git clone failed with error code: ' + IntToStr(ResultCode));
    MsgBox(ExpandConstant('{cm:GitCloneFailed, ResultCode}'), mbError, MB_OK);
    Exit;
  end;
end;

// Initialize Conda environment for FaceFusion
procedure SetupCondaEnvironment;
var 
  ResultCode: Integer;
begin
  Log('Conda init');
  if not Exec(ExpandConstant('{localappdata}\Programs\Miniconda3\Scripts\conda.exe'), ExpandConstant('init --all') , '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode) then
  begin
    Log('Conda init failed with error code: ' + IntToStr(ResultCode));
    MsgBox(ExpandConstant('{cm:CondaInitFailed, ResultCode}'), mbError, MB_OK);
    Exit;
  end;

  Log('Conda create environment');
  if not Exec(ExpandConstant('{localappdata}\Programs\Miniconda3\Scripts\conda.exe'), ExpandConstant('create --name facefusion python=3.10 --yes') , '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode) then
  begin
    Log('Conda create environment failed with error code: ' + IntToStr(ResultCode));
    MsgBox(ExpandConstant('{cm:CondaCreateEnvFailed, ResultCode}'), mbError, MB_OK);
    Exit;
  end;
end;

// Run a specified batch file
procedure runBat(const BatName: String);
var
  ResultCode: Integer;
begin
  if not Exec(ExpandConstant('{app}\'+BatName), '', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode) then
  begin
    Log('Run script failed with error code: ' + IntToStr(ResultCode));
    MsgBox(ExpandConstant('{cm:RunScriptFailed, ResultCode}'), mbError, MB_OK);
    Exit;
  end;
end;

// Handle changes to the setup steps
procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    CreateInstallBatFiles;

    // git clone the repo
    if WizardIsTaskSelected('cloneRepo') then
      CloneRepo;

    // setup the environment
    if WizardIsTaskSelected('createCondaEnv') then
      SetupCondaEnvironment;

    // install ffmpeg
    if WizardIsTaskSelected('installFFmpeg') then
      runBat('install-ffmpeg.bat');

    // install accelerator
    if WizardIsTaskSelected('installAccelerator') then
      runBat('install-accelerator.bat');

    // install application
    if WizardIsTaskSelected('installApplication') then
      runBat('install-application.bat');
  end;
end;
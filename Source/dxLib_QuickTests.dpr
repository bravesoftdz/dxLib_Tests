program dxLib_QuickTests;
{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  GUITestRunner in '..\Dependencies\dxDUnit\Source\GUITestRunner.pas' {GUITestRunner},
  TestFramework in '..\Dependencies\dxDUnit\Source\TestFramework.pas',
  TextTestRunner in '..\Dependencies\dxDUnit\Source\TextTestRunner.pas',
  dxLib_ClassPropertyArray in '..\Dependencies\dxLib\Source\dxLib_ClassPropertyArray.pas',
  dxLib_JSONFormatter in '..\Dependencies\dxLib\Source\dxLib_JSONFormatter.pas',
  dxLib_JSONUtils in '..\Dependencies\dxLib\Source\dxLib_JSONUtils.pas',
  dxLib_RTTI in '..\Dependencies\dxLib\Source\dxLib_RTTI.pas',
  dxLib_Streams in '..\Dependencies\dxLib\Source\dxLib_Streams.pas',
  dxLib_Strings in '..\Dependencies\dxLib\Source\dxLib_Strings.pas',
  dxLib_System in '..\Dependencies\dxLib\Source\dxLib_System.pas',
  dxLib_TestRunner in '..\Dependencies\dxLib\Source\dxLib_TestRunner.pas',
  dxLib_Test_ClassPropertyArray in 'dxLib_Test_ClassPropertyArray.pas',
  dxLib_Test_RTTI_SetDefaults in 'dxLib_Test_RTTI_SetDefaults.pas',
  dxLib_Test_JSONFormatter in 'dxLib_Test_JSONFormatter.pas',
  dxLib_Test_JSON_Utils in 'dxLib_Test_JSON_Utils.pas';

{$R *.RES}

begin
  dxLib_TestRunner.RunRegisteredTests;
end.


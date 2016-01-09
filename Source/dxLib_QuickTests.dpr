program dxLib_QuickTests;
{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

{$I '..\Dependencies\dxLib\Source\dxLib.inc'}

uses
  GUITestRunner in '..\Dependencies\dxDUnit\Source\GUITestRunner.pas' {GUITestRunner},
  TestFramework in '..\Dependencies\dxDUnit\Source\TestFramework.pas',
  TextTestRunner in '..\Dependencies\dxDUnit\Source\TextTestRunner.pas',
  dxLib_ClassPropertyArray in '..\Dependencies\dxLib\Source\dxLib_ClassPropertyArray.pas',
  dxLib_JSONFormatter in '..\Dependencies\dxLib\Source\dxLib_JSONFormatter.pas',
  dxLib_JSONObjects in '..\Dependencies\dxLib\Source\dxLib_JSONObjects.pas',
  dxLib_JSONParser in '..\Dependencies\dxLib\Source\dxLib_JSONParser.pas',
  dxLib_JSONUtils in '..\Dependencies\dxLib\Source\dxLib_JSONUtils.pas',
  dxLib_RTTI in '..\Dependencies\dxLib\Source\dxLib_RTTI.pas',
  dxLib_Streams in '..\Dependencies\dxLib\Source\dxLib_Streams.pas',
  dxLib_Strings in '..\Dependencies\dxLib\Source\dxLib_Strings.pas',
  dxLib_System in '..\Dependencies\dxLib\Source\dxLib_System.pas',
  dxLib_TestRunner in '..\Dependencies\dxLib\Source\dxLib_TestRunner.pas',
  dxLib_Test_ClassPropertyArray in 'dxLib_Test_ClassPropertyArray.pas',
  dxLib_Test_RTTI_SetDefaults in 'dxLib_Test_RTTI_SetDefaults.pas',
  dxLib_Test_JSONFormatter in 'dxLib_Test_JSONFormatter.pas',
  dxLib_Test_JSON_Utils in 'dxLib_Test_JSON_Utils.pas',
  dxLib_Test_JSONObjectArray in 'dxLib_Test_JSONObjectArray.pas',
  dxLib_Test_JSONObjectAssign in 'dxLib_Test_JSONObjectAssign.pas',
  {$IFDEF DX_String_Is_UTF16}
  //Source code unit saved as UTF8, will not open properly in older Delphi versions
  dxLib_Test_JSONObjectUnicode in 'dxLib_Test_JSONObjectUnicode.pas',
  {$ENDIF}
  dxLib_Test_JSONObjectSimple in 'dxLib_Test_JSONObjectSimple.pas';

{$R *.RES}

begin
  dxLib_TestRunner.RunRegisteredTests;
end.


(*
Copyright (c) 2016 Darian Miller
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so, provided that the above copyright notice(s) and this permission notice
appear in all copies of the Software and that both the above copyright notice(s) and this permission notice appear in supporting documentation.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS INCLUDED IN THIS NOTICE BE
LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Except as contained in this notice, the name of a copyright holder shall not be used in advertising or otherwise to promote the sale, use or other
dealings in this Software without prior written authorization of the copyright holder.

As of January 2016, latest version available online at:
  https://github.com/darianmiller/dxLib_Tests
*)
unit dxLib_Test_RTTI_SetDefaults;

interface
{$I '..\Dependencies\dxLib\Source\dxLib.inc'}

uses
  TestFramework,
  {$IFDEF DX_UnitScopeNames}
  System.Classes,
  System.TypInfo,
  {$ELSE}
  Classes,
  TypInfo,
  {$ENDIF}
  dxLib_RTTI;


type
  TExampleEnum = (myOne, myTwo, myThree, myFour, myFive, mySix, mySeven);
  TExampleSet = set of TExampleEnum;


const
  DELPHI_DEFAULT_CHAR = #0;
  DELPHI_DEFAULT_WIDECHAR = #0;
  DELPHI_DEFAULT_INTEGER = 0;
  DELPHI_DEFAULT_INT64 = 0;
  DELPHI_DEFAULT_BYTE = 0;
  DELPHI_DEFAULT_ExampleEnum = myOne;
  DELPHI_DEFAULT_ExampleSet = [];


  CUSTOM_DEFAULT_CHAR = 'A';
  CUSTOM_DEFAULT_WIDECHAR = 'B';
  CUSTOM_DEFAULT_INTEGER = MaxInt;
  //note: Int64 property defaults fail to compile with constant values > MaxInt
  CUSTOM_DEFAULT_INT64 = -1;
  CUSTOM_DEFAULT_BYTE = 1;
  CUSTOM_DEFAULT_ExampleEnum = mySix;
  CUSTOM_DEFAULT_ExampleSet = [myTwo, mySeven];

type

  TExampleClass = Class(TPersistent)
  private
    fCharNoDefault:Char;
    fCharWithDefault:Char;

    fWideCharNoDefault:WideChar;
    fWideCharWithDefault:WideChar;

    fIntegerNoDefault:Integer;
    fIntegerWithDefault:Integer;

    fInt64NoDefault:Int64;
    fInt64WithDefault:Int64;

    fByteNoDefault:Byte;
    fByteWithDefault:Byte;

    fEnumNoDefault:TExampleEnum;
    fEnumWithDefault:TExampleEnum;

    fSetNoDefault:TExampleSet;
    fSetWithDefault:TExampleSet;
  published
    property CharNoDefault:Char Read fCharNoDefault Write fCharNoDefault;
    property CharWithDefault:Char Read fCharWithDefault Write fCharWithDefault default CUSTOM_DEFAULT_CHAR;

    property WideCharNoDefault:WideChar Read fWideCharNoDefault Write fWideCharNoDefault;
    property WideCharWithDefault:WideChar Read fWideCharWithDefault Write fWideCharWithDefault default CUSTOM_DEFAULT_WIDECHAR;

    property IntegerNoDefault:Integer Read fIntegerNoDefault Write fIntegerNoDefault;
    property IntegerWithDefault:Integer Read fIntegerWithDefault Write fIntegerWithDefault default CUSTOM_DEFAULT_INTEGER;

    property Int64NoDefault:Int64 Read fInt64NoDefault Write fInt64NoDefault;
    property Int64WithDefault:Int64 Read fInt64WithDefault Write fInt64WithDefault default CUSTOM_DEFAULT_INT64;

    property ByteNoDefault:Byte Read fByteNoDefault Write fByteNoDefault;
    property ByteWithDefault:Byte Read fByteWithDefault Write fByteWithDefault default CUSTOM_DEFAULT_BYTE;

    property EnumNoDefault:TExampleEnum Read fEnumNoDefault Write fEnumNoDefault;
    property EnumWithDefault:TExampleEnum Read fEnumWithDefault Write fEnumWithDefault default CUSTOM_DEFAULT_ExampleEnum;

    property SetNoDefault:TExampleSet Read fSetNoDefault Write fSetNoDefault;
    property SetWithDefault:TExampleSet Read fSetWithDefault Write fSetWithDefault default CUSTOM_DEFAULT_ExampleSet;
  end;


  TestSetPublishedPropertyDefaultsViaRTTI = class(TTestCase)
  private
    fExampleClass:TExampleClass;
  protected
    procedure SetUp(); override;
    procedure TearDown(); override;
  published
    procedure TestDefaultStorageSpecifiers();

    procedure TestCharNoDefault();
    procedure TestCharWithDefault();

    procedure TestWideCharNoDefault();
    procedure TestWideCharWithDefault();

    procedure TestIntegerNoDefault();
    procedure TestIntegerWithDefault();

    procedure TestInt64NoDefault();
    procedure TestInt64WithDefault();

    procedure TestByteNoDefault();
    procedure TestByteWithDefault();

    procedure TestEnumNoDefault();
    procedure TestEnumWithDefault();

    procedure TestSetNoDefault();
    procedure TestSetWithDefault();
  end;

implementation


//'Default' property values not supported when creating an instance directly
//DOC: The optional stored, default, and nodefault directives are called storage specifiers.
//They have no effect on program behavior, but control whether or not to save the values of published properties IN FORM FILES
procedure TestSetPublishedPropertyDefaultsViaRTTI.TestDefaultStorageSpecifiers();
var
  vExampleClass:TExampleClass;
begin
  //Validate normal Delphi usage (without call to SetPublishedPropertyDefaultsViaRTTI)
  vExampleClass := TExampleClass.Create();
  try
    //defaults should be unused
    CheckTrue(vExampleClass.CharNoDefault = vExampleClass.CharWithDefault);
    CheckTrue(vExampleClass.WideCharNoDefault = vExampleClass.WideCharWithDefault);
    CheckTrue(vExampleClass.IntegerNoDefault = vExampleClass.IntegerWithDefault);
    CheckTrue(vExampleClass.Int64NoDefault = vExampleClass.Int64WithDefault);
    CheckTrue(vExampleClass.ByteNoDefault = vExampleClass.ByteWithDefault);
    CheckTrue(vExampleClass.EnumNoDefault = vExampleClass.EnumWithDefault);
    CheckTrue(vExampleClass.SetNoDefault = vExampleClass.SetWithDefault);
  finally
    vExampleClass.Free();
  end;
end;


procedure TestSetPublishedPropertyDefaultsViaRTTI.Setup();
begin
  inherited;
  fExampleClass := TExampleClass.Create();
  SetPublishedPropertyDefaultsViaRTTI(fExampleClass);
end;

procedure TestSetPublishedPropertyDefaultsViaRTTI.Teardown();
begin
  fExampleClass.Free();
  inherited;
end;


procedure TestSetPublishedPropertyDefaultsViaRTTI.TestCharNoDefault();
begin
  Check(fExampleClass.CharNoDefault = DELPHI_DEFAULT_CHAR);  //validate expected Delphi behavior
end;
procedure TestSetPublishedPropertyDefaultsViaRTTI.TestCharWithDefault();
begin
  Check(fExampleClass.CharWithDefault = CUSTOM_DEFAULT_CHAR);  //validate new behavior: 'default' value set by SetPublishedPropertyDefaultsViaRTTI
end;


procedure TestSetPublishedPropertyDefaultsViaRTTI.TestWideCharNoDefault();
begin
  Check(fExampleClass.WideCharNoDefault = DELPHI_DEFAULT_WIDECHAR);  //validate expected Delphi behavior
end;
procedure TestSetPublishedPropertyDefaultsViaRTTI.TestWideCharWithDefault();
begin
  Check(fExampleClass.WideCharWithDefault = CUSTOM_DEFAULT_WIDECHAR);  //validate new behavior: 'default' value set by SetPublishedPropertyDefaultsViaRTTI
end;


procedure TestSetPublishedPropertyDefaultsViaRTTI.TestIntegerNoDefault();
begin
  Check(fExampleClass.IntegerNoDefault = DELPHI_DEFAULT_INTEGER);  //validate expected Delphi behavior
end;

procedure TestSetPublishedPropertyDefaultsViaRTTI.TestIntegerWithDefault();
begin
  Check(fExampleClass.IntegerWithDefault = CUSTOM_DEFAULT_INTEGER);  //validate new behavior: 'default' value set by SetPublishedPropertyDefaultsViaRTTI
end;


procedure TestSetPublishedPropertyDefaultsViaRTTI.TestInt64NoDefault();
begin
  Check(fExampleClass.Int64NoDefault = DELPHI_DEFAULT_INT64);  //validate expected Delphi behavior
end;

procedure TestSetPublishedPropertyDefaultsViaRTTI.TestInt64WithDefault();
begin
  Check(fExampleClass.Int64WithDefault = CUSTOM_DEFAULT_INT64);  //validate new behavior: 'default' value set by SetPublishedPropertyDefaultsViaRTTI
end;


procedure TestSetPublishedPropertyDefaultsViaRTTI.TestByteNoDefault();
begin
  Check(fExampleClass.ByteNoDefault = DELPHI_DEFAULT_BYTE);  //validate expected Delphi behavior
end;
procedure TestSetPublishedPropertyDefaultsViaRTTI.TestByteWithDefault();
begin
  Check(fExampleClass.ByteWithDefault = CUSTOM_DEFAULT_BYTE);  //validate new behavior: 'default' value set by SetPublishedPropertyDefaultsViaRTTI
end;


procedure TestSetPublishedPropertyDefaultsViaRTTI.TestEnumNoDefault;
begin
  Check(fExampleClass.EnumNoDefault = DELPHI_DEFAULT_ExampleEnum);  //validate expected Delphi behavior
end;

procedure TestSetPublishedPropertyDefaultsViaRTTI.TestEnumWithDefault;
begin
  Check(fExampleClass.EnumWithDefault = CUSTOM_DEFAULT_ExampleEnum);  //validate new behavior: 'default' value set by SetPublishedPropertyDefaultsViaRTTI
end;


procedure TestSetPublishedPropertyDefaultsViaRTTI.TestSetNoDefault;
begin
  Check(fExampleClass.SetNoDefault = DELPHI_DEFAULT_ExampleSet);  //validate expected Delphi behavior
end;

procedure TestSetPublishedPropertyDefaultsViaRTTI.TestSetWithDefault;
begin
  Check(fExampleClass.SetWithDefault = CUSTOM_DEFAULT_ExampleSet);  //validate new behavior: 'default' value set by SetPublishedPropertyDefaultsViaRTTI
end;



initialization
  RegisterTest(TestSetPublishedPropertyDefaultsViaRTTI.Suite);

end.


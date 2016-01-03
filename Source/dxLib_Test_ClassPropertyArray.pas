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
unit dxLib_Test_ClassPropertyArray;

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
  dxLib_ClassPropertyArray;

type

  TExampleClassWithPublishedProperties = Class(TPersistent)
  private
    fExamplePublic:String;
    fExamplePublished:String;
    fAnotherPublished:Integer;
  public
    property ExamplePublic:String read fExamplePublic write fExamplePublic;
  published
    property ExamplePublished:String read fExamplePublished write fExamplePublished;
    property AnotherPublished:Integer read fAnotherPublished write fAnotherPublished;
  end;


  TestTdxClassPropertyArray = class(TTestCase)
  private
    fExampleClass:TExampleClassWithPublishedProperties;
  protected
    procedure SetUp(); override;
    procedure TearDown(); override;
  published
    procedure TestGetPublishedPropertyByName;
    procedure TestGetPublicPropertyFail;
    procedure TestPropertyFilter;
  end;


const
  EXPECTED_PUBLISHED_PROPERTY_COUNT = 2;
  EXPECTED_PUBLISHED_INTEGER_PROPERTY_COUNT = 1;


implementation


procedure TestTdxClassPropertyArray.SetUp();
begin
  inherited;
  fExampleClass := TExampleClassWithPublishedProperties.Create();
end;

procedure TestTdxClassPropertyArray.TearDown();
begin
  fExampleClass.Free();
  inherited;
end;


//Array should contain published properties
procedure TestTdxClassPropertyArray.TestGetPublishedPropertyByName;
const
  TEST_PROPERTY_NAME = 'AnotherPublished';
var
  vArray:TdxClassPropertyArray;
  vPReturnValue:PPropInfo;
begin
  vArray := TdxClassPropertyArray.Create(fExampleClass);
  try
    vPReturnValue := vArray.GetPropertyByName(TEST_PROPERTY_NAME);
    if Assigned(vPReturnValue) then
    begin
      Check(vPReturnValue.Name = TEST_PROPERTY_NAME);
    end
    else
    begin
      Fail('Property Not Found');
    end;

    Check(vArray.Count = EXPECTED_PUBLISHED_PROPERTY_COUNT);
  finally
    vArray.Free();
  end;
end;


//Array does not contain public properties
procedure TestTdxClassPropertyArray.TestGetPublicPropertyFail;
const
  TEST_PROPERTY_NAME = 'ExamplePublic';
var
  vArray:TdxClassPropertyArray;
  vPReturnValue:PPropInfo;
begin
  vArray := TdxClassPropertyArray.Create(fExampleClass);
  try
    vPReturnValue := vArray.GetPropertyByName(TEST_PROPERTY_NAME);
    CheckFalse(Assigned(vPReturnValue));
  finally
    vArray.Free();
  end;
end;


procedure TestTdxClassPropertyArray.TestPropertyFilter;
var
  vArray:TdxClassPropertyArray;
begin
  vArray := TdxClassPropertyArray.Create(fExampleClass, [tkInteger]);
  try
    Check(vArray.Count = EXPECTED_PUBLISHED_INTEGER_PROPERTY_COUNT);
  finally
    vArray.Free();
  end;
end;


initialization
  RegisterTest(TestTdxClassPropertyArray.Suite);

end.


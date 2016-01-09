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
unit dxLib_Test_JSONObjectAssign;

interface
{$I '..\Dependencies\dxLib\Source\dxLib.inc'}

uses
  TestFramework,
  dxLib_JSONObjects;

type
  TMyEnum = (myEnum1, myEnum2);
  TMyEnumSet = set of TMyEnum;

  TExample1 = class(TdxJSONObject)
  private
    fFirstProp:String;
  published
    property FirstProp:String read fFirstProp write fFirstProp;
  end;

  //version 2 of TExampleProp1...should be compatible to always update Server to new version ahead of Client.
  //but dataloss occurs if updating Client ahead of Server
  TExample2 = class(TdxJSONObject)
  private
    fFirstProp:String;
    fNewProp:String;
  published
    property FirstProp:String read fFirstProp write fFirstProp;
    property NewProp:String read fNewProp write fNewProp;
  end;


  TExampleString = class(TdxJSONObject)
  private
    fAString:String;
    fAInteger:String;
    fAInt64:String;
    fABoolean:String;
    fADouble:String;
    fACurrency:String;
    fAMyEnum:String;
    fAMyEmumSet:String;
    fAVariant:String;
    fAClass:String;
  published
    property AString:String read fAString write fAString;
    property AInteger:String read fAInteger write fAInteger;
    property AInt64:String read fAInt64 write fAInt64;
    property ABoolean:String read fABoolean write fABoolean;
    property ADouble:String read fADouble write fADouble;
    property ACurrency:String read fACurrency write fACurrency;
    property AMyEnum:String read fAMyEnum write fAMyEnum;
    property AMyEmumSet:String read fAMyEmumSet write fAMyEmumSet;
    property AVariant:String read fAVariant write fAVariant;
    property AClass:String read fAClass write fAClass;
  end;

  TExampleTypes = class(TdxJSONObject)
  private
    fAString:String;
    fAInteger:Integer;
    fAInt64:Int64;
    fABoolean:Boolean;
    fADouble:Double;
    fACurrency:Currency;
    fAMyEnum:TMyEnum;
    fAMyEmumSet:TMyEnumSet;
    fAVariant:Variant;
    fAClass:TExample1;
  public
    constructor Create(); override;
    destructor Destroy(); override;

    procedure PopulateProperties();
  published
    property AString:String read fAString write fAString;
    property AInteger:Integer read fAInteger write fAInteger;
    property AInt64:Int64 read fAInt64 write fAInt64;
    property ABoolean:Boolean read fABoolean write fABoolean;
    property ADouble:Double read fADouble write fADouble;
    property ACurrency:Currency read fACurrency write fACurrency;
    property AMyEnum:TMyEnum read fAMyEnum write fAMyEnum;
    property AMyEmumSet:TMyEnumSet read fAMyEmumSet write fAMyEmumSet;
    property AVariant:Variant read fAVariant write fAVariant;
    property AClass:TExample1 read fAClass write fAClass;
  end;

  TestTdxJSONObjectAssign = class(TTestCase)
  published
    procedure TestSameClassSingleProperty();
    procedure TestBackwardsCompatibility();
    procedure TestDataLossForwardCompatibility();
    procedure TestTypeClash();
    procedure TestNullAssign();
  end;


implementation
uses
  dxLib_JSONUtils,
  dxLib_Strings;


procedure TestTdxJSONObjectAssign.TestSameClassSingleProperty();
var
  vFirst, vSecond:TExample1;
begin
  vFirst := TExample1.Create;
  vSecond := TExample1.Create;
  try
    vFirst.FirstProp := '1';
    vSecond.Assign(vFirst);
    CheckEqualsString(vFirst.AsJSON, vSecond.AsJSON);
  finally
    vFirst.Free();
    vSecond.Free();
  end;
end;


procedure TestTdxJSONObjectAssign.TestBackwardsCompatibility();
var
  vClient:TExample1;
  vServer:TExample2;
begin
  vClient := TExample1.Create;
  vServer := TExample2.Create;
  try
    vClient.FirstProp := '1';
    vServer.FirstProp := 'n/a';
    vServer.NewProp := 'ignored';
    //common action - client sends data to server
    vServer.AsJSON := vClient.AsJSON;

    CheckEqualsString(vServer.FirstProp, vClient.FirstProp);
    CheckEqualsString(vServer.NewProp, ''); //when assigned, current values are reset so this should be 0
  finally
    vClient.Free();
    vServer.Free();
  end;
end;


procedure TestTdxJSONObjectAssign.TestDataLossForwardCompatibility();
var
  vClientV2:TExample2;
  vServerV1:TExample1;
begin
  vClientV2 := TExample2.Create;
  vServerV1 := TExample1.Create;
  try
    vClientV2.FirstProp := '1';
    vClientV2.NewProp := 'data';
    vServerV1.FirstProp := '2';

    //common action - client sends data to server
    vServerV1.AsJSON := vClientV2.AsJSON;

    //existing properties are updated
    CheckEqualsString(vServerV1.FirstProp, vClientV2.FirstProp);
    //but note data loss, vClientV2.NewProp has no where to go
  finally
    vClientV2.Free();
    vServerV1.Free();
  end;
end;


procedure TestTdxJSONObjectAssign.TestTypeClash();
var
  aStrings:TExampleString;
  aExpected:TExampleString;
  aTypes:TExampleTypes;
  v1,v2:String;
begin
  aStrings := TExampleString.Create;
  aTypes := TExampleTypes.Create;
  aExpected := TExampleString.Create;
  try
    aTypes.PopulateProperties();

    //classes have same property names, but all strings being assigned..typically not a problem in Delphi client/server coding
    //This is more of a problem if receiving JSON from non-delphi sources and your
    //data type is incorrectly defined within your Delphi class as data-loss may occur
    aStrings.AsJSON := aTypes.AsJSON;

    //Not all types are converted...more effort needed to better support mis-matched object property types..
    aExpected.AString := aTypes.AString;
    aExpected.AInteger := '1';
    aExpected.AInt64 := '2';
    aExpected.AMyEnum := 'myEnum2';
    aExpected.AMyEmumSet := 'myEnum1,myEnum2';
    aExpected.AVariant := 'testing';

    v1 := aStrings.AsJSON;
    v2 := aExpected.AsJSON;

    CheckEqualsString(v2, v1);

  finally
    aExpected.Free();
    aStrings.Free();
    aTypes.Free();
  end;

end;

procedure TestTdxJSONObjectAssign.TestNullAssign();
var
  aTypes:TExampleTypes;
begin
  aTypes := TExampleTypes.Create();
  try
    aTypes.PopulateProperties;
    aTypes.AsJSON := '{"AString":null,'
                     + '"AInteger":null,'
                     + '"AInt64":null,'
                     + '"ABoolean":null,'
                     + '"ADouble":null,'
                     + '"ACurrency":null,'
                     + '"AMyEnum":null,'
                     + '"AMyEmumSet":null,'
                     + '"AVariant":null,'
                     + '"AClass":null}';

    //If delphi doesn't support this option, it defaults to a sorted property list
    {$IFDEF DX_Supports_Sorted_GetPropList}
    //In later versions of Delphi the list of properties will be left-alone...remains as-sorted by the developer
    CheckEqualsString('{"AString":"null","AInteger":0,"AInt64":0,"ABoolean":false,"ADouble":0,"ACurrency":0.00,"AMyEnum":"myEnum1","AMyEmumSet":"","AVariant":"null","AClass":{"FirstProp":""}}',
                      aTypes.AsJSON);
    {$ELSE}
    //older versions of Delphi auto-sort the property list alphabetically
    CheckEqualsString('{"ABoolean":false,"AClass":{"FirstProp":""},"ACurrency":0.00,"ADouble":0,"AInt64":0,"AInteger":0,"AMyEmumSet":"","AMyEnum":"myEnum1","AString":"null","AVariant":"null"}',
                      aTypes.AsJSON);
    {$ENDIF}
  finally
    aTypes.Free();
  end;

end;


constructor TExampleTypes.Create;
begin
  inherited;
  fAClass := TExample1.Create();
end;

destructor TExampleTypes.Destroy;
begin
  fAClass.Free();
  inherited;
end;

procedure TExampleTypes.PopulateProperties();
begin
  AString := 'a';
  AInteger := 1;
  AInt64 := 2;
  ABoolean := True;
  ADouble := 2.2;
  ACurrency := 233.00;
  AMyEnum := myEnum2;
  AMyEmumSet := [myEnum1,myEnum2];
  AVariant := 'testing';
  AClass.FirstProp := 'one';
end;

initialization
  RegisterTest(TestTdxJSONObjectAssign.Suite);

end.

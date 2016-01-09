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
unit dxLib_Test_JSONObjectArray;

interface
{$I '..\Dependencies\dxLib\Source\dxLib.inc'}

uses
  TestFramework,
  dxLib_JSONObjects;

type

  TestTdxJSONObjectArray = class(TTestCase)
  published
    procedure TestStringArray();
    procedure TestBoolArray();
    procedure TestCurrencyArray();
    procedure TestFloatArray();
    procedure TestIntegerArray();
    procedure TestInt64Array();
  end;


implementation
uses
  dxLib_JSONUtils;

procedure TestTdxJSONObjectArray.TestStringArray();
var
  vArray:TdxJSONArrayOfString;
  vJSON:String;
begin
  vArray := TdxJSONArrayOfString.Create();
  try
    CheckEquals(0, vArray.Count, 'Count');
    CheckEqualsString(JSON_EMPTY_ARRAY, vArray.AsJson);

    vArray.AsJson := JSON_EMPTY_ARRAY;
    CheckEquals(0, vArray.Count, 'Count');

    vArray.AsJson := '["1"]';
    CheckEquals(1, vArray.Count, 'Count');

    vArray.AsJson := '["1","2"]';
    CheckEquals(2, vArray.Count, 'Count');

    vArray.Clear();
    CheckEquals(0, vArray.Count, 'Count');

    vArray.Add('1');
    vArray.Add('2');
    vArray.Add('3');
    vArray.Add('4');
    vArray.Delete(3);
    CheckEquals(3, vArray.Count, 'Count');
    CheckEqualsString('1', vArray.Items[0]);
    CheckEqualsString('2', vArray.Items[1]);
    CheckEqualsString('3', vArray.Items[2]);
    vJSON := vArray.AsJson;
    CheckEqualsString('["1","2","3"]', vJSON);

    vArray.AsJSON := '["1","2","3"]';
    CheckEquals(3, vArray.Count, 'Count');
    CheckEqualsString(vJSON, vArray.AsJSON);

    //somewhat liberal conversion: Boolean/Integer auto-converted to string
    vArray.AsJson := '["1",2,3,true,false,null]';
    CheckEquals(6, vArray.Count, 'Count');
    CheckEqualsString('1', vArray.Items[0]);
    CheckEqualsString('2', vArray.Items[1]);
    CheckEqualsString('3', vArray.Items[2]);
    CheckEqualsString('true', vArray.Items[3]);
    CheckEqualsString('false', vArray.Items[4]);
    CheckEqualsString('', vArray.Items[5]);    //null string

  finally
    vArray.Free();
  end;
end;


procedure TestTdxJSONObjectArray.TestBoolArray();
var
  vArray:TdxJSONArrayOfBoolean;
  vJSON:String;
begin
  vArray := TdxJSONArrayOfBoolean.Create();
  try
    CheckEquals(0, vArray.Count, 'Count');
    CheckEqualsString(JSON_EMPTY_ARRAY, vArray.AsJson);

    vArray.AsJson := JSON_EMPTY_ARRAY;
    CheckEquals(0, vArray.Count, 'Count');

    vArray.AsJson := '[false]';
    CheckEquals(1, vArray.Count, 'Count');

    vArray.AsJson := '[false,false]';
    CheckEquals(2, vArray.Count, 'Count');

    vArray.Clear();
    CheckEquals(0, vArray.Count, 'Count');

    vArray.Add(false);
    vArray.Add(true);
    vArray.Add(false);
    vArray.Add(true);
    vArray.Delete(3);
    CheckEquals(3, vArray.Count, 'Count');

    CheckEquals(false, vArray.Items[0]);
    CheckEquals(true, vArray.Items[1]);
    CheckEquals(false, vArray.Items[2]);
    vJSON := vArray.AsJson;
    CheckEqualsString('[false,true,false]', vJSON);

    vArray.AsJSON := '[false,true,false]';
    CheckEquals(3, vArray.Count, 'Count');
    CheckEqualsString(vArray.AsJSON, vJSON);

    //somewhat liberal conversion: null + strings (true|false) auto-converted to boolean but not other types like integer/float
    //If desiring integer, change TdxJSONArrayOfBoolean.GetItem
    vArray.AsJson := '[1, "TRUE", 1.1, null]';
    CheckEquals(4, vArray.Count, 'Count');
    CheckEquals(false, vArray.Items[0]);
    CheckEquals(true, vArray.Items[1]);
    CheckEquals(false, vArray.Items[2]);
    CheckEquals(false, vArray.Items[3]);
  finally
    vArray.Free();
  end;
end;


procedure TestTdxJSONObjectArray.TestCurrencyArray();
var
  vArray:TdxJSONArrayOfCurrency;
  vJSON:String;
begin
  vArray := TdxJSONArrayOfCurrency.Create();
  try
    CheckEquals(0, vArray.Count, 'Count');
    CheckEqualsString(JSON_EMPTY_ARRAY, vArray.AsJson);

    vArray.AsJson := JSON_EMPTY_ARRAY;
    CheckEquals(0, vArray.Count, 'Count');

    vArray.AsJson := '[1]';
    CheckEquals(1, vArray.Count, 'Count');

    vArray.AsJson := '[1,2]';
    CheckEquals(2, vArray.Count, 'Count');

    vArray.Clear();
    CheckEquals(0, vArray.Count, 'Count');

    vArray.Add(0);
    vArray.Add(1);
    vArray.Add(2);
    vArray.Add(3);
    vArray.Delete(3);
    CheckEquals(3, vArray.Count, 'Count');

    CheckEquals(0, vArray.Items[0]);
    CheckEquals(1, vArray.Items[1]);
    CheckEquals(2, vArray.Items[2]);
    vJSON := vArray.AsJson;
    CheckEqualsString('[0.00,1.00,2.00]', vJSON);

    vArray.AsJSON := '[0,1,2]';
    CheckEquals(3, vArray.Count, 'Count');
    CheckEqualsString(vJSON, vArray.AsJSON);
    CheckEquals(0, vArray.Items[0]);
    CheckEquals(1, vArray.Items[1]);
    CheckEquals(2, vArray.Items[2]);

    //somewhat liberal conversion: strings auto-converted to currency, null to 0, bool (True or False) to 0
    vArray.AsJson := '["1", 2, "3", null, true, "FALSE"]';
    CheckEquals(6, vArray.Count, 'Count');
    CheckEquals(1, vArray.Items[0]);
    CheckEquals(2, vArray.Items[1]);
    CheckEquals(3, vArray.Items[2]);
    CheckEquals(0, vArray.Items[3]);
    CheckEquals(0, vArray.Items[4]);
    CheckEquals(0, vArray.Items[5]);
  finally
    vArray.Free();
  end;
end;


procedure TestTdxJSONObjectArray.TestFloatArray;
var
  vArray:TdxJSONArrayOfFloat;
  vJSON:String;
begin
  vArray := TdxJSONArrayOfFloat.Create();
  try
    CheckEquals(0, vArray.Count, 'Count');
    CheckEqualsString(JSON_EMPTY_ARRAY, vArray.AsJson);

    vArray.AsJson := JSON_EMPTY_ARRAY;
    CheckEquals(0, vArray.Count, 'Count');

    vArray.AsJson := '[1]';
    CheckEquals(1, vArray.Count, 'Count');

    vArray.AsJson := '[1,2]';
    CheckEquals(2, vArray.Count, 'Count');

    vArray.Clear();
    CheckEquals(0, vArray.Count, 'Count');

    vArray.Add(0);
    vArray.Add(1.1);
    vArray.Add(2.2);
    vArray.Add(3);
    vArray.Delete(3);
    CheckEquals(3, vArray.Count, 'Count');

    CheckEquals(0, vArray.Items[0]);
    CheckEquals(1.1, vArray.Items[1]);
    CheckEquals(2.2, vArray.Items[2]);
    vJSON := vArray.AsJson;
    CheckEqualsString('[0,1.1,2.2]', vJSON);

    vArray.AsJSON := '[0,1.1,2.2]';
    CheckEquals(3, vArray.Count, 'Count');
    CheckEqualsString(vJSON, vArray.AsJSON);
    CheckEquals(0, vArray.Items[0]);
    CheckEquals(1.1, vArray.Items[1]);
    CheckEquals(2.2, vArray.Items[2]);

    //somewhat liberal conversion: strings auto-converted to float, null to 0, bool (True or False) to 0
    vArray.AsJson := '["1.1", 2.2, "3", null, true, "FALSE"]';
    CheckEquals(6, vArray.Count, 'Count');
    CheckEquals(1.1, vArray.Items[0]);
    CheckEquals(2.2, vArray.Items[1]);
    CheckEquals(3, vArray.Items[2]);
    CheckEquals(0, vArray.Items[3]);
    CheckEquals(0, vArray.Items[4]);
    CheckEquals(0, vArray.Items[5]);
  finally
    vArray.Free();
  end;
end;


procedure TestTdxJSONObjectArray.TestIntegerArray;
var
  vArray:TdxJSONArrayOfInteger;
  vJSON:String;
begin
  vArray := TdxJSONArrayOfInteger.Create();
  try
    CheckEquals(0, vArray.Count, 'Count');
    CheckEqualsString(JSON_EMPTY_ARRAY, vArray.AsJson);

    vArray.AsJson := JSON_EMPTY_ARRAY;
    CheckEquals(0, vArray.Count, 'Count');

    vArray.AsJson := '[1]';
    CheckEquals(1, vArray.Count, 'Count');

    vArray.AsJson := '[1,2]';
    CheckEquals(2, vArray.Count, 'Count');

    vArray.Clear();
    CheckEquals(0, vArray.Count, 'Count');

    vArray.Add(0);
    vArray.Add(1);
    vArray.Add(2);
    vArray.Add(3);
    vArray.Delete(3);
    CheckEquals(3, vArray.Count, 'Count');

    CheckEquals(0, vArray.Items[0]);
    CheckEquals(1, vArray.Items[1]);
    CheckEquals(2, vArray.Items[2]);
    vJSON := vArray.AsJson;
    CheckEqualsString('[0,1,2]', vJSON);

    vArray.AsJSON := '[0,1,2]';
    CheckEquals(3, vArray.Count, 'Count');
    CheckEqualsString(vJSON, vArray.AsJSON);
    CheckEquals(0, vArray.Items[0]);
    CheckEquals(1, vArray.Items[1]);
    CheckEquals(2, vArray.Items[2]);

    //somewhat liberal conversion: strings auto-converted to float, null to 0, bool (True or False) to 0
    vArray.AsJson := '["1", 2, "3", null, true, "FALSE"]';
    CheckEquals(6, vArray.Count, 'Count');
    CheckEquals(1, vArray.Items[0]);
    CheckEquals(2, vArray.Items[1]);
    CheckEquals(3, vArray.Items[2]);
    CheckEquals(0, vArray.Items[3]);
    CheckEquals(0, vArray.Items[4]);
    CheckEquals(0, vArray.Items[5]);
  finally
    vArray.Free();
  end;
end;


procedure TestTdxJSONObjectArray.TestInt64Array;
var
  vArray:TdxJSONArrayOfInt64;
  vJSON:String;
  vLongInt:Int64;
begin
  vArray := TdxJSONArrayOfInt64.Create();
  try
    CheckEquals(0, vArray.Count, 'Count');
    CheckEqualsString(JSON_EMPTY_ARRAY, vArray.AsJson);

    vArray.AsJson := JSON_EMPTY_ARRAY;
    CheckEquals(0, vArray.Count, 'Count');

    vArray.AsJson := '[1]';
    CheckEquals(1, vArray.Count, 'Count');

    vArray.AsJson := '[1,2]';
    CheckEquals(2, vArray.Count, 'Count');

    vArray.Clear();
    CheckEquals(0, vArray.Count, 'Count');

    vArray.Add(0);
    vArray.Add(1);
    vArray.Add(2);
    vArray.Add(3);
    vArray.Delete(3);
    CheckEquals(3, vArray.Count, 'Count');

    CheckEquals(0, vArray.Items[0]);
    CheckEquals(1, vArray.Items[1]);
    CheckEquals(2, vArray.Items[2]);
    vJSON := vArray.AsJson;
    CheckEqualsString('[0,1,2]', vJSON);

    vArray.AsJSON := '[0,1,2]';
    CheckEquals(3, vArray.Count, 'Count');
    CheckEqualsString(vJSON, vArray.AsJSON);
    CheckEquals(0, vArray.Items[0]);
    CheckEquals(1, vArray.Items[1]);
    CheckEquals(2, vArray.Items[2]);

    //somewhat liberal conversion: strings auto-converted to float, null to 0, bool (True or False) to 0
    vArray.AsJson := '["1", 2, "3", null, true, "FALSE"]';
    CheckEquals(6, vArray.Count, 'Count');
    CheckEquals(1, vArray.Items[0]);
    CheckEquals(2, vArray.Items[1]);
    CheckEquals(3, vArray.Items[2]);
    CheckEquals(0, vArray.Items[3]);
    CheckEquals(0, vArray.Items[4]);
    CheckEquals(0, vArray.Items[5]);


    vArray.Clear;
    vLongInt := MaxInt;
    vLongInt := vLongInt + 1;
    vArray.Add(vLongInt);
    CheckEquals(1, vArray.Count, 'Count');
    CheckEquals(vLongInt, vArray.Items[0]);
  finally
    vArray.Free();
  end;
end;


initialization
  RegisterTest(TestTdxJSONObjectArray.Suite);

end.

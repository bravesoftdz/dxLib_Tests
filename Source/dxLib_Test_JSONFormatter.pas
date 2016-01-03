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
unit dxLib_Test_JSONFormatter;

interface
{$I '..\Dependencies\dxLib\Source\dxLib.inc'}

uses
  TestFramework,
  dxLib_JSONFormatter;

type

  TestTdxJSONFormatter = class(TTestCase)
  private
    fFormatter:TdxJSONFormatter;
  protected
    procedure SetUp(); override;
    procedure TearDown(); override;

    function FormatObject(const aName:String;
                          const aValue:String;
                          const aIdentLevel:Integer=1;
                          const aIdentString:String=DEFAULT_IDENT_SPACING):String;
  published
    procedure TestEmptyObject();
    procedure TestEmptyObjectWithWhitespace();
    procedure TestEmptyArray();
    procedure TestEmptyArrayWithWhitespace();
    procedure TestEmptyObjectWithEmptyArray();
    procedure TestSingleStringObject();
    procedure TestSingleBooleanObject();
    procedure TestSingleIntegerObject();
    procedure TestSingleNullObject();
    procedure TestCustomColonPrefixSpacing();
    procedure TestCustomColonSuffixSpacing();
    procedure TestCustomIdentSpacing();
    procedure TestCompactOutput();
    procedure TestObjectArray();
    procedure TestInvalidText();
  end;


implementation
uses
  dxLib_JSONUtils,
  dxLib_Strings;


procedure TestTdxJSONFormatter.Setup();
begin
  inherited;
  fFormatter := TdxJSONFormatter.Create();
end;

procedure TestTdxJSONFormatter.Teardown();
begin
  fFormatter.Free();
  inherited;
end;

function TestTdxJSONFormatter.FormatObject(const aName:String;
                                           const aValue:String;
                                           const aIdentLevel:Integer=1;
                                           const aIdentString:String=DEFAULT_IDENT_SPACING):String;
var
  i:Integer;
begin
  Result := '{' + sLineBreak;
  for i := 1 to aIdentLevel do
  begin
    Result := Result + aIdentString;
  end;
  Result := Result + '"' + aName + '"'
            + fFormatter.ColonPrefix + ':' + fFormatter.ColonSuffix
            + aValue
            + sLineBreak;

  for i := 1 to aIdentLevel-1 do
  begin
    Result := Result + aIdentString;
  end;
  Result := Result + '}';
end;

procedure TestTdxJSONFormatter.TestEmptyObject();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('{}');
  Check(vFormatted = JSON_EMPTY_OBJECT);
end;


procedure TestTdxJSONFormatter.TestEmptyObjectWithWhitespace();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('{  }');
  Check(vFormatted = JSON_EMPTY_OBJECT);

  vFormatted := fFormatter.FormatJSON('{' + Char(#9) + '}');
  Check(vFormatted = JSON_EMPTY_OBJECT);

  vFormatted := fFormatter.FormatJSON('{' + sLineBreak + ' }');
  Check(vFormatted = JSON_EMPTY_OBJECT);

  vFormatted := fFormatter.FormatJSON(Char(#9) + ' {  } ' + sLineBreak);
  Check(vFormatted = JSON_EMPTY_OBJECT);
end;


procedure TestTdxJSONFormatter.TestEmptyArray();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('[]');
  Check(vFormatted = JSON_EMPTY_ARRAY);
end;


procedure TestTdxJSONFormatter.TestEmptyArrayWithWhitespace();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('[  ]');
  Check(vFormatted = JSON_EMPTY_ARRAY);

  vFormatted := fFormatter.FormatJSON('[' + Char(#9) + ']');
  Check(vFormatted = JSON_EMPTY_ARRAY);

  vFormatted := fFormatter.FormatJSON('[' + sLineBreak + ' ]');
  Check(vFormatted = JSON_EMPTY_ARRAY);

  vFormatted := fFormatter.FormatJSON(' [  ] ' + sLineBreak);
  Check(vFormatted = JSON_EMPTY_ARRAY);
end;


procedure TestTdxJSONFormatter.TestEmptyObjectWithEmptyArray();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('{[]}');

  Check(vFormatted = '{' + sLineBreak + fFormatter.IndentString + '[]' + sLineBreak + '}');
end;


procedure TestTdxJSONFormatter.TestSingleStringObject();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('{   "Test"   :   "Output"    }');

  Check(vFormatted = FormatObject('Test', '"Output"'));
end;


procedure TestTdxJSONFormatter.TestSingleBooleanObject();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('{   "Test"   :   true    }');
  Check(vFormatted = FormatObject('Test', 'true'));
end;


procedure TestTdxJSONFormatter.TestSingleIntegerObject();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('{"Test" :   123}');

  Check(vFormatted = FormatObject('Test', '123'));
end;


procedure TestTdxJSONFormatter.TestSingleNullObject();
var
  vFormatted:String;
begin
  vFormatted := fFormatter.FormatJSON('{"Test":null }');

  Check(vFormatted = FormatObject('Test', 'null'));
end;


procedure TestTdxJSONFormatter.TestCustomColonPrefixSpacing();
const
  PADDING_AMOUNT = '   ';
var
  vSave:String;
  vFormatted:String;
begin
  vSave := fFormatter.ColonPrefix;
  try
    fFormatter.ColonPrefix := PADDING_AMOUNT;
    vFormatted := fFormatter.FormatJSON('{"Test":null }');
    Check(vFormatted = '{' + sLineBreak
                       + fFormatter.IndentString + '"Test"'
                       + PADDING_AMOUNT + ':' + fFormatter.ColonSuffix
                       + 'null'
                       + sLineBreak + '}');
  finally
    fFormatter.ColonPrefix := vSave;
  end;
end;


procedure TestTdxJSONFormatter.TestCustomColonSuffixSpacing();
const
  PADDING_AMOUNT = '   ';
var
  vSave:String;
  vFormatted:String;
begin
  vSave := fFormatter.ColonSuffix;
  try
    fFormatter.ColonSuffix := PADDING_AMOUNT;
    vFormatted := fFormatter.FormatJSON('{"Test":null }');
    Check(vFormatted = '{' + sLineBreak
                       + fFormatter.IndentString + '"Test"'
                       + fFormatter.ColonPrefix + ':' + PADDING_AMOUNT
                       + 'null'
                       + sLineBreak + '}');
  finally
    fFormatter.ColonSuffix := vSave;
  end;
end;


procedure TestTdxJSONFormatter.TestCustomIdentSpacing();
const
  PADDING_AMOUNT = '   ';
var
  vSave:String;
  vFormatted:String;
  vExpected:String;
begin
  vSave := fFormatter.IndentString;
  try
    fFormatter.IndentString := PADDING_AMOUNT;

    vFormatted := fFormatter.FormatJSON('{"Test":null }');
    vExpected := FormatObject('Test', 'null', 1, PADDING_AMOUNT);

    Check(vFormatted = vExpected);
  finally
    fFormatter.IndentString := vSave;
  end;
end;


procedure TestTdxJSONFormatter.TestCompactOutput();
var
  vFormatted:String;
  vExpected:String;
begin
  fFormatter.SetCompactStyle();
  try
    vFormatted := fFormatter.FormatJSON(' { "TestArray" : [ {"Test" : 1 }' + sLineBreak + ', { "Test" : 2 } ] }');
    vExpected := '{"TestArray":[{"Test":1},{"Test":2}]}';

    Check(vFormatted = vExpected);
  finally
    fFormatter.SetDefaultStyle();
  end;
end;


procedure TestTdxJSONFormatter.TestObjectArray();
var
  vFormatted:String;
  vExpected:String;
begin
  vFormatted := fFormatter.FormatJSON('{"TestArray":[{"Test":1},{"Test":2}]}');

  vExpected := '{' + sLineBreak
               + fFormatter.IndentString + '"TestArray"'
               + fFormatter.ColonPrefix + ':' + fFormatter.ColonSuffix
               + '[' + sLineBreak
               + fFormatter.IndentString + fFormatter.IndentString
               + FormatObject('Test', '1', 3)
               + ', '
               + sLineBreak + fFormatter.IndentString + fFormatter.IndentString //needed if CommaLineBreak=True
               + FormatObject('Test', '2', 3)
               + sLineBreak + fFormatter.IndentString + ']'
               + sLineBreak + '}';

  Check(vFormatted = vExpected);
end;


procedure TestTdxJSONFormatter.TestInvalidText();
var
  vFormatted:String;
  vExpected:String;
begin
  vFormatted := fFormatter.FormatJSON('{"Test": 123} Invalid Text Here');
  //invalid characters are left in place... but note that all JSON whitespace is stripped
  vExpected := FormatObject('Test', '123') + 'InvalidTextHere';
  Check(vFormatted = vExpected);
end;


initialization
  RegisterTest(TestTdxJSONFormatter.Suite);

end.

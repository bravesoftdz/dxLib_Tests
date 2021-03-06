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
unit dxLib_Test_JSON_Utils;

interface
{$I '..\Dependencies\dxLib\Source\dxLib.inc'}

uses
  TestFramework,
  dxLib_JSONUtils;

type

  TestTdxJSONUtils = class(TTestCase)
  published
    procedure TestCurrencyFormat();
    procedure TestExtendedFormat();
    procedure TestControlCharacters();
  end;


implementation
uses
  {$IFDEF DX_UnitScopeNames}
  System.SysUtils;
  {$ELSE}
  SysUtils;
  {$ENDIF}


procedure TestTdxJSONUtils.TestCurrencyFormat();
var
  vLargeNumber:Currency;
  vFormatted:String;
begin
  vLargeNumber := 23023320329.23234;

  vFormatted := JSON_Currency(0);
  Check(vFormatted = '0.00');

  vFormatted := JSON_Currency(vLargeNumber);
  Check(vFormatted = '23023320329.2323'); //rounded to 4 decimals
end;

procedure TestTdxJSONUtils.TestExtendedFormat();
var
  vLargeNumber:Extended;
  vFormatted:String;
begin
  vLargeNumber := 1.18E4932; //largest Extended  (except 1.19E4932 'infinite')
  vFormatted := JSON_Float(vLargeNumber);
  Check(vFormatted = '1.18E4932');

  vFormatted := JSON_Float(0);
  Check(vFormatted = '0');
end;

procedure TestTdxJSONUtils.TestControlCharacters();
var
  vFormatted:String;
begin
  vFormatted := JSON_String(#0);
  Check(vFormatted = '"\u0000"');

  vFormatted := JSON_String(#7);
  Check(vFormatted = '"\u0007"');

  vFormatted := JSON_String(Char(#127));
  Check(vFormatted = '"' + Char(#127) + '"');

  {$IFNDEF DX_String_Is_UTF16}
  vFormatted := JSON_String(AnsiChar(Char(#128)));
  Check(vFormatted = '"\u0080"');

  vFormatted := JSON_String(Char(#255));
  Check(vFormatted = '"\u00FF"');
  {$ENDIF}
end;


initialization
  RegisterTest(TestTdxJSONUtils.Suite);

end.

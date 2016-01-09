﻿//Unit contains embedded Unicode characters, unusable in older Delphi versions
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
unit dxLib_Test_JSONObjectUnicode;

interface
{$I '..\Dependencies\dxLib\Source\dxLib.inc'}

uses
  TestFramework,
  dxLib_JSONObjects;

type
  TExampleObject = class(TdxJSONObject)
  private
    fData:String;
  published
    property Data:String read fData write fData;
  end;


  TestTdxJSONObjectUnicode = class(TTestCase)
  published
    procedure TestSimpleAssignment();
  end;


implementation


procedure TestTdxJSONObjectUnicode.TestSimpleAssignment();
const
  UNICODE_CHAR_EX = '蒜';     //\u849C
  SURROGATE_PAIR_EX = '😂';   //\uD83D\uDE02
var
  vTest:TExampleObject;
begin
  vTest := TExampleObject.Create();
  try
    CheckEqualsString('{"Data":""}', vTest.AsJSON);

    vTest.AsJSON := '{"Data":"Test\u849cTest"}';
    CheckEqualsString('Test' + UNICODE_CHAR_EX + 'Test', vTest.Data);

    vTest.Clear;
    CheckEqualsString('{"Data":""}', vTest.AsJSON);

    vTest.Data := UNICODE_CHAR_EX;
    CheckEqualsString('{"Data":"\u849C"}', vTest.AsJSON);  //note uppercase HEX always returned

    vTest.AsJSON := '{"Data":"\ud83d\uDE02"}';
    CheckEqualsString(SURROGATE_PAIR_EX, vTest.Data);

    vTest.AsJSON := '{"Data":"' + SURROGATE_PAIR_EX + '"}';
    CheckEqualsString(SURROGATE_PAIR_EX, vTest.Data);
    CheckEqualsString('{"Data":"\uD83D\uDE02"}', vTest.AsJson);

    vTest.Clear;
    CheckEqualsString('{"Data":""}', vTest.AsJSON);
  finally
    vTest.Free();
  end;
end;


initialization
  RegisterTest(TestTdxJSONObjectUnicode.Suite);

end.

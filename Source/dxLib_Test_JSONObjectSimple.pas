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
unit dxLib_Test_JSONObjectSimple;

interface
{$I '..\Dependencies\dxLib\Source\dxLib.inc'}

uses
  TestFramework,
  dxLib_JSONObjects;

type
  TTestEmployeeStatus = (esEmployeeUndefined, esEmployeeStandard, esEmployeeManager);

  //Basic example
  TExampleObjectTypical = class
  private
    fCurrentProcess:Integer;
    fFirstName:String;
    fLastName:String;
    fSalary:Currency;
    fStatus:TTestEmployeeStatus;
  public
    property CurrentProcess:Integer read fCurrentProcess write fCurrentProcess;
    property FirstName:String read fFirstName write fFirstName;
    property LastName:String read fLastName write fLastName;
    property Salary:Currency read fSalary write fSalary;
    property Status:TTestEmployeeStatus read fStatus write fStatus;
  end;
  //Change to support JSON:
  //1) Inherit from TdxJSONObject
  //2) Change the specific properties desired to be serialized into 'Published' properties
  TExampleObjectJSON = class(TdxJSONObject)
  private
    fCurrentProcess:Integer;
    fFirstName:String;
    fLastName:String;
    fSalary:Currency;
    fStatus:TTestEmployeeStatus;
  public
    property CurrentProcess:Integer read fCurrentProcess write fCurrentProcess;
  published
    property FirstName:String read fFirstName write fFirstName;
    property LastName:String read fLastName write fLastName;
    property Salary:Currency read fSalary write fSalary;
    property Status:TTestEmployeeStatus read fStatus write fStatus default esEmployeeStandard;
  end;
  (*
  can now use the object as normal, with the addition of:
  1) SET/GET routines (via .AsJSON)
  2) default values are respected for Ordinal types

  x := TExampleObjectJSON.Create();

  //Assign from JSON
  x.AsJSON := {"FirstName":"Darian", "LastName":"Miller", "Salary":1234.56, "Status":"esEmployeeManager"}

  x.Salary := 2000;
  //Serialize to JSON
  ShowMessage(x.AsJSON);  //will display {"FirstName":"Darian","LastName":"Miller","Salary":2000.00,"Status":"esEmployeeManager"}
  *)


  TestTdxJSONObjectSimple = class(TTestCase)
  published
    procedure TestDefaultValueChangedBehavior();
    procedure TestExampleObjectBasicUsage();
  end;


implementation


procedure TestTdxJSONObjectSimple.TestDefaultValueChangedBehavior();
var
  vOriginal:TExampleObjectTypical;
  vNewBehavior:TExampleObjectJSON;
begin
  vOriginal := TExampleObjectTypical.Create();
  vNewBehavior := TExampleObjectJSON.Create();
  try
    //JSON objects respect DEFAULT values, typically reserved for Delphi form components
    //If you want to eliminate this new behavior, rebuild with an empty set: PROPERTIES_WITH_DEFAULT_VALUES
    CheckFalse(vOriginal.Status = vNewBehavior.Status);
  finally
    vOriginal.Free();
    vNewBehavior.Free();
  end;
end;


procedure TestTdxJSONObjectSimple.TestExampleObjectBasicUsage();
const
  EXAMPLE_DATA = '{"FirstName":"Darian","LastName":"Miller","Salary":1234.56,"Status":"esEmployeeManager"}';
  EXAMPLE_DEFAULT = '{"FirstName":"","LastName":"","Salary":0.00,"Status":"esEmployeeStandard"}';
var
  x:TExampleObjectJSON;
begin
  x := TExampleObjectJSON.Create();
  try
    CheckEqualsString(EXAMPLE_DEFAULT, x.AsJSON);

    x.AsJSON := EXAMPLE_DATA;
    CheckEqualsString(EXAMPLE_DATA, x.AsJSON);
  finally
    x.Free();
  end;
end;


initialization
  RegisterTest(TestTdxJSONObjectSimple.Suite);

end.

unit statistics;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, parliamentstructure;

  procedure collectStatistics(var parliament : TParliament; var laws : TLaws; var stats : TSimStats; round : Longint);

implementation

function calculateApprovalrate(var parliament : TParliament; var laws : TLaws; round : Longint) : Extended;
var i : Longint;
    approved : Longint;
begin
  approved := 0;
  for i:=1 to laws.size do
    if laws.laws[i].approved then Inc(approved);

  laws.approved:=approved;

  Result := laws.approved/laws.size;
end;

function calculateTotalBenefit(var parliament : TParliament; var laws : TLaws; round : Longint) : Extended;
var i, count       :  Longint;
    benefit        : Extended;
begin
  count := 0;
  benefit := 0;
  for i:=1 to laws.size do
    if laws.laws[i].approved then
         begin
           Inc(count);
           benefit := benefit + laws.laws[i].collectiveinteresty;
         end;

  Result := benefit;
end;

procedure collectStatistics(var parliament : TParliament; var laws : TLaws; var stats : TSimStats; round : Longint);
begin
  stats.legislatures[round].nbdelegates:=parliament.delegates.size;
  stats.legislatures[round].nbindipendents:=parliament.indipendents;
  stats.legislatures[round].nbparties:=parliament.parties.size;

  stats.legislatures[round].approvalrate:=calculateApprovalrate(parliament, laws, round);
  stats.legislatures[round].totalbenefit:=calculateTotalBenefit(parliament, laws, round);

  if parliament.parties.size>0 then
    stats.legislatures[round].nbparty1:=parliament.parties.par[1].size;
  if parliament.parties.size>1 then
    stats.legislatures[round].nbparty2:=parliament.parties.par[2].size;
end;

end.


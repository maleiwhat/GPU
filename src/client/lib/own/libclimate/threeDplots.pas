unit threeDplots;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, datastructure, conversion, climaconstants, GL, GLU, Graphics,
  ArcBall;

const
   radius = 1;


type  T3DPoint = record
      x,y,z : Real;
end;

type  T3DGrid = Array [0..359] of Array [0..179] of T3DPoint;
type  P3DGrid = ^T3DGrid;

procedure init3DGrid(var w : TWorld; var clima : TClima);
procedure plot3d(vertex : P3DGrid; colors : PGridColor);
procedure plot3dSphere(colors : PGridColor);
procedure plot3dTerrain(colors : PGridColor);


implementation

var
   sphere3D,
   terrain3D   : T3DGrid;

procedure init3DGrid(var w : TWorld; var clima : TClima);
var i, j : Longint;
    p1, p2 :T3DPoint;
    lat, lon, altitude : TClimateType;
begin
 for j := 0 to 179 do
     for i := 0 to 359 do
       begin
         lat := YtoLat(j);       //-90..+90
         lon := XtoLon(i);       //-180..+180

         altitude := w.elevation[i][j];
         //if (altitude<0) then altitude := 0;

         p1.x := (lon/90) * 3;
         p1.y := (lat/180) * 3 ;
         p1.z := altitude/12000;
         terrain3D[i][j] := p1;

         lat := lat/90 * Pi/2 + Pi/2; //0..180
         lon := lon/180 * Pi + Pi;  //0..360

         // adding half a degree to longitude for triangles
         if (j mod 2 = 0) then
               lon := lon + 1/720 * 2 * Pi;

         p2.x := - radius * sin(lat) * cos(lon);
         p2.z :=   radius * sin(lat) * sin(lon);
         p2.y := - radius * cos(lat);
         sphere3D[i][j] := p2;
       end;

end;


procedure plot3d(vertex : P3DGrid; colors : PGridColor);
var i, j,
    target_i,
    target_j : Longint;
    p1,p2,p3,p4 : T3DPoint;
    r, g, b,
    correction_x,
    correction_y : TClimateType;

begin
  for j := 0 to 179 do
     for i := 0 to 359 do
       begin
          target_i := i+1;
          target_j := j+1;
          if (target_i>359) then target_i := target_i-359;
          if (target_j>179) then target_j := target_j-179;

          p1 := vertex^[i]  [j];
          p2 := vertex^[target_i][j];
          p3 := vertex^[i][target_j];
          p4 := vertex^[target_i][target_j];


          r := Red(colors^[i][j])/255;
          g := Green(colors^[i][j])/255;
          b := Blue(colors^[i][j])/255;

          glBegin(GL_TRIANGLES);
          glColor3f(r,g,b);
          glVertex3f( p1.x, p1.y, p1.z);               // Top Left Of The Triangle (Top)
          glVertex3f( p2.x, p2.y, p2.z);               // Top Right Of The Triangle (Top)
          glVertex3f( p3.x, p3.y, p3.z);               // Bottom Left Of The Triangle (Top)
          glEnd();

          glBegin(GL_TRIANGLES);
          glColor3f(r,g,b);
          glVertex3f( p2.x, p2.y, p2.z);               // Top Right Of The Triangle (Top)
          glVertex3f( p3.x, p3.y, p3.z);               // Bottom Left Of The Triangle (Top)
          glVertex3f( p4.x, p4.y, p4.z);               // Bottom Right Of The Triangle (Top)
          glEnd();
       end;

end;

procedure plot3dSphere(colors : PGridColor);
begin
 plot3d(@sphere3D, colors);
end;

procedure plot3dTerrain(colors : PGridColor);
begin
 plot3d(@terrain3D, colors);
end;

end.

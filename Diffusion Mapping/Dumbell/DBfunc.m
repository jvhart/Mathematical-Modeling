% Author:   Jarod Hart
% Date:     December 11, 2017
% Description: This is a function from R^2 -> R^3 that generates a dumbell
% manifold.  This function is meant to support the Dumbell.m script in the 
% diffusion mapping manifold learning demonstrations.

% Inputs
%       S - float/double matrix of any size, first domain variable
%       T - float/double matrix matching the size of S, second domain
%           variable

% Outputs
%       X - flost/double matrix matching size of S and T, x-variable output
%       Y - flost/double matrix matching size of S and T, y-variable output
%       Z - flost/double matrix matching size of S and T, z-variable output

function [X,Y,Z] = DBfunc(S,T)

R=T.*(1-T).*(4+cos(2*pi*T)).^10/4^10;
X=R.*cos(2*pi*S);
Y=R.*sin(2*pi*S);
Z=T;





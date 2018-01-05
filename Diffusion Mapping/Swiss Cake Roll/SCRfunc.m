% Author:   Jarod Hart
% Date:     November 18, 2017
% Description: This is a function from R^2 -> R^3 that generates a swiss
% cake roll manifold.  This function is meant to support the
% SwissCakeRoll.m script in the diffusion mapping manifold learning
% demonstrations.

% Inputs
%       S - float/double matrix of any size, first domain variable
%       T - float/double matrix matching the size of S, second domain
%           variable

% Outputs
%       X - flost/double matrix matching size of S and T, x-variable output
%       Y - flost/double matrix matching size of S and T, y-variable output
%       Z - flost/double matrix matching size of S and T, z-variable output

function [X,Y,Z] = SCRfunc(S,T)


X=2*T.*cos(4*pi*T);
Y=2*T.*sin(4*pi*T);
Z=S;

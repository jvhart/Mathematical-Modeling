% Author:        Jarod Hart
% Date:          November 20, 2017
% Description:   This function takes weights W trained according to a 
%                Adaline training rule, and evaluates the network for a
%                given x.

% Inputs:
%             x - input for network; vector of real numbers.
%             W - Adaline weight; vector of real numbers.

% Outputs:
%             a - Perceptron output; realnumber between -1 and 1.

% Dependencies: none

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

function [a] = EvaluateAdaline(x,W)

y=W*[x;1];
a=tanh(y);

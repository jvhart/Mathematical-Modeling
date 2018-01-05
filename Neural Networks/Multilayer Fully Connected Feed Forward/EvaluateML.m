% Author:        Jarod Hart
% Date:          November 20, 2017
% Description:   This function takes weights W trained according to a 
%                multilayer feedforward training rule, and evaluates the 
%                network for a given x.

% Inputs:
%             x - input for network; vector of real numbers.
%             W - ML weights; structure object made up of matrices of weigts.

% Outputs:
%             a - Perceptron output; vector of real numbers between -1 and 1.

% Dependencies: none

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org


function [a] = EvaluateML(x,W)

y=W{1}*[x;1];
a=tanh(y);
for k=1:length(W)-1
    y=W{k+1}*[a;1];
    a=tanh(y);
end

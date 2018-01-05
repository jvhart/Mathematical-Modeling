% Author:        Jarod Hart
% Date:          November 20, 2017
% Description:   This function takes weights W trained according to a 
%                Perceptron updating rule, and evaluates the network for a
%                given x.

% Inputs:
%             x - input for network; vector of real numbers.
%             W - Perceptron weight; vector of real numbers.

% Outputs:
%             a - Perceptron output; +-1.

% Dependencies: none

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

% Note: It is probably unnecessary to put this evaluation into a separate
% function, but I have done it to emphasize a standard form for other ANNs.
% For more complicated networks, it is worthwhile to build this evaluation
% function.

function [a] = EvaluatePerceptron(x,W)

a=sign(W*[x;1]);

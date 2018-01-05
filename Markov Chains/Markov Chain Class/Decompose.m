% Author:        Jarod Hart
% Date:          December 14, 2017
% Description:   This function takes an input transition matrix for a
% Markov chain, decomposes it into its communication classes using the
% CommuncationCasses.m function, and provides the block matrices necessary
% to construct the canonical form of the transition matrix

% Inputs:
%             P - Stochastic matrix (rows sum to 1)

% Outputs:
%             Diag - Cell array of matrices describing transitions between
%                    states within each communication class
%             UpperTriangle - Cell array of matrices describing transtiions
%                    from transient classes to other communication classes.
%             ComClasses - Cell array of index vectors identifying
%                          communcation classes
%             Types - Cell array of strings describing the corresponding
%             element of ComClasses as Transient or Absorbing

% Dependencies: CommunicationClasses.m

function [Diag,UpperTriangle,ComClasses,Types] = Decompose(P)

[ComClasses,Types]=CommunicationClasses(P);
NumClasses=length(ComClasses);
StateOrder=[];
for i=1:NumClasses
    StateOrder=[StateOrder,ComClasses{i}];
end

Diag={};
UpperTriangle={};
for i=1:NumClasses
    Diag{i}=P(ComClasses{i},ComClasses{i});
    if strcmp(Types{i},'Transient')
        StateOrder=setdiff(StateOrder,ComClasses{i});
        UpperTriangle{i}=P(ComClasses{i},StateOrder);
    end
end


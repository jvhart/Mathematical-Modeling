% Author:        Jarod Hart
% Date:          December 14, 2017
% Description:   This function takes an input transition matrix for a
% Markov chain, and decomposes it into its communication classes.  The
% ComClasses output is a cell array made up of integer vectors that contain
% the indices for each communication class.  The Types output is a cell
% array of strings that describe the type of communication class: Transient
% or Absorbing.  Communication classes are always ordered with transient
% classes listed first and recurrent/absorbing classes last.

% Inputs:
%             P - Stochastic matrix (rows sum to 1)

% Outputs:
%             ComClasses - Cell array of index vectors identifying
%                          communcation classes
%             Types - Cell array of strings describing the corresponding
%             element of ComClasses as Transient or Absorbing

% Dependencies: none

function [ComClasses,Types] = CommunicationClasses(P)

n=length(P);
A=sparse(double(P>0));
C=A;
for i=1:n
    C=sparse(double((C+A*C)>0));
end

Set=1:n;
CC={};
NumClasses=0;
while numel(Set)>0
    NumClasses=NumClasses+1;
    i=Set(1);
    CC{NumClasses}=find(C(i,:).*C(:,i)'>0);
    if ~ismember(i,CC{NumClasses})
        CC{NumClasses}=[CC{NumClasses},i];
    end
    Set=setdiff(Set,CC{NumClasses});
end

Ts={};
transients=[];
for i=1:NumClasses
    if sum(P(CC{i}(1),CC{i}))<1
        Ts=[Ts,'Transient'];
         transients=[transients,i];
    else
        Ts=[Ts,'Absorbing'];
    end
end

order=[transients,setdiff(1:NumClasses,transients)];
ComClasses={};
Types={};
count=0;
for i=order
    count=count+1;
    ComClasses{count}=CC{i};
    Types{count}=Ts{i};
end







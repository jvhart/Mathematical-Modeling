% Author:        Jarod Hart
% Date:          December 14, 2017
% Description:   This function takes the block matrices for a Markov chain
% in the form computed by the Decompose.m function, and puts them into a
% full canonical for transition matrix.  It also returns the relevant
% submatrices often used to find the fundamental matrix, absorption times,
% etc for a Markov chain.

% Inputs:
%             Diag - Cell array of matrices describing transitions between
%                    states within each communication class
%             UpperTriangle - Cell array of matrices describing transtiions
%                    from transient classes to other communication classes.

% Outputs:
%             A - transition matrix in canoncial form
%             Q - square matrix in the upper left block of A corresponding
%                 to the transition between all transient states
%             R - matrix in the upper right block of A corresponding to the
%                 transition probabilities from transient states to
%                 recurrent ones
%             I - square matrix in the lower right block of A corresponding
%                 to the transitions within recurrent states.

% Dependencies: none

function [A,Q,R,I] = MakeCanonicalMatrix(Diag,UpperTriangle)

N=0;
for i=1:length(Diag)
    N=N+length(Diag{i});
end
A=zeros(N,N);

Tstates=0;
CurrentLoc=1;
for i=1:length(Diag)
    if i<=length(UpperTriangle)
        [m,n]=size(UpperTriangle{i});
        A(CurrentLoc:CurrentLoc+m-1,CurrentLoc+m:CurrentLoc+m+n-1)=...
            UpperTriangle{i};
        Tstates=Tstates+m;
    else
        m=length(Diag{i});
    end
    A(CurrentLoc:CurrentLoc+m-1,CurrentLoc:CurrentLoc+m-1)=Diag{i};
    CurrentLoc=CurrentLoc+m;
end

Q=A(1:Tstates,1:Tstates);
R=A(1:Tstates,Tstates+1:end);
I=A(Tstates+1:end,Tstates+1:end);

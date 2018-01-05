% Author:        Jarod Hart
% Date:          November 19, 2017
% Description:   This function draws from a discrete probability
% distribution d on the integers 1..length(d).  s and t are parameters that
% determine how many random observations are drawn, and what size theiry.

% Inputs:
%             P - Stochastic matrix (rows sum to 1)
%             T - integer, number of simulated states
%             init - initial distribution for the markov chain or integer
%                    specifying initial state.

% Outputs:
%             x - vector of states of the simulated Markov chain

% Dependencies: DrawFrom.m

function [x] = SimulateMC(P,T,init)

[n,~]=size(P);

if nargin<3
    init=ones(1,n)/n;
elseif length(init)==1
    temp=init;
    init=zeros(1,n);
    init(temp)=1;
end

x=DrawFrom(init,1);
for t=1:T-1
    x=[x,DrawFrom(P(x(end),:))];
end

% Author:   Jarod Hart
% Date:     December 14, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this file is to demonstrate a few computations that are possible with the
% MarkovChain class of objects.  Four differe types of random walk are
% made available with the script: absorbing, reflecting, semi-reflecting,
% and cirle.  See transition matrices below for more information.

% Dependencies: MarkovChain.m, Decompose.m, MakeCanonicalMatrix.m, 
%               SimulateMC.m, DrawFrom.m, MakeRandomWalkMatrix.m

% Resources:  These random walks are standard in any Markov chain textbook.

addpath(genpath('../../Markov Chains/Markov Chain Class'));

n=21; % number of points on the random walk, i.e. a random walk on 1,...,n.
p=.5; % probability of increasing state index
init=zeros(1,n);
init(floor((n+1)/2))=1; % set the initial state to start in the middle

%%% Four options for types of random walk on 1,...,n.
type='absorbing';
% type='reflecting';
% type='semi-reflecting';
% type='circle';

P = MakeRandomWalkMatrix(n,p,type);

RW=MarkovChain; % create MarkovChain object RW
RW=RW.initialize(P); % initialize RW


if strcmp(type,'absorbing') % unsuppress outputs below as desired.
    RW.N;  % N(i,j) is the expected number of times the 
           % chain will visit state j given that the chain
           % starts in state i.   Note that the states are
           % reordered here to reflect the
           % transient/absorbing class structure.  See
           % ComClasses for the reordering of the states.
    
    RW.B;  % B(i,j) is the probability of being absorbed into state j, given 
      % that the chain started in state i
    
                       % init.'
    ExpNumVisits=init(RW.ComClasses{1})*RW.N;
                       % this is the expected number of visits to each 
                       % transient node given the initial distribution
                       % init.
    
    ExpAbsMatrix=RW.T;
                     % this is the expected time to absorption, given the 
                     % the initial state.

    ExpAbs=init(RW.ComClasses{1})*ExpAbsMatrix;
                                         % this is the expected time to 
                                         % absoption, given the initial
                                         % distribution init.
    
    ProbAbs=init(RW.ComClasses{1})*RW.B;  % probability of absorption given 
                                % the initial distribution init.

end

RW.showgraph(); % show depiction of the graph for the Markov chain

if strcmp(type,'absorbing') % set simulation length
    T=floor(3*ExpAbs);
else
    T=1000;
end

x=RW.simulate(T,init); % simulate random walk

figure % splot simulated
hold on
plot(1:T,x,'b')
scatter(1:T,x,'b.')


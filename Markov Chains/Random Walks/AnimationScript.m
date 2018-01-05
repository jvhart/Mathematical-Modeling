% Author:   Jarod Hart
% Date:     January 3, 2018
% Description: This is a script file.  It can be run as is.  The purpose is
% to animate some simulations of Markov chains.  Two examples are included,
% random walks on 1 to n and a randomly generated transition matrix.

% Dependencies: MarkovChain.m, Decompose.m, MakeCanonicalMatrix.m, 
%               SimulateMC.m, DrawFrom.m, MakeRandomWalkMatrix.m,
%               AnimateMC.m

%% Random walks on 1 to n

n=10;
p=.51;
T=25;
speed=200;

P=MakeRandomWalkMatrix(n,p,'circle');
RW=MarkovChain;
RW=RW.initialize(P);
AllStates=RW.simulate(T,randi([1,n],1,1));

type='circle';
% type='random';
% type='line';
AnimateMC(AllStates,type,speed)

% type='graph';
% f=@(x) 2*x.^2-1;
% AnimateMC(AllStates,type,speed,f)

%% Randomly initialized transition matrix

n=20;
p=.5;
T=75;
speed=50;

P=rand(n,n);
P=diag(sum(P,2).^-1)*P;
RW=MarkovChain;
RW=RW.initialize(P);
AllStates=RW.simulate(T,randi([1,n],1,1));

% type='circle';
type='random';
AnimateMC(AllStates,type,speed)



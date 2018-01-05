% Author:   Jarod Hart
% Date:     December 14, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to implement a population genetics model known as the
% Wright-Fisher model.  It is a Markov chain that describes the prevalence
% of two alleles A_1 and A_2 in a population under no influence of natural
% selection or mutation.  The population is assumed to be a fixed size with
% non-overlapping generations, and mate randomly.  The state of the Markov
% chain indicates the number of allels A_1 that are present.  Since the
% total population is assumed to be constant, the number of alleles A_2
% present in the population can be computes as the complement.  Some of the
% capabilities of the MarkovChain class can be used to gain some more
% information about this model.

% Dependencies: MarkovChain.m, Decompose.m, MakeCanonicalMatrix.m, 
%               SimulateMC.m, DrawFrom.m

% Resources:  See for example the textbook, Handbook of Statistical
% Genetics by Balding, Bishop and Cannings (in particular chapter 22) for a
% description of this model, some extensions of it, and its original
% development.

% Note:  This is actually a simplification of the Wright-Fisher model.  The
% full model takes into accound fitness and mutation.  It is implemented in
% WrightFisherScript.m.

addpath(genpath('../Markov Chain Class'))

n=50;  % number of individual alleles in the population
       % precision limits are met around m=100
       % warnings of precision limits start around n=60
initialstate=10; % initial state of the chain, how many of A_1 are present

initial=zeros(1,n); % make initial distribution
initial(initialstate)=1;

P=zeros(n,n);

for i=0:(n-1)
    x=i/(n-1);
    for j=0:(n-1)
        P(i+1,j+1)=nchoosek(n-1,j)*x^j*(1-x)^(n-1-j);
    end
end

figure % visualization of the transition matrix
image(64*P)
title('Write-Fisher Markov chain transition matrix')

WF=MarkovChain; % make MarkovChain object
WF=WF.initialize(P);

ExpAbs=initial(WF.ComClasses{1})*WF.T; % compute expected time to absorption
strcat('Expected time before one of the alleles goes extinct:',...
    32,num2str(ExpAbs),32,'generations')

NumSimulations=50;
LengthSimulation=ceil(ExpAbs*4);
X=zeros(NumSimulations,LengthSimulation);

figure('Position',[100,100,1000,600])
axis tight manual
axis([0,LengthSimulation+2,-2,n+3])
ylabel('Prevalence of allele A_1')
xlabel('Generations of population')
title('Wright-Fisher Two-Allele Simulation')
hold on
WF.initial=initial;

for i=1:1:NumSimulations
    x=WF.simulate(LengthSimulation);
    X(i,:)=x;
    plot(x)
    pause(.01)
end





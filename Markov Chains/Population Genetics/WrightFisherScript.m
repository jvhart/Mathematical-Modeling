% Author:   Jarod Hart
% Date:     December 14, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to implement a population genetics model known as the
% Wright-Fisher model.  It is a Markov chain that describes the prevalence
% of two alleles A_1 and A_2 in a population under the influence of natural
% selection and mutation.  The population is assumed to be a fixed size
% with non-overlapping generations, and mate randomly.  The state of the 
% Markov chain indicates the number of allels A_1 that are present.  Since 
% the total population is assumed to be constant, the number of alleles A_2
% present in the population can be computes as the complement.

% Dependencies: MarkovChain.m, Decompose.m, MakeCanonicalMatrix.m, 
%               SimulateMC.m, DrawFrom.m

% Resources:  See for example the textbook, Handbook of Statistical
% Genetics by Balding, Bishop and Cannings (in particular chapter 22) for a
% description of this model and some extensions of it.

% Notes: With a positive probability of mutation of A_1 to A_2, it is
% actually posible for A_1 to come back from extinction.  Because of this,
% in order to compute expected time to extinction, we modify the Markov
% chain to have two absorbing states when A_1 or A_2 have zero population.
% This does not affect the simulation, but it does effect the computations
% of absorbing times.

addpath(genpath('../Markov Chain Class'))

PopulationSize=25; % number of diploid individuals in the population

n=2*PopulationSize;  % number of alleles
       % precision limits are met around m=100
       % warnings of precision limits start around m=60
initialA_1=25; % initial state of the chain, how many of A_1 are present
fitness=[1,.2,1.1]; % relative fitness of A_1A_1, A_1A_2, and A_2A_2
mutationprob=0; % probability of mutating from A_1 to A_2 or from A_2 
                % to A_1; here the mutation rates are assumed to be equal.
                % the mutationprob should be small, on the order of .001.
                % If it is much larger than that, it can cause loss of
                % problems with loss of precision in the computations in
                % this script.

initial=((1:n)==initialA_1); % make initial distribution
P=zeros(n,n); % make transition matrix
for i=0:(n-1)
    x=i/(n-1);
    fit_den=x^2*fitness(1)+2*x*(1-x)*fitness(2)+(1-x)^2*fitness(3);
    phi=x*(x*fitness(1)+(1-x)*fitness(2))/fit_den;
    psi=phi*(1-mutationprob)+(1-phi)*mutationprob;
    for j=0:(n-1)
        P(i+1,j+1)=nchoosek(n-1,j)*psi^j*(1-psi)^(n-1-j);
    end
end

figure % visualization of the transition matrix
image(64*P)
title('Write-Fisher Markov chain transition matrix')


WF=MarkovChain; % make MarkovChain object
WF=WF.initialize(P);
WFabs=WF; % make MarkovChain object
WFabs.P=P; % set zero popultions of A1 and A2 to absorbing states
WFabs.P(1,:)=zeros(1,n);
WFabs.P(1,1)=1;
WFabs.P(n,:)=zeros(1,n);
WFabs.P(n,n)=1;
WFabs=WFabs.initialize(WFabs.P);

ExpAbs=initial(WFabs.ComClasses{1})*WFabs.T; % compute expected time to absorption
strcat('Expected time before one of the alleles goes extinct:',...
    32,num2str(ExpAbs),32,'generations')
strcat('Probability that A_1 goes exinct:',32,num2str(WFabs.B(initialA_1,1)))
strcat('Probability that A_2 goes exinct:',32,num2str(WFabs.B(initialA_1,2)))

NumSimulations=800;
LengthSimulation=ceil(ExpAbs*4);
X=zeros(NumSimulations,LengthSimulation);

figure('Position',[100,100,1000,600])
pause(.000001)
axis tight manual
axis([0,LengthSimulation+2,-2,n+3])
ylabel('Prevalence of allele A_1')
xlabel('Generations of population')
title('Wright-Fisher Two-Allele Simulation')
hold on
WF.initial=initial;

A_1ext=0;
A_2ext=0;
for i=1:1:NumSimulations
    x=WF.simulate(LengthSimulation);
    X(i,:)=x;
    plot(x)
    pause(.0001)
    if x(end)<n/2
        A_1ext=A_1ext+1;
    else
        A_2ext=A_2ext+1;
    end
end

strcat('True probability of [A_1,A_2] going extinct:',...
    32,num2str([WFabs.B(initialA_1,1),WFabs.B(initialA_1,2)]))
if mutationprob==0 % if mutationprob>0, this code does not work to compute
                   % to approximate these probabilities based on the
                   % simulation.  The exact values reported above are still
                   % valid.
    strcat('Simulation estimated probability of [A_1,A_2] going extinct:',...
        32,num2str([A_1ext,A_2ext]/NumSimulations))
end


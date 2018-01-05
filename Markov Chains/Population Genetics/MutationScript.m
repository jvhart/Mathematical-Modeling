% Author:   Jarod Hart
% Date:     Jarnuary 4, 2018
% Description: This is a script file.  It can be run as is.  This is a
% model of the effects of random mutation between two alleles A_1 and A_2
% in an infinite population through many non-overlapping generations with 
% random mating.  The dynamics are described by a system of difference 
% equations, and lead to an equilibrium based on the rates of mutation from
% A_1 to A_2 and from A_2 to A_1.  The first part of the script is the 
% traditional implementation with the mutation rates constant.  The second 
% part of the script allows for the mutation rates to be defined as 
% functions depending on the proportions of A_1 and A_2.  It attempts to 
% find an equilibrium point by a fixed point method, which is not 
% necessarily guaranteed to work, but does in many cases.

% Dependencies: none

% Resources:  See for example the textbook, Handbook of Statistical
% Genetics by Balding, Bishop and Cannings (in particular chapter 22) for a
% description of this model.

InitA_1=.45; % initial proportion of A_1 allele
A_1toA_2=.001; % mutation rate A_1 to A_2
A_2toA_1=.0032; % mutation rate A_2 to A_1
T = 700;     % number of generations for simulation

A_1=InitA_1;
A_2=1-A_1;

for t=2:T   % generation loop
    A_1(t)=(1-A_1toA_2)*A_1(t-1) + A_2toA_1*A_2(t-1);
    A_2(t)=1 - (1-A_1toA_2)*A_1(t-1) - A_2toA_1*A_2(t-1);
end

Equilibrium=[A_2toA_1,A_1toA_2]/(A_1toA_2+A_2toA_1); 
            % compute true equilibrium

strcat('The estimated equilibrium is:',32,num2str(100*A_1(end)),...
    '% A_1, and',32,num2str(100*A_2(end)),'% A_2.')
strcat('The true equilibrium is:',32,num2str(100*Equilibrium(1)),...
    '% A_1, and',32,num2str(100*Equilibrium(2)),'% A_2.')

figure
hold on
plot(1:T,A_1,'b-',1:T,A_2,'r-',1:T,Equilibrium(1)*ones(1,T),'b-.',...
    1:T,Equilibrium(2)*ones(1,T),'r-.')
axis([1,T,0,1])
title('Allele prevailance')
xlabel('Generation')
ylabel('Proportion in population')
legend('A_1','A_2','A_1 equilibrium','A_2 equilibrium')

%%

% It should be noted that there is no particular reason for choosing the
% A_1toA_2 and A_2toA_1 functions that are provided below.  This is only to
% emphasize that this model is capable of considering mutation rates that
% depend on the relative proportions of A_1 and A_2 in the population.

InitA_1=.25; % initial proportion of A_1 allele
A_1toA_2=@(a_1,a_2) .1 *a_2; % mutation rate A_1 to A_2
A_2toA_1=@(a_1,a_2) .1*a_2^2/(1+a_1); % mutation rate A_2 to A_1
T = 70;     % number of generations for simulation

A_1=InitA_1;
A_2=1-A_1;

for t=2:T   % generation loop
    A_1(t)=(1-A_1toA_2(A_1(t-1),A_2(t-1)))*A_1(t-1) +...
        A_2toA_1(A_1(t-1),A_2(t-1))*A_2(t-1);
    A_2(t)=1 - (1-A_1toA_2(A_1(t-1),A_2(t-1)))*A_1(t-1) -...
        A_2toA_1(A_1(t-1),A_2(t-1))*A_2(t-1);
end

f=@(a) A_1toA_2(a,1-a)*a-A_2toA_1(a,1-a)*(1-a);
a0=fzero(f,.5);
Equilibrium=[a0,1-a0];

strcat('The estimated equilibrium is:',32,num2str(100*A_1(end)),...
    '% A_1, and',32,num2str(100*A_2(end)),'% A_2.')
strcat('The true equilibrium is:',32,num2str(100*Equilibrium(1)),...
    '% A_1, and',32,num2str(100*Equilibrium(2)),'% A_2.')

figure
hold on
plot(1:T,A_1,'b-',1:T,A_2,'r-',1:T,Equilibrium(1)*ones(1,T),'b-.',...
    1:T,Equilibrium(2)*ones(1,T),'r-.')
axis([1,T,0,1])
title('Allele prevailance')
xlabel('Generation')
ylabel('Proportion in population')
legend('A_1','A_2','A_1 equilibrium','A_2 equilibrium')


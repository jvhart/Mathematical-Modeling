% Author:   Jarod Hart
% Date:     January 3, 2018
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate a semi-supervised clustering algorithm
% based on diffusion mapping and absorption probabilities for Markov
% chains.  The script generates 2 or 3 spirals in 2 dimensional Euclidean
% space, based on the num_spirals parameter, and clusers the dataset into
% the spirals using a single labeled datapoint from each spiral.

% Dependencies: GenerateK.m, DiffusionMap.m, MarkovChain.m

% Resources:  This was mentioned as an possible application in the 
% diffusion map paper by Coifman and Lafon.

%% Make dataset

addpath(genpath('../Diffusion Map'));
addpath(genpath('../../Markov Chains/Markov Chain Class'));

num_spirals=3; % Number of spirals: set to 2 or 3. More than 3 will cause 
               % errors with the color handling.
n=120; % Number of points per spiral
a=10;
b=50;
t=linspace(a,b,n)'; % Make parameter discretization
X=[]; % Generate dataset
for i=1:num_spirals
    x=t.*cos(t.^.5-2*(i-1)*pi/num_spirals)/b;
    y=t.*sin(t.^.5-2*(i-1)*pi/num_spirals)/b;
    X=[X;[x,y]];
end
[N,~]=size(X);

%% Construct diffusion map

m=4; % Number of dimensions for diffusion map embedding
Kfun=@(x,y) exp(-30*sum(abs(x-y))); % Local similarity function
K=GenerateK(X,Kfun);
[Lambda,Psi,P]=DiffusionMap(K,m,1);

figure('Position',[100,100,800,600])
PP=P;
image(10*3*N*PP)
title('Progression of transition matrices')
xlabel('Press any key')
pause
for i=1:50:3000
    image(10*3*N*PP)
    PP=PP*P;
    pause(.001)
end
close(gcf)

figure('Position',[200,200,900,400])
subplot(1,2,1)
scatter(X(:,1),X(:,2),'.','black')
title('Original unlabeled data')
xlabel('x')
ylabel('y')
subplot(1,2,2)
scatter(Psi(:,1),Psi(:,2),'.','blue')
title('Diffusion coefficients')
xlabel('Psi_1')
ylabel('Psi_2')

figure
subplot(2,2,1)
scatter3(Psi(:,1),Psi(:,2),Psi(:,3),'.')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_3')
subplot(2,2,2)
scatter3(Psi(:,1),Psi(:,2),Psi(:,4),'.')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_4')
subplot(2,2,3)
scatter3(Psi(:,1),Psi(:,3),Psi(:,4),'.')
xlabel('Psi_1')
ylabel('Psi_3')
zlabel('Psi_4')
subplot(2,2,4)
scatter3(Psi(:,2),Psi(:,3),Psi(:,4),'.')
xlabel('Psi_2')
ylabel('Psi_3')
zlabel('Psi_4')

%% Partially label the dataset

Labeled=randsample(1:n,num_spirals);  % choose random elements to label
Labeled=Labeled+(0:n:((num_spirals-1)*n));
Unlabeled=setdiff(1:N,Labeled); % make list of unlabeled indices

A=P; % Make new transition matrix with absorbing states at locations 
     % corresponding to the labeled data points.
for i=Labeled
    A(i,:)=zeros(1,N);
    A(i,i)=1;
end

figure('Position',[100,100,800,600])
PP=A;
image(10*3*N*PP)
title('Progression of transition matrices with absorbing states')
xlabel('Press any key')
pause
for i=1:50:50000
    image(10*3*N*PP)
    title('Progression of transition matrices with absorbing states')
    PP=PP*A;
    pause(.001)
end
close(gcf)

%% Compute absorption probabilities and cluster based on partially labeled data

tic
MC=MarkovChain; % Initialize Markov chain object
MC=MC.initialize(A);
toc

AbsProbs=MC.B; % Assign matrix of absorption probabilities

figure('Position',[100,100,800,600])
if num_spirals==3
    plot(1:length(Unlabeled),AbsProbs(:,1),'red',...
        1:length(Unlabeled),AbsProbs(:,2),'green',...
        1:length(Unlabeled),AbsProbs(:,3),'blue')
    title('Absporption probabilities')
    legend('Group 1','Group 2','Group 3')
else
    plot(1:length(Unlabeled),AbsProbs(:,1),'red',...
        1:length(Unlabeled),AbsProbs(:,2),'green')
    title('Absporption times')
    legend('Group 1','Group 2')
end
axis([0,length(AbsProbs)+1,-.1,1.3])

[~,L]=max(AbsProbs'); % Identify absoprtion classes

if num_spirals==3
    Cmap=[[ones(n,1),zeros(n,2)];[zeros(n,1),ones(n,1),zeros(n,1)];...
        [zeros(n,2),ones(n,1)]];
else
    Cmap=[[ones(n,1),zeros(n,2)];[zeros(n,1),ones(n,1),zeros(n,1)]];
end

figure('Position',[100,100,1200,600])
subplot(1,2,1)
hold on
scatter(X(Unlabeled,1),X(Unlabeled,2),10,'black','filled')
scatter(X(Labeled,1),X(Labeled,2),25,Cmap(Labeled,:),'filled')
scatter(X(Labeled,1),X(Labeled,2),100,Cmap(Labeled,:))
axis([min(X(:,1))-.2,max(X(:,1))+.2,min(X(:,2))-.2,max(X(:,2))+.2])
title('Initial partially labeled data')
xlabel('Initially labeled points highlighted')

subplot(1,2,2)
hold on
if num_spirals==3
    scatter(X(Unlabeled,1),X(Unlabeled,2),10,AbsProbs,'filled')
else
    scatter(X(Unlabeled,1),X(Unlabeled,2),10,...
        [AbsProbs,zeros(length(Unlabeled),1)],'filled')
end
scatter(X(Labeled,1),X(Labeled,2),30,Cmap(Labeled,:),'filled')
axis([min(X(:,1))-.2,max(X(:,1))+.2,min(X(:,2))-.2,max(X(:,2))+.2])
title('Learned labels')
xlabel('Data labeled by absorption probability clustering')



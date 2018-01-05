% Author:   Jarod Hart
% Date:     January 5, 2018
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate an unsupervised clustering algorithm
% based on diffusion mapping and k-means.  The script generates 2 to 5 
% spirals in 2 dimensional Euclidean space, based on the num_spirals 
% parameter, and clusers the dataset into the spirals using k-means with k
% set to the specified number of spirals.  The script will work for more
% than 5 spirals with some minor modifications to account for the smaller
% local distance between points.

% Dependencies: GenerateK.m, DiffusionMap.m, MarkovChain.m

% Resources:  This was mentioned as an possible application in the 
% diffusion map paper by Coifman and Lafon.

%% Make dataset

addpath(genpath('../Diffusion Map'));
addpath(genpath('../../Markov Chains/Markov Chain Class'));
addpath(genpath('../../Clustering Algorithms/K-Means'));

num_spirals=3; % Number of spirals: set to 2, 3, 4, or 5. 
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
Kfun=@(x,y) exp(-55*sum(abs(x-y))); % Local similarity function
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

drawnow

%% k-means cluster diffusion coefficients, pull back to original dataset

colors={'blue','red','green','magenta','black','cyan','yellow'};
K=num_spirals;
[G,SSE]=kmeans(Psi(:,1:2),K,200);

figure('Position',[100,100,900,400])
subplot(1,2,1)
hold on
for i=1:K
    scatter(X(G==i,1),X(G==i,2),15,colors{i},'filled')
end
title('Learned clusters for original data set')
subplot(1,2,2)
hold on
for i=1:K
    scatter(Psi(G==i,1),Psi(G==i,2),15,colors{i},'filled')
end
title('Learned diffusion coefficient clusters')


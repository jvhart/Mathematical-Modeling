% Author:   Jarod Hart
% Date:     November 18, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the manifold learning capabilities of
% diffusion mapping with a "swiss cake roll" manifold, which is a very
% typical example.

% Dependencies: SCRfunc, GenerateK.m, DiffusionMap.m

% Resources:  This is a very typical example of a dataset to analyze for
% manifold learning problems, and it is included in several places in the
% literature on diffusion maps.

addpath(genpath('../Diffusion Map')) % Add file path for diffusion map functions

N=1500; % number of manifold sample points

S=rand(1,N); % sample from the domain [0,1]x[0,1]
T=rand(1,N);
[X,Y,Z]=SCRfunc(S,T); % map samples to swiss cake roll manifold
C=[T',zeros(N,1),1-T']; % define colomap according to domain variable T

Data=[X',Y',Z']; % concatinate manifold samples in dataset

figure
scatter3(X,Y,Z,15,C,'filled') % plot manifold samples

Kfun=@(x,y) exp(-sum(abs(x-y).^2)/10); % define local geometry similarity function
tic
K=GenerateK(Data,Kfun); % generate similarity matrix K
toc

m=4; % set number of target dimensions
tic
[Lambda,Psi,P] = DiffusionMap(K,m,0); % compute diffusion map
toc

% plot different combinations of embedded variables
figure('Position',[0,100,500,500])
scatter3(Lambda(1)^3*Psi(:,1),Lambda(2)^3*Psi(:,2),Lambda(3)^3*Psi(:,3),15,C,'filled')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_3')

figure('Position',[250,100,500,500])
scatter3(Psi(:,1),Psi(:,2),Psi(:,4),15,C,'filled')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_4')

figure('Position',[500,100,500,500])
scatter3(Psi(:,1),Psi(:,3),Psi(:,4),15,C,'filled')
xlabel('Psi_1')
ylabel('Psi_3')
zlabel('Psi_4')

figure('Position',[750,100,500,500])
scatter3(Psi(:,2),Psi(:,3),Psi(:,4),15,C,'filled')
xlabel('Psi_2')
ylabel('Psi_3')
zlabel('Psi_4')

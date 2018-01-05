% Author:   Jarod Hart
% Date:     December 11, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the manifold learning capabilities of
% diffusion mapping with a "dumbell" manifold.

% Dependencies: DBfunc, GenerateK.m, DiffusionMap.m

% Resources:  This is a very typical example of a dataset to analyze for
% manifold learning problems, and it is included in several places in the
% literature on diffusion maps.

% Note: See SwissCakeRoll.m script for a similar script the is commented
% more completely.

addpath(genpath('../Diffusion Map'))

N=1000; % number of manifold samples

S=rand(1,N);
T=rand(1,N);
[X,Y,Z]=DBfunc(S,T);
C=[T',zeros(N,1),1-T']; % colormap

Data=[X',Y',Z']; % manifold samples

figure
scatter3(X,Y,Z,15,C,'filled')

Kfun=@(x,y) exp(-sum((abs(x-y)).^2)); % local similarity
tic
K=GenerateK(Data,Kfun); % populate K matrix
toc

m=4;
tic
[Lambda,Psi,P] = DiffusionMap(K,m,1); % compute diffusion map
toc

% plots
figure('Position',[0,100,500,500])
scatter3(Psi(:,1),Psi(:,2),Psi(:,3),15,C,'filled')
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

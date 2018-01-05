% Author:   Jarod Hart
% Date:     December 14, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to give an example of how to use diffusion mapping in a
% sort of dimension reduction algorithm.  This script samples random
% patches of an image and uses a diffusion map to provide a visualization
% of them.

% Dependencies: GenerateK.m, DiffusionMap.m

% Resources:  

addpath(genpath('../Diffusion Map/')); % add path to functions

Im=imread('Pictures/Mountains.jpg'); % some images to choose from
% Im=imread('Pictures/Beach.jpg');
% Im=imread('Pictures/Chucky.jpg');
Im=double(Im)/256; % normalize image
[Xm,Xn,p]=size(Im); 

figure('Position',[100,100,800,600]) % show image
image(Im)
pause(.01)

n=50; % sqaure patch size
N=750; % number of samples from the image
X=[]; % initialize dataset
Images={}; % initialize structure object to store image patches
CMAP=[]; % initialize a colormap
for i=1:N % randomly sample N images
    i0=randi([1,Xm-n],1);
    j0=randi([1,Xn-n],1);
    Images{1}{i}=[i0,j0];
    Images{2}{i}=Im(i0:i0+n,j0:j0+n,:);
    X=[X;Images{2}{i}(:)'];
    CMAP=[CMAP;[sum(sum(Im(i0:i0+n,j0:j0+n,1)))/n^2,...
        sum(sum(Im(i0:i0+n,j0:j0+n,2)))/n^2,...
        sum(sum(Im(i0:i0+n,j0:j0+n,3)))/n^2]]; % assign the average color 
                                    % of the image patch to the colormap
end

m=4; % target dimension
Kfun=@(x,y) exp(-sum((x-y).^2)/n^2); % dimilarity function
tic
K=GenerateK(X,Kfun); % construct K matrix
toc
tic
[Lambda,Psi,P] = DiffusionMap(K,m,0); % compute diffusion map
toc

figure('Position',[200,200,1200,550])
subplot(1,2,1)
image(Im)
xlabel('Press any key')
subplot(1,2,2)
hold on
scatter3(Psi(:,1),Psi(:,2),Psi(:,3),25,CMAP,'filled')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_3')

samples=randsample(N,12)';

pause
for i=samples
    temp=Im;
    a=Images{1}{i}(1);
    b=Images{1}{i}(2);
    temp(a:a+n,b:b+n,1)=1;
    temp(a:a+n,b:b+n,2:3)=0;
    subplot(1,2,1)
    image(temp)
    subplot(1,2,2)
    cla
    scatter3(Psi(:,1),Psi(:,2),Psi(:,3),25,CMAP,'filled')
    plot3(Psi(i,1),Psi(i,2),Psi(i,3),'Color','r',...
            'Marker','o','MarkerSize',12)
    pause
end

subplot(1,2,1)
xlabel(' ')


figure('Position',[0,300,500,500])
scatter3(Psi(:,1),Psi(:,2),Psi(:,3),25,CMAP,'filled')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_3')

figure('Position',[250,300,500,500])
scatter3(Psi(:,1),Psi(:,2),Psi(:,4),25,CMAP,'filled')
xlabel('Psi_1')
ylabel('Psi_2')
zlabel('Psi_4')

figure('Position',[500,300,500,500])
scatter3(Psi(:,1),Psi(:,3),Psi(:,4),25,CMAP,'filled')
xlabel('Psi_1')
ylabel('Psi_3')
zlabel('Psi_4')

figure('Position',[750,300,500,500])
scatter3(Psi(:,2),Psi(:,3),Psi(:,4),25,CMAP,'filled')
xlabel('Psi_2')
ylabel('Psi_3')
zlabel('Psi_4')

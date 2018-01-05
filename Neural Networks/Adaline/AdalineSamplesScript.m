
% Author:   Jarod Hart
% Date:     November 20, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the capabilities of Adaline.  This
% generates two clusters of datat that are linearly separable, and learns a
% classification rule using the Perceptron.  A few ways to visualise this
% are provided.

% Dependencies: TrainAdaline.m, EvaluateAdaline.m

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

% Note: See PerceptronSamplesScript.m for similar code that is commented.

n1=50;
n2=20;
sigma1=.5;
sigma2=.5;
c1=[0,4];
c2=[3,3];

Data=[];

X=ones(n1,1)*c1+sigma1*randn(n1,2);
X=[X,ones(n1,1)];
Data=[Data;X];

X=ones(n2,1)*c2+sigma2*randn(n2,2);
X=[X,-ones(n2,1)];
Data=[Data;X];

eta=.25;
MaxEpoch=150;

tic
[W,Error] = TrainAdaline(Data,eta,MaxEpoch);
toc

[numepochs,~]=size(Error);

figure
hold on
axis([0,numepochs,0,max(Error)+.1])
plot(Error,'b')
plot(Error,'Marker','.','MarkerSize',8,'Color','b')
xlabel('Epochs')
ylabel('Squared error')
title('Adaline Training Squared Error Plot')

[T,n]=size(Data);
NumInputs=n-1;
group1=Data(:,3)==1;
group2=Data(:,3)==-1;

figure
hold on
axis([-3,6,-1,6])
scatter(Data(group1,1),Data(group1,2),'rx')
scatter(Data(group2,1),Data(group2,2),'bo')

[X,Y]=meshgrid(-3:.05:6,-1:.05:6);
[m,n]=size(X);
Z=zeros(m,n);
for i=1:m
    for j=1:n
        x=[X(i,j);Y(i,j)];
        Z(i,j)=EvaluateAdaline(x,W);
    end
end

contour(X,Y,Z,[-.001,.001],'green')


figure
hold on
axis([-3,6,-1,6])
surf(X,Y,Z,'mesh','none')
scatter3(Data(group1,1),Data(group1,2),Data(group1,3)+.1,'rx')
scatter3(Data(group2,1),Data(group2,2),Data(group2,3)-.1,'bo')


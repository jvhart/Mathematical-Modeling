% Author:   Jarod Hart
% Date:     November 20, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the failure of Adaline to classify data
% that is not linearly separable.  It generates an exclusive or problem 
% (XOR) problem amonst 4 clusters, and attempts to train Adaline with poor 
% results.

% Dependencies: TrainAdaline.m, EvaluateAdaline.m

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

% Note: See PerceptronSamplesScript.m for similar code that is commented.

n1=50;
n2=50;
n3=50;
n4=50;
sigma1=.25;
sigma2=.25;
sigma3=.25;
sigma4=.25;
c1=[1,1];
c2=[-1,-1];
c3=[1,-1];
c4=[-1,1];

Data=[];

X=ones(n1,1)*c1+sigma1*randn(n1,2);
X=[X,ones(n1,1)];
Data=[Data;X];

X=ones(n2,1)*c2+sigma2*randn(n2,2);
X=[X,ones(n2,1)];
Data=[Data;X];

X=ones(n3,1)*c3+sigma3*randn(n3,2);
X=[X,-ones(n3,1)];
Data=[Data;X];

X=ones(n4,1)*c4+sigma4*randn(n4,2);
X=[X,-ones(n4,1)];
Data=[Data;X];

eta=.25;
MaxEpoch=150;

tic
[W,Error] = TrainAdaline(Data,eta,MaxEpoch);
toc

[T,n]=size(Data);
NumInputs=n-1;
[epochs,~]=size(Error);
group1=Data(:,3)==1;
group2=Data(:,3)==-1;
figure
hold on
plot(Error,'b')
plot(Error,'Marker','.','MarkerSize',8,'Color','b')
axis([0,epochs,0,max(Error)+.1])

figure
hold on
axis([-3,3,-3,3])
scatter(Data(group1,1),Data(group1,2),'rx')
scatter(Data(group2,1),Data(group2,2),'bo')

[X,Y]=meshgrid(-3:.05:3,-3:.05:3);
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
axis([-3,3,-3,3])
surf(X,Y,Z,'mesh','none')
scatter3(Data(group1,1),Data(group1,2),Data(group1,3)+.1,'rx')
scatter3(Data(group2,1),Data(group2,2),Data(group2,3)-.1,'bo')

% Author:   Jarod Hart
% Date:     November 20, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the the capabilities of multilayer 
% feedforward neural networks.  In this script they solve the exclusive or
% (XOR) problem that the Perceptron and Adaline fail to solve.

% Dependencies: TrainML.m, EvaluateML.m

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

NumInputs=2; % number of inputs for network
HiddenLayers=[10]; % number of neurons in hidden layers
eta=.25;
MaxEpoch=300;

tic
[W,Error] = TrainML(Data,NumInputs,HiddenLayers,eta,MaxEpoch);
toc

[T,n]=size(Data);
[epochs,~]=size(Error);
group1=Data(:,3)==1;
group2=Data(:,3)==-1;
NumOutputs=n-NumInputs;
figure
hold on
PlotStringList={'b','r','k','g','m','c','y'};
for i=1:NumOutputs
    plot(Error(:,i),'Color',PlotStringList{1+mod(i-1,7)})
    plot(Error(:,i),'Marker','.','MarkerSize',6,...
           'Color',PlotStringList{1+mod(i-1,7)})
end
axis([0,epochs,0,max(max(Error))+.1])

figure
hold on
scatter(Data(group1,1),Data(group1,2),'rx')
scatter(Data(group2,1),Data(group2,2),'bo')

[X,Y]=meshgrid(-6:.05:6,-6:.05:6);
[m,n]=size(X);
NumHiddenLayers=length(HiddenLayers);
for i=1:m
    for j=1:n
        x=[X(i,j);Y(i,j)];
        Z(i,j)=EvaluateML(x,W);
    end
end

contour(X,Y,Z,[-.001,.001],'green')
axis([-6,6,-6,6])


figure
hold on
surf(X,Y,Z,'mesh','none')
scatter3(Data(group1,1),Data(group1,2),Data(group1,3)+.1,'rx')
scatter3(Data(group2,1),Data(group2,2),Data(group2,3)-.1,'bo')


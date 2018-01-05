% Author:   Jarod Hart
% Date:     November 20, 2017
% Description: This is a script file.  It can be run as is.  The purpose of
% this script is to demonstrate the the capabilities of multilayer 
% feedforward neural networks.  This script shows how to use multilayer
% feedforward neural network to approximate a function.  As the script is
% written ouputs of the function must lie between -1 and 1, but that is
% easily modified for a more general class of functions.

% Dependencies: TrainML.m, EvaluateML.m

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

% Note: See PerceptronSamplesScript.m for similar code that is commented.

f=@(x,y) x.*sin(pi*y/2)/4; % in-line function definition, function to be 
                           % approximated

[X,Y]=meshgrid(-2:.05:2,-2:.05:2); % plot the function
Z=f(X,Y);
figure
hold on
surf(X,Y,Z,'mesh','none')

Data=[];  % sample function as T points in the domain, and plot samples
T=150;
for t=1:T
    x=-2+4*rand(1,2);
    z=f(x(1),x(2));
    Data=[Data;[x,z]];
    plot3(x(1),x(2),z,'Color','b','Marker','.','MarkerSize',14)
end

NumInputs=2;
HiddenLayers=[40,40,40];

eta=.5;
MaxEpoch=500;
tic
[W,Error] = TrainML(Data,NumInputs,HiddenLayers,eta,MaxEpoch);
toc

[epochs,~]=size(Error);

[T,n]=size(Data);
NumOutputs=n-NumInputs;
figure
hold on
for i=1:NumOutputs
    plot(Error(:,i),'Color','b','Marker','.','MarkerSize',8)
end
axis([0,epochs,0,max(max(Error))+.1])


[X,Y]=meshgrid(-2:.05:2,-2:.05:2);

[m,n]=size(X);

NumHiddenLayers=length(HiddenLayers);
for i=1:m
    for j=1:n
        x=[X(i,j);Y(i,j)];
        y=W{1}*[x;1];
        a=tanh(y);
        for k=1:NumHiddenLayers
            y=W{k+1}*[a;1];
            a=tanh(y);
        end
        Z(i,j)=a;
    end
end

figure('Position',[200,200,900,450])
subplot(1,2,1)
surf(X,Y,f(X,Y),'mesh','none')
title('True Function')

subplot(1,2,2)
surf(X,Y,Z,'mesh','none')
title('ANN Approximation')

figure
hold on
for t=1:T
    plot3(Data(t,1),Data(t,2),Data(t,3),'Color','b',...
        'Marker','.','MarkerSize',14)
end
surf(X,Y,Z,'mesh','none')

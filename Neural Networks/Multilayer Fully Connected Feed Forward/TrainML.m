% Author:        Jarod Hart
% Date:          November 20, 2017
% Description:   This function takes input training data Data, and learns a
% several matrices of weight parameters W according to the multilayer 
% neural network training rule based off of stochastic gradient descent.
% In the end the function x --> f(x), where f is several compositions of
% functions of the form tanh(theta+w*[x';1]).

% Inputs:
%             X - training data; matrix. Each row of X should be of the 
%             form [x,l], where x is a row vector of real numbers and l is 
%             its label, a vector of real numbers between -1 and 1.
%             NumInputs - number of network inputs; positive integer
%             HiddenLayers - number of layers and hidden neurons; vector of
%             positive integers
%             eta - learning rate; small positive number.  If none is
%             specified, it is automatically set to .05.
%             MaxEpoch - maximum number of epochs for training; large
%             positive integer.  If none is specified, it is automatically
%             set to 200.
%             W - network weights; structure object of matrices of weights.
%             Optional input, if not enters, it is randomly selected.

% Outputs:
%             W - weights; structur object made of up matrices of weights.
%             These are the learned weights according to the multilayer ANN
%             rule based on stochastic gradient descent.

% Dependencies: none

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

% Note: See TrainAdaline.m for some similar coding elements that are better
% commented.

function [W,Error] = TrainML(X,NumInputs,HiddenLayers,eta,MaxEpoch,W)

if nargin<4
    eta=.05;
end
if nargin<5
    MaxEpoch=500;
end

convergethreshold=.0001; % hard set convergence threshold
errortolerance=.1; % error tolerance hard set

NumHiddenLayers=length(HiddenLayers); % vector of sizes of hidden layers
[T,n]=size(X);
NumOutputs=n-NumInputs;
Error=[];
epochs=0;
convergetest=1;

% Initialize weights: If weights are passed as inputs, they will be used.
% Otherwise they will be selected randomly.
if nargin<6
    W={};
    W{1}=rand(HiddenLayers(1),NumInputs+1)-.5;
    for i=1:NumHiddenLayers-1
        W{i+1}=rand(HiddenLayers(i+1),HiddenLayers(i)+1)-.5;
    end
    W{NumHiddenLayers+1}=rand(NumOutputs,HiddenLayers(NumHiddenLayers)+1)-.5;
end

batchsize=80;
batchstarts=batchsize+1:batchsize:T;
DELTA={}; % structure object tracking accumulated deltas for each layer

while convergetest>convergethreshold && epochs<MaxEpoch
    E=zeros(1,NumOutputs);
    S=randsample(T,T);
    for i=1:T
        x=X(S(i),1:end-NumOutputs)';
        label=X(S(i),end+1-NumOutputs:end)';
        y={};
        a={};
        aprime={};
        
        %%% Feedforward
        y{1}=W{1}*[x;1];
        a{1}=tanh(y{1});
        aprime{1}=sech(y{1}).^2;
        for j=1:NumHiddenLayers
            y{j+1}=W{j+1}*[a{j};1];
            a{j+1}=tanh(y{j+1});
            aprime{j+1}=sech(y{j+1}).^2;
        end
        
        %%% Backpropagation
        if i==1
            for j=1:length(W)
                DELTA{j}=zeros(size(W{j}));
            end
        end
        delta={};
        delta{1}=(label-a{end}).*aprime{end};
        
        DELTA{end}=DELTA{end}+eta*delta{1}*[a{end-1}',1]/T;
        count=1;
        for j=NumHiddenLayers:-1:2
            count=count+1;
            delta{count}=(W{j+1}(:,1:end-1)'*delta{count-1}).*aprime{j};
            DELTA{j}=DELTA{j}+eta*delta{count}*[a{j-1}',1]/T;
        end
        count=count+1;
        delta{count}=(W{2}(:,1:end-1)'*delta{count-1}).*aprime{1};
        DELTA{1}=DELTA{1}+eta*delta{count}*[x',1]/T;
        
        if ismember(i,batchstarts)
            for j=1:length(W)
                W{j}=W{j}+DELTA{j};
                DELTA{j}=DELTA{j}*0;
            end
        end
        
        for j=1:NumOutputs
            E(j)=E(j)+(label(j)-a{end}(j))^2; % Update epoch errors
        end
    end
    
    E=E/T; 
    Error=[Error;E]; % Record average epoch error
    epochs=epochs+1;
    
    if epochs<32
        convergetest=1;
    else
        convergetest=sum(sum(abs(Error(end-30:end,:)...
                 -Error(end-31:end-1,:))))/(30*NumOutputs);
        
        if sum(E)>errortolerance && convergetest<convergethreshold
            W={};
            W{1}=rand(HiddenLayers(1),NumInputs+1)-.5;
            for i=1:NumHiddenLayers-1
                W{i+1}=rand(HiddenLayers(i+1),HiddenLayers(i)+1)-.5;
            end
            W{NumHiddenLayers+1}=rand(NumOutputs,HiddenLayers(NumHiddenLayers)+1)-.5;
            convergetest=1;
        end
    end
end



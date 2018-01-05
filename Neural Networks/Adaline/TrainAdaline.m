% Author:        Jarod Hart
% Date:          November 20, 2017
% Description:   This function takes input training data Data, and learns a
% vector of weight parameters W according to the Adaline training rule.
% In the end the function x --> tanh(W*[x',1]) will attempt to classify x
% in one of two classes +-1.

% Inputs:
%             X - training data; matrix. Each row of X should be of the 
%             form [x,l], where x is a row vector of real numbers and l is 
%             its label, either +-1.
%             eta - learning rate; small positive number.  If none is
%             specified, it is automatically set to .05.
%             MaxEpoch - maximum number of epochs for training; large
%             positive integer.  If none is specified, it is automatically
%             set to 200.

% Outputs:
%             W - weight; vector of real numbers.  These are the learned
%             weights according to the Adaline learning rule based on
%             stochastic gradient descent.

% Dependencies: none

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

function [W,Error] = TrainAdaline(Data,eta,MaxEpoch)

if nargin<2
    eta=.05;
end

if nargin<3
    MaxEpoch=200;
end

convergethreshold=.01;   % a convergence threshold is hard set here. If the
                         % average error over the last 30 epochs is smaller
                         % than convergethreshold, we determine that the
                         % training has converged and exit training. If the
errortolerance=.1;       % error tolerance is not met, the weights are
                         % reinitialized and training resumes.

[T,n]=size(Data);
NumInputs=n-1;
Error=[];
epochs=0;
movingavgerror=1;
W=rand(1,NumInputs+1)-.5;

batchsize=15;   % batch size for stochastic gradient descent hard set to 15
batchstarts=batchsize+1:batchsize:T; % locations of batch starts
DELTA=zeros(size(W)); % accumulated deltas for stochastic gradient descent 
                      % batch

while movingavgerror>convergethreshold && epochs<MaxEpoch
    E=0;  % initialize error
    S=randsample(T,T); % radomize order to select training data
    for i=1:T  % loop through training data
        x=Data(S(i),1:end-1)';  % extract training element x
        label=Data(S(i),end);   % extract label associated to x
        
        %%% Feedforward
        y=W*[x;1];
        a=tanh(y);
        aprime=sech(y).^2;
        
        %%% Backpropagate
        delta=(label-a).*aprime;
        
        DELTA=DELTA+eta*delta*[x',1]/T;  % aggregate delta for stochastic 
                                         % gradient descent batch
        if ismember(i,batchstarts)  % if i is at the start of a new batch, 
            W=W+DELTA;              % update W and reinitialize DELTA.
            DELTA=zeros(size(W));
        end
        E=E+(label-a)^2/T;  % Update epoch errors
    end

    Error=[Error;E];  % Record average epoch error
    epochs=epochs+1;  % update epoch count
    
    %%% Convergence test
    if epochs<32  % don't test for first 32 epochs
        movingavgerror=1;
    else  % compute moving average of errors
        movingavgerror=sum(sum(abs(Error(end-30:end,:)...
                 -Error(end-31:end-1,:))))/30;
        % If convergence criterion is passed, but error is unacceptable
        % the weights are reinitialized and training continues.
        if sum(E)>errortolerance && movingavgerror<convergethreshold
            W=rand(1,NumInputs+1)-.5;
            movingavgerror=1;
        end
    end
end



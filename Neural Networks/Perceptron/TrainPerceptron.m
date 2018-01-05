% Author:        Jarod Hart
% Date:          November 20, 2017
% Description:   This function takes input training data Data, and learns a
% vector of weight parameters W according to the Perceptron training rule.
% In the end the function x --> sign(W*[x',1]) will attempt to classify x
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
%             weights according to the Perceptron learning rule.

% Dependencies: none

% Resources:  Two possible resources are:
%       Mitchell, Machine Learning, McGraw-Hill, 1997. See chpt 4.
%       Krone and van der Smart, An Introduction to Neural Networks, Eighth
%         Edition, University of Amsterdam, 1996. Available at archive.org

function W = TrainPerceptron(Data,eta,MaxEpoch)

%%% if fewer than 2 inputs are given, set eta=.05
if nargin<2
    eta=.05;
end

%%% if fewer than 3 inputs are given, set MaxEpoch=.05
if nargin<3
    MaxEpoch=200;
end

[T,n]=size(Data);    % read size of training data
NumInputs=n-1;       % number of inputs is one less than number of columns
convergetest=true;   % initialize training convergence test boolean

W=rand(1,NumInputs+1)-.5;
W=W/sum(abs(W));     % initialize weight vector
epochs=0;            % initialize epoch count

% until MaxEpoch or convergence is reached
while convergetest && epochs<MaxEpoch
    convergetest=true;  % initialize convergence test
    S=randsample(T,T);  % randomly select a permutation of 1,2,..,T
    for i=1:T           % loop through all training data
        x=Data(S(i),1:end-1)';  % extract data point from X
        label=Data(S(i),end);   % extract label corresponding to x
        y=W*[x;1];              % feed x through network
        if y*label<0            % if x is missclassified, update weight and
                                % convergencetest.
            W=W+eta*(label-y)*[x',1];
            convergetest=false; % if all x are classified correctly, 
                                % convergence is achieved.
        end
    end
    W=W/sum(abs(W));   % renormalize weights. this avoids overflow, while 
                       % not affecting the decision rule.  It also keeps
                       % the appropriate scale of eta relative to the
                       % weights
    epochs=epochs+1;   % update number of epochs
end



% Author:        Jarod Hart
% Date:          January 3, 2018
% Description:   This function makes the transition matrix for various
% types of finite random walks. There are four options for random walks,
% absorbing, reflecting, semi-reflecting, and circle.

% Inputs:
%             n - integer, number of states in random walk
%             p - real number between 0 and 1, probability of moving right
%             type - string, type of random walk, choose from 'absorbing',
%                    'reflecting', 'semi-reflecting', and 'circle'

% Outputs:
%             P - n by n transition matrix (rows sum to 1)

% Dependencies: none

function [P] = MakeRandomWalkMatrix(n,p,type)

if nargin<3
    type='absorbing';
end
if nargin<2
    p=.5;
end

P=zeros(n,n); % populate the interior of the transition matrix
P(2:end-1,1:end-2)=(1-p)*eye(n-2);
P(2:end-1,3:end)=P(2:end-1,3:end)+p*eye(n-2);

if strcmp(type,'absorbing') % set the boundary behavior based on type
    P(1,1)=1;
    P(n,n)=1;
elseif strcmp(type,'reflecting')
    P(1,2)=1;
    P(n,n-1)=1;
elseif strcmp(type,'semi-reflecting')
    P(1,1)=1-p;
    P(1,2)=p;
    P(n,n-1)=1-p;
    P(n,n)=p;
elseif strcmp(type,'circle')
    P(1,n)=1-p;
    P(1,2)=p;
    P(n,n-1)=1-p;
    P(n,1)=p;
else
    'Error: type not recognized.'
end


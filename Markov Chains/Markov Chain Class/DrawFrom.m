% Author:        Jarod Hart
% Date:          November 19, 2017
% Description:   This function draws from a discrete probability
% distribution d on the integers 1..length(d).  s and t are parameters that
% determine how many random observations are drawn, and what size theiry.

% Inputs:
%             d - probability distribution (non-negative, sum to 1)
%             s - size of output, can be an integer or array of integers
%             t - an integer, accepted only when s is also an integer

% Outputs:
%             x - integer or array of integers drawn randomly from d

% Dependencies: None

function [x] = DrawFrom(d,s,t)

if nargin<2
    s=1;
elseif nargin>2
    s=[s,t];
elseif length(s)==1
    s=[1,s];
end

n=length(d);
F=zeros(1,n);
F(1)=d(1);
for i=2:n
    F(i)=F(i-1)+d(i);
end

r=rand(s);
x=ones(s);
for i=1:n-1
    x(r>F(i))=i+1;
end


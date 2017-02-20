clear all
clc

% Data provided
age = linspace(1, 9, 9);
birds = [77, 149, 182, 118, 78, 46, 27, 10, 4];
survive = [35, 89, 130, 79, 52, 28, 14, 3, 1];
dead = birds - survive;

% Create a data matrix with first column for the dummy variable y=1(bird
% survives) and second column for the age
X = nan(sum(birds),2);
X(1:survive(1),:) = repmat([1, age(1)], survive(1), 1);
X(sum(survive(:))+1:sum(survive(:))+dead(1),:) = repmat([0,age(1)], dead(1), 1);

for i=2:length(survive)
from1 = sum(survive(1:i-1))+1;
to1   = sum(survive(1:i-1))+survive(i);
from2 = sum(survive(:))+sum(dead(1:i-1))+1;
to2   = sum(survive(:))+sum(dead(1:i-1))+dead(i);

X(from1:to1,:) = repmat([1,i],survive(i),1);
X(from2:to2,:) = repmat([0,i],dead(i),1);
end
clear from1 from2 to1 to2 i

% Parameters
theta.unres = [-0.587; 0.635; -0.071];

expp.unres = exp(theta.unres(1) + theta.unres(2)*X(:, 2) + theta.unres(3)*X(:,2).^2);
H.unres = [-sum(              expp.unres ./(1 + expp.unres).^2), ...
     -sum((X(:,2).*     expp.unres)./(1 + expp.unres).^2), ...
     -sum(((X(:,2).^2).*expp.unres)./(1 + expp.unres).^2); ...
     -sum((X(:,2).*     expp.unres)./(1 + expp.unres).^2), ...
     -sum(((X(:,2).^2).*expp.unres)./(1 + expp.unres).^2), ...
     -sum(((X(:,2).^3).*expp.unres)./(1 + expp.unres).^2);...
     -sum(((X(:,2).^2).*expp.unres)./(1 + expp.unres).^2), ...
     -sum(((X(:,2).^3).*expp.unres)./(1 + expp.unres).^2), ...
     -sum(((X(:,2).^4).*expp.unres)./(1 + expp.unres).^2)];
VCV.unres = -inv(H.unres);

LL.unres = sum(X(:,1).*log(expp.unres)-log(1+expp.unres));

%% Test beta = 2

% Wald test
beta = 2;
W.beta = ((theta.unres(2) - beta)^2)/VCV.unres(2,2);
c = chi2inv(0.95,1);
if W.beta > c
    disp(['Wald: Reject the null H0: beta = ', num2str(beta), ...
        ' with 95% conf.level'])
else
    disp(['Wald: Fail to reject the null H0: beta = ', num2str(beta), ...
        ' with 95% conf.level'])
end

% LM test
theta.res = [-2.904; 2; -0.229];
expp.res = exp(theta.res(1) + theta.res(2)*X(:, 2) + theta.res(3)*X(:,2).^2);
H.res = [   -sum(              expp.res ./(1 + expp.res).^2), ...
            -sum((X(:,2).*     expp.res)./(1 + expp.res).^2), ...
            -sum(((X(:,2).^2).*expp.res)./(1 + expp.res).^2); ...
            -sum((X(:,2).*     expp.res)./(1 + expp.res).^2), ...
            -sum(((X(:,2).^2).*expp.res)./(1 + expp.res).^2), ...
            -sum(((X(:,2).^3).*expp.res)./(1 + expp.res).^2); ...
            -sum(((X(:,2).^2).*expp.res)./(1 + expp.res).^2), ...
            -sum(((X(:,2).^3).*expp.res)./(1 + expp.res).^2), ...
            -sum(((X(:,2).^4).*expp.res)./(1 + expp.res).^2)];
VCV.res = -inv(H.res);

score.LM(1) = sum(X(:,1)) - sum((expp.res)./(1 + expp.res));
score.LM(2) = sum(X(:,1).*X(:,2)) - sum((X(:,2).*expp.res)./(1 + expp.res));
score.LM(3) = sum(X(:,1).*(X(:,2).^2)) - sum(((X(:,2).^2).*expp.res)./(1 + expp.res));

LM.beta = score.LM*VCV.res*score.LM';
if LM.beta > c
    disp(['LM: Reject the null H0: beta = ', num2str(beta), ...
        ' with 95% conf.level'])
else
    disp(['LM: Fail to reject the null H0: beta = ', num2str(beta), ...
        ' with 95% conf.level'])
end

% LR test
LL.res = sum(X(:,1).*log(expp.res)-log(1+expp.res));
LR.beta = 2*(LL.unres - LL.res);
if LR.beta > c
    disp(['LR: Reject the null H0: beta = ', num2str(beta), ...
        ' with 95% conf.level'])
else
    disp(['LR: Fail to reject the null H0: beta = ', num2str(beta), ...
        ' with 95% conf.level'])
end

%% Test beta*gamma = 1/20

% Wald test
beta_gamma = 1/20;
W.bg = ((theta.unres(2)*theta.unres(3) - beta_gamma)^2)/...
    ([0, theta.unres(3), theta.unres(2)]*VCV.unres...
    *[0; theta.unres(3); theta.unres(2)]);
c = chi2inv(0.95,1);
if W.bg > c
    disp(['Wald: Reject the null H0: beta*gamma = ', num2str(beta_gamma), ...
        ' with 95% conf.level'])
else
    disp(['Wald: Fail to reject the null H0: beta*gamma = ', ...
        num2str(beta_gamma), ' with 95% conf.level'])
end

% LM test
theta.resbg = [-2.188; 0.06294; beta_gamma/0.06294];
expp.resbg = exp(theta.resbg(1) + theta.resbg(2)*X(:, 2) + theta.resbg(3)*X(:,2).^2);
H.resbg = [ -sum(              expp.resbg ./(1 + expp.resbg).^2), ...
            -sum((X(:,2).*     expp.resbg)./(1 + expp.resbg).^2), ...
            -sum(((X(:,2).^2).*expp.resbg)./(1 + expp.resbg).^2); ...
            -sum((X(:,2).*     expp.resbg)./(1 + expp.resbg).^2), ...
            -sum(((X(:,2).^2).*expp.resbg)./(1 + expp.resbg).^2), ...
            -sum(((X(:,2).^3).*expp.resbg)./(1 + expp.resbg).^2); ...
            -sum(((X(:,2).^2).*expp.resbg)./(1 + expp.resbg).^2), ...
            -sum(((X(:,2).^3).*expp.resbg)./(1 + expp.resbg).^2), ...
            -sum(((X(:,2).^4).*expp.resbg)./(1 + expp.resbg).^2)];
VCV.resbg = -inv(H.resbg);

score.LMbg(1) = sum(X(:,1)) - sum((expp.resbg)./(1 + expp.resbg));
score.LMbg(2) = sum(X(:,1).*X(:,2)) - sum((X(:,2).*expp.resbg)./(1 + expp.resbg));
score.LMbg(3) = sum(X(:,1).*(X(:,2).^2)) - sum(((X(:,2).^2).*expp.resbg)./(1 + expp.resbg));

LM.bg = score.LMbg*VCV.resbg*score.LMbg';
if LM.bg > c
    disp(['LM: Reject the null H0: beta*gamma = ', num2str(beta_gamma), ...
        ' with 95% conf.level'])
else
    disp(['LM: Fail to reject the null H0: beta*gamma = ', num2str(beta_gamma), ...
        ' with 95% conf.level'])
end

% LR test
% LL.resbg = sum(X(:,1).*log(expp.resbg)-log(1+expp.resbg));
LL.resbg = -678;
LR.bg = 2*(LL.unres - LL.resbg);
if LR.bg > c
    disp(['LR: Reject the null H0: beta*gamma = ', num2str(beta_gamma), ...
        ' with 95% conf.level'])
else
    disp(['LR: Fail to reject the null H0: beta*gamma = ', num2str(beta_gamma), ...
        ' with 95% conf.level'])
end
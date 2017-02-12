<<<<<<< HEAD
%% Problem Set 1

clear all
clc

%% Exercise 1

% Parameters
N = 10000;      % number of grid points
beta_min = 0;   % lower bound for beta (from Weibull distribution)
beta_max = 10; % upper bound for beta (chosen arbitrary here)
% Data
X = [2.3043;    2.1227;     4.6454;     1.29965;    2.0878;     2.2742; 
     2.2797;    2.2357;     1.33453;    1.47615;    1.32556;    3.007;
     1.49254;   3.0296;     1.15344;    1.26423;    2.9461;     2.4019;
     1.9608;    1.96381];
n = length(X);  % number of observations

% Discretize the space for beta
beta = linspace(beta_min, beta_max, N);

% Obtain values of FOC at different betas
W = zeros(1, N);
for i = 1:N
    W(i) = n/beta(i) + sum(log(X)) - n/sum(X.^beta(i))*sum(X.^beta(i).*log(X));
end

[W_opt, W_ind] = min(abs(W));
beta_opt = beta(W_ind);
alpha_opt = n/sum(X.^beta(W_ind));

% Var-covar matrix
H = [-n/alpha_opt^2,            -sum(X.^beta_opt.*log(X));
    -sum(X.^beta_opt.*log(X)),  -n/beta_opt^2 - alpha_opt*sum(X.^beta_opt.*(log(X).^2))];
VCV = -inv(H);

% 95% CI for estimators
alpha_ci = alpha_opt + norminv([0.025 0.975],0,1)*sqrt(VCV(1,1));
beta_ci = beta_opt + norminv([0.025 0.975],0,1)*sqrt(VCV(2,2));
disp(['95% CI for alpha: [',num2str(alpha_ci(1)),', ',num2str(alpha_ci(2)),']'])
disp(['95% CI for alpha: [',num2str(beta_ci(1)),', ',num2str(beta_ci(2)),']'])
=======
%% Problem Set 1

clear all
clc

%% Exercise 1

% Parameters
N = 10000;      % number of grid points
beta_min = 0;   % lower bound for beta (from Weibull distribution)
beta_max = 10; % upper bound for beta (chosen arbitrary here)
% Data
X = [2.3043;    2.1227;     4.6454;     1.29965;    2.0878;     2.2742; 
     2.2797;    2.2357;     1.33453;    1.47615;    1.32556;    3.007;
     1.49254;   3.0296;     1.15344;    1.26423;    2.9461;     2.4019;
     1.9608;    1.96381];
n = length(X);  % number of observations

% Discretize the space for beta
beta = linspace(beta_min, beta_max, N);

% Obtain values of FOC at different betas
W = zeros(1, N);
for i = 1:N
    W(i) = n/beta(i) + sum(log(X)) - n/sum(X.^beta(i))*sum(X.^beta(i).*log(X));
end

[W_opt, W_ind] = min(abs(W));
beta_opt = beta(W_ind);
alpha_opt = n/sum(X.^beta(W_ind));

% Var-covar matrix
H = [-n/alpha_opt^2,            -sum(X.^beta_opt.*log(X));
    -sum(X.^beta_opt.*log(X)),  -n/beta_opt^2 - alpha_opt*sum(X.^beta_opt.*(log(X).^2))];
VCV = -inv(H);

% 95% CI for estimators
alpha_ci = alpha_opt + norminv([0.025 0.975],0,1)*sqrt(VCV(1,1));
beta_ci = beta_opt + norminv([0.025 0.975],0,1)*sqrt(VCV(2,2));
disp(['95% CI for alpha: [',num2str(alpha_ci(1)),', ',num2str(alpha_ci(2)),']'])
disp(['95% CI for alpha: [',num2str(beta_ci(1)),', ',num2str(beta_ci(2)),']'])
>>>>>>> origin/master

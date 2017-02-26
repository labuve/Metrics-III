%% Problem Set 4
% Nurfatima Jandarova

clear all
clc

%% Exercise 1
% Data
Y = [3.8396, 8.023, 13.067, 0, 7.2040, 5.7971, 4.3211, 8.1021, ...
     0, 7.0828, 0, 0, 0, 0, 8.6801, 1.2526, 4.4132, 0.8026, 5.4571, 5.6016];

% Parameters
Ypmean = mean(Y(Y~=0));
Yp2mean = mean(Y(Y~=0).^2);
n0 = length(Y(Y==0));
n = length(Y);

% Estimators
theta = fsolve(@(t) t*(Ypmean^2 - Yp2mean)/Ypmean - ...
    (n0/(n - n0))*normpdf(t*Yp2mean/Ypmean, 0, 1)/...
    (1 - normcdf(t*Yp2mean/Ypmean, 0, 1)), 0);
gamma = theta*Yp2mean/Ypmean;

sigma = 1/theta;
mu = gamma/theta;

% Display results
disp(['theta = ', num2str(theta),' and gamma = ', num2str(gamma)])
disp(['mu = ', num2str(mu),' and sigma = ', num2str(sigma)])
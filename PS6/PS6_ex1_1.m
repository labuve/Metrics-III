%% Problem Set 6
% Nurfatima Jandarova
clear all
clc

%% Exercise 1.1    Feasible GLS

n = 20;         % sample size
y1_id = 1;      % place of y1 in matrix of sample moments
y2_id = 2;      % place of y2 in matrix of sample moments
x1_id = 3;      % place of x1 in matrix of sample moments
x2_id = 4;      % place of x2 in matrix of sample moments

% Matrix of sample moments
smom = [20,     6,      4,      3;
        6,      10,     3,      6;
        4,      3,      5,      2;
        3,      6,      2,      10];

% OLS estimates
beta_1 = smom(y1_id, x1_id)/smom(x1_id, x1_id);
beta_2 = smom(y2_id, x2_id)/smom(x2_id, x2_id);
beta_OLS = [beta_1, beta_2];

% Estimate of error term's variance
s_1 = n/(n-1)*(smom(y1_id, y1_id) - 2*beta_1*smom(y1_id, x1_id) + ...
                   (beta_1^2)*smom(x1_id,x1_id));
s_2 = n/(n-1)*(smom(y2_id, y2_id) - 2*beta_2*smom(y2_id, x2_id) + ...
                   (beta_2^2)*smom(x2_id,x2_id));
               
% Sampling variances of OLS estimates
bse_1 = s_1/(n*smom(x1_id, x1_id));
bse_2 = s_2/(n*smom(x2_id, x2_id));

% Goodness-of-fit measures
R1 = 1 - (s_1*(n-1)/n)/(smom(y1_id, y1_id));
R2 = 1 - (s_2*(n-1)/n)/(smom(y2_id, y2_id));

% Sample error covariance
s_12 = n/(n-1)*(smom(y1_id, y2_id) - smom(y1_id, x2_id)*beta_2 - ...
        smom(x1_id, y2_id)*beta_1 + beta_1*beta_2*smom(x1_id, x2_id));
    
% Weight matrix
Ommega = [s_1, s_12; s_12, s_2];
Ommega_inv = 1/(s_1*s_2 - s_12^2)*[s_2, -s_12; -s_12, s_1];

% FGLS estimator
beta_FGLS = (Ommega_inv(1,1)*smom(x1_id, y1_id) + Ommega_inv(1,2)*smom(x1_id, y2_id) + ...
    Ommega_inv(1,2)*smom(x2_id, y1_id) + Ommega_inv(2,2)*smom(x2_id, y2_id))/...
    (Ommega_inv(1,1)*smom(x1_id, x1_id) + 2*Ommega_inv(1,2)*smom(x1_id, x2_id) + ...
    Ommega_inv(2,2)*smom(x2_id, x2_id));
bs_FGLS = 1/(n*(Ommega_inv(1,1)*smom(x1_id, x1_id) + 2*Ommega_inv(1,2)*smom(x1_id, x2_id) + ...
    Ommega_inv(2,2)*smom(x2_id, x2_id)));

% Test the hypothesis beta = 1
t = (beta_FGLS - 1)/sqrt(bs_FGLS);

% Test equal variances
p = 0.95;
LM = n/2*(Ommega(2,2)/Ommega(1,1) - 1)^2;
xcv = chi2inv(p, 1);

if LM < xcv
    disp(['Fail to reject the null H0: sigma_1 = sigma_2 at ', ...
        num2str(p*100),'% confidence level'])
else
    disp(['Reject the null H0: sigma_1 = sigma_2 at ', ...
        num2str(p*100),'% confidence level'])
end
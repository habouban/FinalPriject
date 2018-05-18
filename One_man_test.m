clear

%% Step 0: Loading Data

%N = %-- Number of trials per each patient

data = load('S001R01_edfm.mat');
%this data refers to one man- HOW do i devide this data into trials?


 
%%
Covs = {};

            mX          = data; %we would like to take cov
            Covs = cov(mX');           %-- Extract the covariance of each trail.
       
        
  
D    = size(Covs);

%% Step 1: taking average of all trials for each patient:

Means = {}; 

Means{pp} = RiemannianMean(cat(3, Covs{pp,:}));

%% Step 3: taking average of averages
mTotalMean = RiemannianMean(cat(3, Means{:}));

%% Step 4: defining Ei
mSR = mTotalMean^(-1 / 2);
mW  = sqrt(2) * ones(D) - (sqrt(2) - 1) * eye(D);

for pp = 1 : P
    E = mSR * ( mTotalMean / Means{pp} )^(1/2);
    
    for nn = 1 : N
        G         = E * Covs{pp,nn} * E';
        mLogG     = logm(G) .* mW;
        mX{pp,nn} = mLogG( triu(true(size(mLogG))) );
    end
    
end    

%% Diffusion Maps:
mW  = squareform( pdist(mX') );
eps = median(mW(:));
mK  = exp(-mW.^2 / eps^2);
mA  = mK ./ sum(mK, 2);

[mPhi, mLam] = eig(mA);

%% Plot:
figure; hold on; grid on; set(gca, 'FontSize', 16);
title('Diffusion Maps using Covarianes and Riemannian Metric')
scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, vY, 'Fill');


% %% End Script
% function Covs = GetData()
%     for kk = 1 : 3
%         %-- recieve data per patient and devide it to matrices of each trial
%         
%         for ii = 1 : 4  %choose trial
%             mX          = 'single_trial_dataMatrix'; %we would like to take cov
%             Covs{kk,ii} = cov(mX');           %-- Extract the covariance of each trail.
%         end
%         
%     end
% end

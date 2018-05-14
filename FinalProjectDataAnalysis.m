clear all;

%%Step 0: Loading Data

%P = %-- Number of patients

%N = %-- Number of trials per each patient



for k = 1:P
        
%recieve data per patient and devide it to matrices of each trial

    for i = 1 : N  %choose trial
        
        mX(i) = 'single_trial_dataMatrix'; %we would like to take cov 
        
        Covs(:,:,i) = cov(mX(i)');           %-- Extract the covariance of each trail.
        
        organize_covs = cat(3,Covs(:,:,i)); %organizes the cov natrices of the current patient

    end
end
%%
%Step 2: taking average of all trials for each patient:

ave_per_patient = {};

mCSR= {};%for atep 4

for j=1:P

ave_per_patient(j) = RiemannianMean(?);

    mCSR(j)            = (ave_per_patient(j))^(-1/2);


end

%%
%Step 3: taking average of averages

Total_ave = RiemannianMean();

%%
%Step 4: defining Ei

E={};
G={};
after_log = {};
for l = 1:P
    E(l)= (Total_ave*inv(ave_per_patient(l)))^0.5;
    G(l) = E(l)* Covs(:,:,l)*E(l)'
    after_log(l) = logm((mCSR(l)*G(l)*mCSR));
end    

%% Project Covariances to Tangent Plane:
mX = CovsToVecs(?); %-- mX can be used as data in euclidean space (PCA, TSNE, Diffuion Maps, etc...)

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


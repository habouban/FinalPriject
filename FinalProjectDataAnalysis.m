clear

%% Step 0: Loading Data

P = 10; %-- Number of patients
N = 14; %-- Number of trials per each patient

[Covs, labels_matrix,specific_motion_matrix] = GetData(P, N);

D    = size(Covs{1}, 1);
vY   = nan(N*P, 1);

%% Step 1: taking average of all trials for each patient:

Means = {}; %for step 4

for pp = 1 : P
    Means{pp} = RiemannianMean(cat(3, Covs{pp,:}));
end

%% Step 2: taking average of averages
mTotalMean = RiemannianMean(cat(3, Means{:}));

%% Step 3: defining Ei
mSR = mTotalMean^(-1 / 2);

mW  = sqrt(2) * ones(D) - (sqrt(2) - 1) * eye(D);

dd =1 ;

mXt0Vec = [];


for pp = 1 : P
    E = mSR * ( mTotalMean / Means{pp} )^(1/2);
    
    for nn = 1 : N
        G         = E * Covs{pp,nn} * E';
        mLogG     = logm(G) .* mW;
        
        
        if true(size(mLogG))
            mX{pp,nn} = triu(mLogG);
        end
        
               mX{pp,nn} = mLogG(triu(true(size(mLogG))));
               
            

         vY(dd)       = pp; 
         dd=dd+1;
         

    end
    
end    

 mXt0Vec = cell2mat(reshape(mX,[1,pp*nn]));


%% Diffusion Maps:
mW  = squareform( pdist(mXt0Vec') );
eps =1000* median(mW(:));
mK  = exp(-mW.^2 / eps^2);
mA  = mK ./ sum(mK, 2);
[mPhi, mLam] = eig(mA);

exp_type_col = labels_matrix(:);

motion_type = specific_motion_matrix(:);


%% Plot:
figure; hold on; grid on; set(gca, 'FontSize', 16);
title('Diffusion Maps using Covarianes and Riemannian Metric')
scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, exp_type_col ,'diamond', 'Fill');

%scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, vY ,'diamond', 'Fill');

%scatter3(mPhi(:,2), mPhi(:,3), mPhi(:,4), 100, motion_type ,'diamond', 'Fill');

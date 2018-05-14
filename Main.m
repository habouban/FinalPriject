%% Generate Data:
C = 5;   %-- Number of Classes
N = 100; %-- Number of trials per class
D = 10;  %-- Dimension of each class

Covs = nan(D, D, N*C);
vY   = nan(N*C, 1);
kk   = 1;
for cc = 1 : C
    Ac = randn(D, D) + cc / 10 * eye(D); %-- Random covariance for each class
    for nn = 1 : N
        mX           = Ac * randn(D, D^2); %-- Generate random data (with Covariance Ac*Ac')
        Covs(:,:,kk) = cov(mX');           %-- Extract the covariance of each trail.
        vY(kk)       = cc;                 %-- True Class
        kk           = kk + 1;
    end
end

%% PT: EPE^T
%...

%% Project Covariances to Tangent Plane:
mX = CovsToVecs(Covs); %-- mX can be used as data in euclidean space (PCA, TSNE, Diffuion Maps, etc...)

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


%%
mX = randn(2, 100, 20);
vY = randi(3, 100, 20);

figure;
mColor = jet(3);
for ii = 1 : 20
%     scatter(mX(1,:,ii), mX(2,:,ii), 100, vY(:,ii), 'Fill');
%     colorbar('XTick', 1:3, 'XTickLabel', {'A', 'B', 'C'});
    for kk = 1 : 3
        vIdx = vY(:,ii) == kk;
        plot(mX(1,vIdx,ii), mX(2,vIdx,ii), '.', 'Color', mColor(kk,:), 'MarkerSize', 50); hold on;
    end
    legend('A', 'B', 'C');
    title(num2str(ii));
    hold off;
    
    
    
    a = 1
%     keyboard;
end

%%
N   = 500;
mX1 = randn(2, N) - 1;
mX2 = randn(2, N) + 1;
mX  = [mX1, mX2];
vY  = [1 * ones(1, N), 2 * ones(1, N)];

Data = [vY;
        mX];
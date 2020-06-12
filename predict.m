idx = 16;
x = xAbs(idx,:,:,:);
x = reshape(x,[],646);

y  = x*thetaML ;
% y = reshape(y,216,162);
y = reshape(y,height,width);

subplot(3,3,1);
imagesc(squeeze(trainX(idx,:,:,:)));
set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
axis equal;
subplot(2,3,2);
imagesc(squeeze(trainY(idx,:,:)));
set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
axis equal;
subplot(2,3,3);
imagesc(squeeze(y));
set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
axis equal;
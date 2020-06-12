%% Clear variables
clear
imgDir = strcat(pwd, '/Train400Img/');
depthDir = strcat(pwd, '/Train400Depth/');
batchSize = 20;
height = 12*9;
width = 9*9;
originalImgHeight = 24*9*2;
originalImgWidth = 18*9*2;

%% Generate features

% Uncomment to generate features for training set
% and save to disk. This takes about an hour and
% generates 14GB with the Make3D training set (with
% the above parameters). Set the second parameter
% to one to delete current files and make new ones
% in data folder.
% genFeaturesRowBatch(50, 0);


%% Train theta row-by-row

thetaML = trainRows(height);

%% Save params to file

if ~exist('model', 'dir')
  mkdir('model');
end
save([pwd '/model/thetaML.mat'], 'thetaML');

%% Load test data

[trainX,trainY] = loadTrainingData(...
  imgDir,depthDir,10,0,height,width,...
  originalImgHeight,originalImgWidth);

[xAbs,xRel] = genFeatures(trainX, height, width);
Y = upperScaleDepth(trainY);


%% Make prediction
idx = 3;


pred = zeros(height, width);
for i = 1:height
  for j = 1:width
    xvec = squeeze(xAbs(idx,i,j,:));
    thvec = squeeze(thetaML(i,:));
    pred(i,j) = dot(thvec, xvec);
  end
  pred(i,:) = rescale(pred(i,:));
end

subplot(3,3,1);
imagesc(squeeze(trainX(idx,:,:,:)));
set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
axis equal;
subplot(2,3,2);
imagesc(squeeze(trainY(idx,:,:)));
set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
axis equal;
subplot(2,3,3);
imagesc(pred);
set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
axis equal;

%% Generate testing data

imgDir = strcat(pwd, '/Test134/');
depthDir = strcat(pwd, '/TestDepth134/');

[testX,testY] = loadTrainingData(...
  imgDir,depthDir,0,0,height,width,...
  originalImgHeight,originalImgWidth);

[xAbs,xRel] = genFeatures(testX, height, width);
Y = upperScaleDepth(testY);

%% Get error

error = zeros(134,1);

for k = 1:134
  imgDir = strcat(pwd, '/Test134/');
  depthDir = strcat(pwd, '/TestDepth134/');

  [testX,testY] = loadTrainingData(...
  imgDir,depthDir,2,k-1,height,width,...
  originalImgHeight,originalImgWidth);

  [xAbs,xRel] = genFeatures(testX, height, width);
  Y = upperScaleDepth(testY);
  pred = zeros(height, width);
  for i = 1:height
    for j = 1:width
      xvec = squeeze(xAbs(1,i,j,:));
      thvec = squeeze(thetaML(i,:));
      pred(i,j) = dot(thvec, xvec);
    end
    pred(i,:) = rescale(pred(i,:));
  end
  groundTruth = rescale(squeeze(Y(1,:,:,1)));
  residual = pred - groundTruth;
  error(k) = mean(abs(residual), 'all');
%   sqErr = residual.^2;
%   error(k) = mean(sqErr, 'all');
  fprintf("Test image %d. MSE: %f\n", k, error(k));
end

save([pwd '/model/error.mat'], 'error');

%% Train

% thetaML = ones(646,1);    
% lambdaML = zeros(size(thetaML));
% fOptions.maxIter = 10;
% funLL = @(theta)likelihoodBatch(theta);
% thetaML = L1General2_PSSgb(funLL, thetaML, lambdaML, fOptions);

%% Load training data
thetaML = ones(646, height,1);    
lambdaML = zeros(size(thetaML));
% for epoch = 1:epochs
    %Load same batch for now an see if we can overfit
[trainX,trainY] = loadTrainingData(...
  imgDir,depthDir,batchSize,0,height,width,...
  originalImgHeight,originalImgWidth);

[xAbs,xRel] = genFeatures(trainX, height, width);
Y = upperScaleDepth(trainY);
% xPerm = permute(xAbs,[4 1 2 3]);
% yPerm = permute(Y,[2 3 1 4]);

%% Train  
% fOptions.maxIter = 10;
% 
% funLL = @(theta)likelihood2(theta, xAbs, Y);
% thetaML = L1General2_PSSgb(funLL, thetaML, lambdaML, fOptions);
X = reshape(xAbs,[],size(xAbs,4));
Y = reshape(Y(:,:,:,1),[],1);
thetaML = ones(height,646,1);
counter = 1;
for i = 1:size(X,1)/height:size(X,1)-1
  fprintf("%d\n", counter);
  thetaML(i,:) = X\Y;
  counter = counter + 1;
end
%     [ll,grad] = likelihood(thetaML, data);

%     thetaML = X \ Y;
%     


   
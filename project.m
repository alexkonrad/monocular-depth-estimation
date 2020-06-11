%% Clear variables
clear

%% Generate features

genFeaturesBatch(5);

%% Train

thetaML = ones(646,1);    
lambdaML = zeros(size(thetaML));
fOptions.maxIter = 10;
funLL = @(theta)likelihoodBatch(theta);
thetaML = L1General2_PSSgb(funLL, thetaML, lambdaML, fOptions);

%% Load training data
thetaML = ones(646,1);    
lambdaML = zeros(size(thetaML));
% for epoch = 1:epochs
    %Load same batch for now an see if we can overfit
[trainX,trainY] = loadTrainingData(...
  imgDir,depthDir,batchSize,height,width,...
  originalImgHeight,originalImgWidth);

[xAbs,xRel] = genFeatures(trainX, height, width);
Y = upperScaleDepth(trainY);
% xPerm = permute(xAbs,[4 1 2 3]);
% yPerm = permute(Y,[2 3 1 4]);

%% Train  
fOptions.maxIter = 10;

funLL = @(theta)likelihood2(theta, xAbs, Y);
thetaML = L1General2_PSSgb(funLL, thetaML, lambdaML, fOptions);


% X = reshape(xAbs,[],size(xAbs,4));
% Y = reshape(depths(:,:,:,1),[],1);
%     [ll,grad] = likelihood(thetaML, data);

%     thetaML = X \ Y;
%     

   
%% Clear variables
clear
imgDir = strcat(pwd, '/Train400Img/');
depthDir = strcat(pwd, '/Train400Depth/');
batchSize = 50;
height = 24*9;
width = 18*9;
originalImgHeight = 24*9*2;
originalImgWidth = 18*9*2;
epochs = 50;

%% Load training data
thetaML = ones(646,1);    
lambdaML = zeros(size(thetaML));
% for epoch = 1:epochs
    %Load same batch for now an see if we can overfit
    [trainX,trainY] = loadTrainingData(...
      imgDir,depthDir,batchSize,height,width,...
      originalImgHeight,originalImgWidth);

    [xAbs,xRel] = genFeatures(trainX, height, width);
    depths = upperScaleDepth(trainY);
    X = reshape(xAbs,[],size(xAbs,4));
    Y = reshape(depths(:,:,:,1),[],1);
    
    thetaML = X \ Y;
    

   
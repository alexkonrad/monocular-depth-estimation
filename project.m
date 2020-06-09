%% Clear variables
clear
imgDir = strcat(pwd, '/Train400Img/');
depthDir = strcat(pwd, '/Train400Depth/');
batchSize = 2;
height = 24*9;
width = 18*9;
originalImgHeight = 24*9*2;
originalImgWidth = 18*9*2;
epochs = 50;

%% Load training data
thetaML = ones(646,1);    
lambdaML = zeros(size(thetaML));
for epoch = 1:epochs
    %Load same batch for now an see if we can overfit
    [trainX,trainY] = loadTrainingData(...
      imgDir,depthDir,batchSize,height,width,...
      originalImgHeight,originalImgWidth);

    [xAbs,xRel] = genFeatures(trainX, height, width);
    depths = upperScaleDepth(trainY);
    
    %concatenate data
    data = zeros(size(trainY,1),size(trainY,2),size(trainY,3),3 + size(xAbs,4));
    data(:,:,:,1:size(xAbs,4)) = xAbs;
    data(:,:,:,size(xAbs,4)+1:end) = depths;

    
    funLL = @(theta)likelihood(theta, data);


    thetaML = L1General2_TMP(funLL, thetaML, lambdaML);
%     [ll,grad] = likelihood(thetaML, data);
end

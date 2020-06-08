%% Clear variables
clear
imgDir = strcat(pwd, '/Train400Img/');
depthDir = strcat(pwd, '/Train400Depth/');
batchSize = 10;
height = 24*9;
width = 18*9;
originalImgHeight = 24*9*2;
originalImgWidth = 18*9*2;

%% Load training data
[trainX,trainY] = loadTrainingData(...
  imgDir,depthDir,batchSize,height,width,...
  originalImgHeight,originalImgWidth);

%% Features

[xAbs,xRel] = genFeatures(trainX, height, width);


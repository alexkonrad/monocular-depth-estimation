function [outputArg1,outputArg2] = genFeaturesBatch(batchSize)
% Generate feature batch variables and store in data directory.
% 
imgDir = strcat(pwd, '/Train400Img/');
depthDir = strcat(pwd, '/Train400Depth/');
height = 24*9;
width = 18*9;
originalImgHeight = 24*9*2;
originalImgWidth = 18*9*2;
if ~exist('data', 'dir')
  mkdir('data');
end
N = numel(dir(fullfile(imgDir, '*.jpg')));
fprintf(['Generating features for ' num2str(N) ' examples, batch size'...
  num2str(batchSize) '\n']);
i = 1
for offset = 0:batchSize:N-1
  fprintf(['Generating features for ' num2str(offset+1) '-' num2str(offset+batchSize) '\n']);
  fprintf('Loading files...\n');
  [trainX,trainY] = loadTrainingData(imgDir,depthDir,batchSize,offset,height,width,originalImgHeight,originalImgWidth);
  fprintf('Generating features...\n');
  [xAbs,xRel] = genFeatures(trainX, height, width);
  fprintf('Generating depth scales...\n');
  Y = upperScaleDepth(trainY);
  save([pwd '/data/batch' num2str(i)], 'xAbs', 'xRel', 'Y');
  fprintf(['Created file data/batch' num2str(i) '.mat\n']);
  i = i + 1;
end


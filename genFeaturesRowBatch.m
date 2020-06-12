function [outputArg1,outputArg2] = genFeaturesRowBatch(batchSize, createFiles)
% Generate feature batch variables and store in data directory,
% one variable file for each row.
% 
imgDir = strcat(pwd, '/Train400Img/');
depthDir = strcat(pwd, '/Train400Depth/');
height = 12*9;%24*9;
width = 9*9;%18*9;
originalImgHeight = 24*9*2;
originalImgWidth = 18*9*2;
if ~exist('data', 'dir')
  mkdir('data');
end
N = numel(dir(fullfile(imgDir, '*.jpg')));
if createFiles == 1
  for i = 1:height
    XS = zeros(N,width,646);
    YS = zeros(N,width,3);
    XRS = zeros(N,width,17,3);
    save([pwd '/data/row' num2str(i, '%03.f')], 'XS', 'YS', 'XRS');
    clear XS YS XRS;
  end
end
fprintf(['Generating features for ' num2str(N) ' examples, batch size'...
  num2str(batchSize) '\n']);
i = 1;
for offset = 0:batchSize:N-1
  fprintf(['Generating features for ' num2str(offset+1) '-' num2str(offset+batchSize) '\n']);
  fprintf('Loading files...\n');
  [trainX,trainY] = loadTrainingData(imgDir,depthDir,batchSize,offset,height,width,originalImgHeight,originalImgWidth);
  fprintf('Generating features...\n');
  [xAbs,xRel] = genFeatures(trainX, height, width);
  fprintf('Generating depth scales...\n');
  Y = upperScaleDepth(trainY);
  for j = 1:height
    fprintf("Saving features for row %d for training examples %d-%d...\n", j,offset+1, offset+batchSize);
    load([pwd '/data/row' num2str(j, '%03.f') '.mat'], 'XS', 'YS', 'XRS');
    fprintf("Row %d: nonzero entries: XS: %d YS: %d XRS: %d\n", j, nnz(XS), nnz(YS), nnz(XRS));
    XS(offset+1:offset+batchSize,:,:) = xAbs(:,j,:,:);
    YS(offset+1:offset+batchSize,:,:) = Y(:,j,:,:);
    XRS(offset+1:offset+batchSize,:,:,:) = xRel(:,j,:,:,:);
    fprintf("Row %d: nonzero entries: XS: %d YS: %d XRS: %d\n", j, nnz(XS), nnz(YS), nnz(XRS));
    save([pwd '/data/row' num2str(j, '%03.f')], 'XS', 'YS', 'XRS');
  end
  clear xAbs xRel trainX trainY Y;
%   save([pwd '/data/batch' num2str(i)], 'xAbs', 'xRel', 'Y');
%   fprintf(['Created file data/batch' num2str(i) '.mat\n']);
  i = i + 1;
end


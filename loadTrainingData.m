function [trainX, trainY] = loadTrainingData(imgDir, depthDir, N, offset,...
 height, width, originalImageHeight, originalImageWidth)
% Load image and depth training data from folders
%
% Inputs:
%     imgDir: directory path to training images data
%     depthDir: directory path to training images depths
%     N: number of images to load (set to 0 to load all images)
%     offset: offset of images to load
%     height:  height to resize depth maps to
%     width: width to resize depth maps to
%     originalImageHeight: original heights of images
%     originalImageWidth: original widths of images
%
% Outputs:
%     trainX: N x originalImageHeight x originalImageWidth x 5 array
%     trainY: N x height x width depth maps
trainImgFiles = dir(fullfile(imgDir, '*.jpg'));
trainDepthFiles = dir(fullfile(depthDir, '*.mat'));
if N == 0
  N = numel(trainImgFiles);
end

if offset > numel(trainImgFiles)
  return
end

trainX = zeros(N,originalImageHeight,originalImageWidth,3);
trainY = zeros(N,height,width);

for i = 1:N
  idx = i + offset;
  imgFilename = strcat(imgDir, trainImgFiles(idx).name);
  depthFilename = strcat(depthDir, trainDepthFiles(idx).name);
  img = im2double(rgb2ycbcr(imread(imgFilename)));
  resizedImg = imresize(img, [originalImageHeight originalImageWidth]);
  trainX(i,:,:,:) = resizedImg;

  D = load(depthFilename);
  depthMap = D.Position3DGrid(:,:,4);
  resizedDepthMap = imresize(depthMap, [height width]);
  trainY(i,:,:) = resizedDepthMap;
end


end


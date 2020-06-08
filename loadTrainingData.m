function [trainX, trainY] = loadTrainingData(imgDir, depthDir, N, width, height)
% Load image and depth training data from folders
%
% Inputs:
%     imgDir: directory path to training images data
%     depthDir: directory path to training images depths
%     N: number of images to load (set to 0 to load all images)
%     width: width to resize images and depth maps to
%     height to resize images and depth maps to
%
% Outputs:
%     trainX: Nx
trainImgFiles = dir(fullfile(imgDir, '*.jpg'));
trainDepthFiles = dir(fullfile(depthDir, '*.mat'));
if N == 0
  N = numel(trainImgFiles);
end

trainX = zeros(N,height,width,3);
trainY = zeros(N,height,width);

for i = 1:N
  imgFilename = strcat(imgDir, trainImgFiles(i).name);
  depthFilename = strcat(depthDir, trainDepthFiles(i).name);
  img = im2double(rgb2ycbcr(imread(imgFilename)));
  resizedImg = imresize(img, [height width]);
  trainX(i,:,:,:) = resizedImg;

  D = load(depthFilename);
  depthMap = D.Position3DGrid(:,:,4);
  resizedDepthMap = imresize(depthMap, [height width]);
  trainY(i,:,:) = resizedDepthMap;
end


end


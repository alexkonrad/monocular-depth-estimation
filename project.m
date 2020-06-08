% Texture information is mostly contained within the image intensity 
% channel, so we apply Laws’ masks [15, 4] to this channel to compute the 
% texture energy (Fig. 1). Haze is reflected in the low frequency 
% information in the color channels, and we capture this by applying a 
% local averaging filter (the first Laws mask) to the color channels. 
% Lastly, to compute an estimate of texture gradient that is robust to 
% noise, we convolve the intensity channel with six oriented edge filters.

clear
%% Load image

% RGB = imread('aloe/view5.png');
% YCBCR = im2double(rgb2ycbcr(RGB));
% Trim the image so that it is divisible into four vertical quantiles.
% YCBCR = YCBCR(1:floor(size(YCBCR,1)/4)*4,:,:);

%  Display RGB image
% figure; imshow(RGB); title('Image in RGB Color Space');

% Display YCBCR image
% figure; imshow(YCBCR(:,:,1)); title('Image in YCBCR Color Space');

%% Load Depth Data

% RGBDEPTH = imread('aloe/disp5.png');
% D = RGBDEPTH;
% D = rescale(rgb2gray(RGBDEPTH));

% Show depth image
% figure; imshow(D); title('Depth data');

%% Load training data

imgDir = strcat(pwd, '/Train400Img/');
depthDir = strcat(pwd, '/Train400Depth/');
[trainX,trainY] = loadTrainingData(imgDir,depthDir,25,570,285);

%% Display images

for i = 1:2:4
  subplot(10,2,i);
  imagesc(squeeze(trainX(i,:,:,:)));
  set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
  axis equal;
  subplot(10,2,i+1);
  imagesc(squeeze(trainY(i,:,:)));
  set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
  axis equal;
end

%% Compute filterbanks

X = pixelFeatures(YCBCR);
[xAbs,xRel] = patchFeatures(X, YCBCR, 10, 10);


%% Display filters
% figure
% montage(rescale(xAbs(:,:,1:34*5)), 'Size', [10 17])
% figure
% montage(rescale(xAbs(:,:,(34*5)+1:34*10)), 'Size', [10 17])
% figure
% montage(rescale(xAbs(:,:,(34*10)+1:34*15)), 'Size', [10 17])
% figure
% montage(rescale(xAbs(:,:,(34*15)+1:end)), 'Size', [8 17])

%% KITTI
% V = "depth_selection/val_selection_cropped/";
% IMG = "image/";
% GTR = "groundtruth_depth/";
% groundtruth = dir(V+GTR);
% images = dir(V+IMG);
% gtr = groundtruth(3).name;
% img = images(3).name
% RGB = imread(V+IMG+img);
% D = imread(V+GTR+gtr);
% figure; imshow(RGB);
% figure; imshow(D);

% for f = groundtruth
%   if ~endsWith(f.name, '.png')
%     continue
%   end
%   
% end

% Depth data

% load('depth/test.mat');
% D = Position3DGrid(:,:,4);
% figure; imshow(rescale(D));


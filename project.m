% Texture information is mostly contained within the image intensity 
% channel, so we apply Laws’ masks [15, 4] to this channel to compute the 
% texture energy (Fig. 1). Haze is reflected in the low frequency 
% information in the color channels, and we capture this by applying a 
% local averaging filter (the first Laws mask) to the color channels. 
% Lastly, to compute an estimate of texture gradient that is robust to 
% noise, we convolve the intensity channel with six oriented edge filters.

clear
%% Load image

RGB = imread('aloe/view5.png');
YCBCR = im2double(rgb2ycbcr(RGB));
% Trim the image so that it is divisible into four vertical quantiles.
% YCBCR = YCBCR(1:floor(size(YCBCR,1)/4)*4,:,:);

% ca = patches(YCBCR, 50, 50);
% displayPatches(ca);
% 
% ca = patches(YCBCR, 150, 150);
% displayPatches(ca);
% 
% ca = patches(YCBCR, 450, 450);
% displayPatches(ca);

%% Display RGB image

% figure
% imshow(RGB);
% title('Image in RGB Color Space');

%% Display YCBCR image

% figure
% imshow(YCBCR(:,:,1));
% title('Image in YCBCR Color Space');

%% Load Depth Data

RGBDEPTH = imread('aloe/disp5.png');
D = RGBDEPTH;
% D = rescale(rgb2gray(RGBDEPTH));

%% Show depth image

% figure
% imshow(D);
% title('Depth data');

%% Depth data

% load('depth/test.mat');
% D = Position3DGrid(:,:,4);
% figure; imshow(rescale(D));

%% Resize

% YCBCR = imresize(YCBCR, 1/9, 'bilinear');
% D = imresize(D, 1/9, 'bilinear');

%% Compute filterbanks

tic;
X = pixelFeatures(YCBCR);
toc;
tic;
[xAbs,xRel] = patchFeatures(X, YCBCR, 100, 100);
toc;

%% Display filters
figure
montage(rescale(xAbs(:,:,1:34*5)), 'Size', [10 17])
figure
montage(rescale(xAbs(:,:,(34*5)+1:34*10)), 'Size', [10 17])
figure
montage(rescale(xAbs(:,:,(34*10)+1:34*15)), 'Size', [10 17])
figure
montage(rescale(xAbs(:,:,(34*15)+1:end)), 'Size', [8 17])

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


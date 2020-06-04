% Texture information is mostly contained within the image intensity 
% channel, so we apply Laws’ masks [15, 4] to this channel to compute the 
% texture energy (Fig. 1). Haze is reflected in the low frequency 
% information in the color channels, and we capture this by applying a 
% local averaging filter (the first Laws mask) to the color channels. 
% Lastly, to compute an estimate of texture gradient that is robust to 
% noise, we convolve the intensity channel with six oriented edge filters.


%% Load image

RGB = imread('images/test3.png');

YCBCR = im2double(rgb2ycbcr(RGB));

% Trim the image so that it is divisible into four
% vertical quantiles.
YCBCR = YCBCR(1:floor(size(YCBCR,1)/4)*4,:,:);

%% Display RGB image

figure
imshow(RGB);
title('Image in RGB Color Space');

%% Display YCBCR image

figure
imshow(YCBCR(:,:,1));
title('Image in YCBCR Color Space');

%% Load Depth Data

RGBDEPTH = imread('depth/depth-test3.png');
D = rescale(rgb2gray(RGBDEPTH));

%% Show depth image

figure
imshow(D);
title('Depth data');

% load('depth/test2.mat');
% D = Position3DGrid(:,:,4);

%% Compute filterbanks

X = pixelFeatures(YCBCR);
[xAbs,xRel] = patchFeatures(X, YCBCR);



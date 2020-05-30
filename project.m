% Texture information is mostly contained within the image intensity 
% channel, so we apply Laws’ masks [15, 4] to this channel to compute the 
% texture energy (Fig. 1). Haze is reflected in the low frequency 
% information in the color channels, and we capture this by applying a 
% local averaging filter (the first Laws mask) to the color channels. 
% Lastly, to compute an estimate of texture gradient that is robust to 
% noise, we convolve the intensity channel with six oriented edge filters.


%% Load image

RGB=imread('images/road.jpeg');
YCBCR=im2double(rgb2ycbcr(RGB));
Y=YCBCR(:,:,1);

%% Display RGB image

% figure
% imshow(RGB);
% title('Image in RGB Color Space');

%% Display YCBCR image

% figure
% imshow(YCBCR(:,:,1));
% title('Image in YCBCR Color Space');

%% Compute filterbanks
L3 = [1 2 1]
E3 = [-1 0 1];
S3 = [-1 2 -1];
NB1 = [ -100, -100, 0, 100, 100; ...
        -100, -100, 0, 100, 100; ...
        -100, -100, 0, 100, 100; ...
        -100, -100, 0, 100, 100; ...
        -100, -100, 0, 100, 100];
NB2 = [ -100, 32, 100, 100, 100; ...
        -100,-78, 92,  100, 100; ...
        -100,-100, 0,  100, 100; ...
        -100,-100,-92, 78,  100; ...
        -100,-100,-100,-32, 100];
NB3 = -NB2';
NB4 = -NB1';
NB5 = -NB3(end:-1:1,:);
NB6 = NB5';

%% Compute 17 initial filters
nLaw = 17;
H = zeros(size(Y,1),size(Y,2),nLaw);
H(:,:,1) = rescale(conv2(Y, L3'*L3, 'same'));
H(:,:,2) = rescale(conv2(Y, L3'*E3, 'same'));
H(:,:,3) = rescale(conv2(Y, L3'*S3, 'same'));
H(:,:,4) = rescale(conv2(Y, E3'*L3, 'same'));
H(:,:,5) = rescale(conv2(Y, E3'*E3, 'same'));
H(:,:,6) = rescale(conv2(Y, E3'*S3, 'same'));
H(:,:,7) = rescale(conv2(Y, S3'*L3, 'same'));
H(:,:,8) = rescale(conv2(Y, S3'*E3, 'same'));
H(:,:,9) = rescale(conv2(Y, S3'*S3, 'same'));
H(:,:,10) = rescale(conv2(YCBCR(:,:,2), L3'*L3, 'same'));
H(:,:,11) = rescale(conv2(YCBCR(:,:,3), L3'*L3, 'same'));
H(:,:,12) = rescale(conv2(Y, NB1, 'same'));
H(:,:,13) = rescale(conv2(Y, NB2, 'same'));
H(:,:,14) = rescale(conv2(Y, NB3, 'same'));
H(:,:,15) = rescale(conv2(Y, NB4, 'same'));
H(:,:,16) = rescale(conv2(Y, NB5, 'same'));
H(:,:,17) = rescale(conv2(Y, NB6, 'same'));

%% Absolute Feature Vectors (Section 3.1)

% TODO: In section 3.1, do we compute absolute energy and sum of squared energy wiht
% with just the intensity channel or all three channels of the image? Here
% we just compute with the intensity channel.

% WxHx34 feature vector
E1=Y.*H;
E2=E1.*E1;
E=cat(3,E1,E2);
[W,H,D]=size(E);
X=zeros(W,H,D*19); % 646-dimensional feature matrix
clear F;
F0=[
  0 0 0
  0 1 0
  0 0 0
];
F1=[
  0 1 0
  0 0 0
  0 0 0
];
F2=[
  0 0 0
  0 0 0
  0 1 0
];
F3=[
  0 0 0
  1 0 0
  0 0 0
];
F4=[
  0 0 0
  0 0 1
  0 0 0
];
F{1}=cat(3,F0,F1,F2,F3,F4);
Z=zeros(3,3); O=ones(3,3);
F5=[
  Z Z Z
  Z O Z
  Z Z Z
];
F6=[
  Z O Z
  Z Z Z
  Z Z Z
];
F7=[
  Z Z Z
  Z Z Z
  Z O Z
];
F8=[
  Z Z Z
  O Z Z
  Z Z Z
];
F9=[
  Z Z Z
  Z Z O
  Z Z Z
];
F{2}=cat(3,F5,F6,F7,F8,F9);
Z=zeros(9,9); O=ones(9,9);
F10=[
  Z Z Z
  Z O Z
  Z Z Z
];
F11=[
  Z O Z
  Z Z Z
  Z Z Z
];
F12=[
  Z Z Z
  Z Z Z
  Z O Z
];
F13=[
  Z Z Z
  O Z Z
  Z Z Z
];
F14=[
  Z Z Z
  Z Z O
  Z Z Z
];
F{3}=cat(3,F10,F11,F12,F13,F14);

X(:,:,1:D)=E;
for j=1:3 % Rescale image to 3 different sizes
  for i=1:5 % Filter for pixel and 4 neighbors
    idx=i*j*D+1;
    X(:,:,idx:idx+D-1)=convn(E,F{j}(:,:,i),'same'); % Compute neighboring patches
  end
end

% TODO: Add last three absolute features for column:
% Lastly, many structures (such as trees and buildings) found in outdoor scenes 
% show vertical structure, in the sense that they are vertically connected to 
% themselves (things cannot hang in empty air). Thus, we also add to the 
% features of a patch additional summary features of the column it lies in.

E1=convn(I, f, 'same');
  


function [X] = pixelFeatures(image)
% Compute 17 initial pixel features.
% 
% Inputs:
%     image: WxHx5 image, must be in YCBCR format
%
% Outputs:
%     X: WxHx17 matrix with 17 pixel features for each pixel.

Y = image(:,:,1);

L3 = [ 1 2  1];
E3 = [-1 0  1];
S3 = [-1 2 -1];
NB1 = [
  -100, -100, 0, 100, 100
  -100, -100, 0, 100, 100
  -100, -100, 0, 100, 100
  -100, -100, 0, 100, 100
  -100, -100, 0, 100, 100
];
NB2 = [
  -100,  32, 100, 100, 100
	-100, -78,  92, 100, 100
	-100,-100,   0, 100, 100
	-100,-100, -92,  78, 100
	-100,-100,-100, -32, 100
];
NB3 = -NB2';
NB4 = -NB1';
NB5 = -NB3(end:-1:1,:);
NB6 = NB5';

% Compute 17 initial filters
nLaw = 17;
X = zeros(size(Y,1),size(Y,2),nLaw);
X(:,:,1) = rescale(conv2(Y, L3'*L3, 'same'));
X(:,:,2) = rescale(conv2(Y, L3'*E3, 'same'));
X(:,:,3) = rescale(conv2(Y, L3'*S3, 'same'));
X(:,:,4) = rescale(conv2(Y, E3'*L3, 'same'));
X(:,:,5) = rescale(conv2(Y, E3'*E3, 'same'));
X(:,:,6) = rescale(conv2(Y, E3'*S3, 'same'));
X(:,:,7) = rescale(conv2(Y, S3'*L3, 'same'));
X(:,:,8) = rescale(conv2(Y, S3'*E3, 'same'));
X(:,:,9) = rescale(conv2(Y, S3'*S3, 'same'));
X(:,:,10) = rescale(conv2(image(:,:,2), L3'*L3, 'same'));
X(:,:,11) = rescale(conv2(image(:,:,3), L3'*L3, 'same'));
X(:,:,12) = rescale(conv2(Y, NB1, 'same'));
X(:,:,13) = rescale(conv2(Y, NB2, 'same'));
X(:,:,14) = rescale(conv2(Y, NB3, 'same'));
X(:,:,15) = rescale(conv2(Y, NB4, 'same'));
X(:,:,16) = rescale(conv2(Y, NB5, 'same'));
X(:,:,17) = rescale(conv2(Y, NB6, 'same'));
end


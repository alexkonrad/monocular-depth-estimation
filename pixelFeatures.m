function [X] = pixelFeatures(images)
% Compute 17 initial pixel features.
% 
% Inputs:
%     image: NxWxHx5 image, must be in YCBCR format
%
% Outputs:
%     X: NxWxHx17 matrix with 17 pixel features for each pixel.

Y = images(:,:,:,1);

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
X = zeros(size(Y,1),size(Y,2),size(Y,3),nLaw);
X(:,:,:,1) = rescale(convn(Y, L3'*L3, 'same'));
X(:,:,:,2) = rescale(convn(Y, L3'*E3, 'same'));
X(:,:,:,3) = rescale(convn(Y, L3'*S3, 'same'));
X(:,:,:,4) = rescale(convn(Y, E3'*L3, 'same'));
X(:,:,:,5) = rescale(convn(Y, E3'*E3, 'same'));
X(:,:,:,6) = rescale(convn(Y, E3'*S3, 'same'));
X(:,:,:,7) = rescale(convn(Y, S3'*L3, 'same'));
X(:,:,:,8) = rescale(convn(Y, S3'*E3, 'same'));
X(:,:,:,9) = rescale(convn(Y, S3'*S3, 'same'));
X(:,:,:,10) = rescale(convn(images(:,:,:,2), L3'*L3, 'same'));
X(:,:,:,11) = rescale(convn(images(:,:,:,3), L3'*L3, 'same'));
X(:,:,:,12) = rescale(convn(Y, NB1, 'same'));
X(:,:,:,13) = rescale(convn(Y, NB2, 'same'));
X(:,:,:,14) = rescale(convn(Y, NB3, 'same'));
X(:,:,:,15) = rescale(convn(Y, NB4, 'same'));
X(:,:,:,16) = rescale(convn(Y, NB5, 'same'));
X(:,:,:,17) = rescale(convn(Y, NB6, 'same'));
end


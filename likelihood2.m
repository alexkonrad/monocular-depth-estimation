function [ll,grad] = likelihood2(theta, data)
% [ll,grad] = likelihood(theta, data, L, N)
% Compute the Negative log-likelihood and gradient for jointly gaussian model
% 
% Inputs:
%    theta: Current estimate of the parameters of the gaussian model.(L,1) 
%    data: feature vectors and depths for all patches in the dataset
%    (N,H,W,L+3), N images, H*W patches, L depth features, d true depths
%    
%    M: number of patches per image
%    neighbours : cell of arrays, listing neighbours of each patch
% Outputs:
%    ll: the log-likelihood of the model
%    grad: the gradient of the log-likelihood function for the given value
%          of theta

L = size(data,4)-3;        %Depth features
H = size(data,2);
W = size(data,3);
d = data(:,:,:,L+1:end);      %depth values at the smallest scale(N,M,3)
X = data(:,:,:,1:L);    %features of images' patches (N,M,L)
alpha_1 = 1;            % variances (assumed to be constant for now)
alpha_2 = 1;


Xperm = permute(X,[4 1 2 3]);
thetaX = squeeze(sum(theta .* Xperm, 1));
term1 = (d(:,:,:,1) - thetaX).^2 / (2 * alpha_1^2);
sumTerm1 = sum(term1, 1:3);
dd = permute(d, [2 3 1 4]);
denom = 2*alpha_2^2;
d1 = cat(1, dd(1,:,:,:), diff(dd)).^2;
d2 = cat(2, diff(dd,1,2), dd(:,end,:,:)).^2;
d3 = cat(1, flip(diff(flip(dd,1),1)), dd(end,:,:,:)).^2;
d4 = cat(2, dd(:,1,:,:), flip(diff(flip(dd,2),1,2),2)).^2;
term2 = (d1+d2+d3+d4)/denom;
sumTerm2 = sum(term2, 1:4);
ll = -(sumTerm1 + sumTerm2);
grad = squeeze(sum((2*term1) .* X, 1:3));
end
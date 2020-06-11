function [ll,grad] = likelihood2(theta, X, Y)
% [ll,grad] = likelihood(theta, X, L, N)
% Compute the Negative log-likelihood and gradient for jointly gaussian model
% 
% Inputs:
%    theta: Current estimate of the parameters of the gaussian model.(L,1) 
%    X: feature vectors for all patches in the dataset
%    (N,H,W,L), N images, H*W patches, L depth features
%    Y: Ground truth depths
%    
%    M: number of patches per image
%    neighbours : cell of arrays, listing neighbours of each patch
% Outputs:
%    ll: the log-likelihood of the model
%    grad: the gradient of the log-likelihood function for the given value
%          of theta
alpha_1 = 1;
alpha_2 = 1;
% 
% if nargin < 5
%   yPerm = permute(Y,[2 3 1 4]);
% end
% if nargin < 4
%   xPerm = permute(X, [4 1 2 3]);
% end

X = permute(X, [4 1 2 3]);
thetaX = squeeze(sum(theta .* X, 1));
residual = Y(:,:,:,1)-thetaX;
unary = residual.^2 / (2 * alpha_1^2);
sumUnary = sum(unary, 1:3);

Y = permute(Y,[2 3 1 4]);
denom = 2*alpha_2^2;
up = cat(1, Y(1,:,:,:), diff(Y)).^2/denom;
left = cat(2, diff(Y,1,2), Y(:,end,:,:)).^2/denom;
down = cat(1, flip(diff(flip(Y,1),1)), Y(end,:,:,:)).^2/denom;
right = cat(2, Y(:,1,:,:), flip(diff(flip(Y,2),1,2),2)).^2/denom;
binary = up+left+down+right;
sumBinary = sum(binary, 1:4);

X = ipermute(X, [4 1 2 3]);

ll = sumUnary + sumBinary;
grad = -squeeze(sum((X.*residual)./alpha_1^2, 1:3));
end
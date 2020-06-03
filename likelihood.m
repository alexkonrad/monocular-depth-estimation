function [ll,grad] = likelihood(theta, data, M,neighbours)
% [ll,grad] = likelihood(theta, data, L, N)
% Compute the Negative log-likelihood and gradient for jointly gaussian model
% 
% Inputs:
%    theta: Current estimate of the parameters of the gaussian model.(L,1) 
%    data: feature vectors and depths for all patches in the dataset
%    (N,M,L+d), N images, M patches, L depth features, d true depths
%    
%    M: number of patches per image
%    neighbours : cell of arrays, listing neighbours of each patch
% Outputs:
%    ll: the log-likelihood of the model
%    grad: the gradient of the log-likelihood function for the given value
%          of theta

L = size(X,3)-3;
d = data(:,:,L+1:end);      %depth values at the smallest scale(N,M,3)
X = data(:,:,1:end-1);    %features of images' patches (N,M,L)
alpha_1 = 1;            % variances (assumed to be constant for now)
alpha_2 = 1;

%compute objective in a loop for now
%TODO: Vectorize
ll = 0;  %negative Log likelihood
d_1 = d(:,:,1);

for n = 1:size(X,1)
    for m = 1:M
        x = X(n,m);
        ll = ll + (d_1(n,m) - x*theta).^2 / (2 * alpha_1^2);    
    end
    
    for s = 1:3
        for m = 1:M
            for neighbour = neighbours(m)
               ll = ll + ((d(n,m,s) - d(n,neighbour,s))^2) / (2*alpha_2^2);
            end
        end
    end
end

grad = zeros(L);
for n = 1:size(X,1)
    for m = 1:M
        x = X(n,m);
        grad = grad + (d_1(n,m) - x*theta)*x / alpha_1^2;    
    end
end
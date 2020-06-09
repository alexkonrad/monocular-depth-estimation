function [ll,grad] = likelihood(theta, data)
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

%compute objective in a loop for now
%TODO: Vectorize
ll = 0;  %negative Log likelihood
d_1 = d(:,:,:,1);


shifts =[[0,1];[0,-1];[1,0];[-1,0]];
for n = 1:size(X,1)
    for h = 1:H
        for w = 1:W
            x = squeeze(X(n,h,w,:))';
            ll = ll + (d_1(n,h,w) - x*theta).^2 / (2 * alpha_1^2);    
        end
    end
    
    for s = 1:3
        for h = 2:H-1
            for w = 2:W-1
                for shift_idx = 1:size(shifts,1)
                   h1 = h + shifts(shift_idx,1);
                   w1 = w + shifts(shift_idx,2);
                   ll = ll + ((d(n,h,w,s) - d(n,h1,w1,s))^2) / (2*alpha_2^2);
                end
            end
        end
    end
end

grad = zeros(L,1);
for n = 1:size(X,1)
    for h = 1:H
        for w = 1:W
            x = squeeze(X(n,h,w,:))';
            grad = grad - ((d_1(n,h,w) - x*theta)*x)' ./ alpha_1^2;    
    
        end
    end
end
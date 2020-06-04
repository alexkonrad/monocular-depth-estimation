function [xAbs,xRel] = patchFeatures(X, image)
% Compute absolute and relative feature vectors. Absolute Feature Vectors 
% is based on Section 4.1. Relative feature vectors is based on Section
% 4.2.
% 
% Inputs:
%    image: Must be in YCBCR format
%
% Outputs:
%    xAbs: absolute feature vectors
%    xRel: relative feature vectors
%

% TODO: In section 3.1, do we compute absolute energy and sum of squared energy wiht
% with just the intensity channel or all three channels of the image? Here
% we just compute with the intensity channel.
%
% TODO: Add last three absolute features for column:
% Lastly, many structures (such as trees and buildings) found in outdoor scenes 
% show vertical structure, in the sense that they are vertically connected to 
% themselves (things cannot hang in empty air). Thus, we also add to the 
% features of a patch additional summary features of the column it lies in.

Y = image(:,:,1);

% Create WxHx34 feature vector computed for each patch to create
% 34 * 19 = 646 patch-level features.
YX = Y .* X;
YX2 = YX .* YX;
E = cat(3,YX,YX2);
[H,W,D] = size(E);

% Patch-level absolute feature matrix
xAbs = zeros(H,W,D*19);
% xAbs = double.empty(W,H,0);

[f1,f2,f3,f4,f5] = neighborFilters(1);
[f6,f7,f8,f9,f10] = neighborFilters(3);
[f11,f12,f13,f14,f15] = neighborFilters(9);
[f16,f17,f18,f19] = columnFilters(H);

F{1} = cat(3,f1,f2,f3,f4,f5);
F{2} = cat(3,f6,f7,f8,f9,f10);
F{3} = cat(3,f11,f12,f13,f14,f15);
F{4} = cat(3,f16,f17,f18,f19);

% Compute absolute feature values for this pixel
% TODO remove this
% xAbs(:,:,1:D) = E;

% Rescale image to 3 different sizes, filter for pixel and 4 neighbors.
% compute feature values for neighboring patches
%   fprintf("%d %d %d\n", i, j, k);

tic;
for i=1:D:D*15
  [~,j,k] = ind2sub([D 5 3], i);
  xAbs(:,:,i:i+D-1) = convn(E,F{k}(:,:,j),'same');
  fprintf("Feature rows %d-%d\n", i, i+D-1);
end
toc;
tic;
for i=D*15+1:D:D*19
  j = floor((i-510)/D)+1;
%   xAbs(:,:,i:i+D-1) = repmat(F{4}(:,:,j)', H, 1);
%   xAbs(:,:,i:i+D-1) = convn(E,F{4}(:,:,j),'same');
  for k=1:size(E,3)
    xAbs(:,:,i+k-1) = repmat(F{4}(:,:,j)'*E(:,:,k), H, 1);
    fprintf("Feature row %d\n", i+k-1);
  end
end
toc;
% end
% for j=1:3
%   for i=1:5
%     idx = (sub2ind([5 3], i, j)-1)*D + 1; 
% %     idx=i*j*D+1;
%     xAbs(:,:,idx:idx+D-1) = convn(E,F{j}(:,:,i),'same');
%   end
% end



xRel=zeros(1,1);
% 
% E1=convn(I, f, 'same');
end


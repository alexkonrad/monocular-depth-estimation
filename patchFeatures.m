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
Y = image(:,:,1);

% Create WxHx34 feature vector computed for each patch to create
% 34 * 19 = 646 patch-level features.
YX = Y .* X;
YX2 = YX .* YX;
E = cat(3,YX,YX2);
[H,W,D] = size(E);

% Patch-level absolute feature matrix
xAbs = zeros(H,W,D*19);

[f1,f2,f3,f4,f5] = neighborFilters(1);
[f6,f7,f8,f9,f10] = neighborFilters(3);
[f11,f12,f13,f14,f15] = neighborFilters(9);
[f16,f17,f18,f19] = columnFilters(H);

F{1} = cat(3,f1,f2,f3,f4,f5);
F{2} = cat(3,f6,f7,f8,f9,f10);
F{3} = cat(3,f11,f12,f13,f14,f15);
F{4} = cat(3,f16,f17,f18,f19);

% Compute absolute feature values for this pixel
% Rescale image to 3 different sizes, filter for pixel and 4 neighbors.
% compute feature values for neighboring patches
for i=1:D:D*15
  [~,j,k] = ind2sub([D 5 3], i);
  xAbs(:,:,i:i+D-1) = convn(E,F{k}(:,:,j),'same');
end

% Last four features are column features, which break up every column
% into quadrants. This computes for each quadrant all features, so adds
% 34x4=136 features to the vector.
for i=D*15+1:D:D*19
  j = floor((i-510)/D)+1;
  for k=1:size(E,3)
    xAbs(:,:,i+k-1) = repmat(F{4}(:,:,j)'*E(:,:,k), H, 1);
  end
end


[~,~,yis] = histcounts(X, 10);
xRel = yis;
end


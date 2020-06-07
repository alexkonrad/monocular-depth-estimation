function [xAbs,xRel] = patchFeatures(X, image, patchWidth, patchHeight)
% Compute absolute and relative feature vectors. Absolute Feature Vectors 
% is based on Section 4.1. Relative feature vectors is based on Section
% 4.2.
% 
% Inputs:
%    X
%    image: Must be in YCBCR format
%    patchWidth: patch width
%    patchHeight: patch height
%
% Outputs:
%    xAbs: absolute feature vectors
%    xRel: relative feature vectors
%
Y = image(:,:,1);

% Create WxHx34 feature vector computed for each patch to create
% 34 * 19 = 646 patch-level features.
YX = abs(Y .* X);
YX2 = abs(YX .* YX);
E = cat(3,YX,YX2);
[H,W,D] = size(E);

% NEW PART
ca{1} = patches(E,patchWidth,patchHeight);
ca{2} = patches(E,patchWidth*3,patchHeight*3);
ca{3} = patches(E,patchWidth*9,patchHeight*9);
cols = patches(E,patchWidth,floor(size(Y,1)/4));
xAbs = zeros(size(ca{1},1),size(ca{1},2),D*19);
k = 1;
for l = 1:size(ca,2)
  [px,py,~] = size(ca{l});
  m = k+33;
  for i = 1:px
    for j = 1:py
      xRange = l*(i-1)+1:l*i;
      yRange = l*(j-1)+1:l*j;
      xAbs(xRange,yRange,k:m) = repmat(sum(ca{l}{i,j},1:2),numel(xRange),numel(yRange));
    end
  end
  m = m+1;
  xAbs(:,2:end,m:m+33) = xAbs(:,1:end-1,k:k+33); m = m+34;
  xAbs(:,1:end-1,m:m+33) = xAbs(:,2:end,k:k+33); m = m+34;
  xAbs(2:end,:,m:m+33) = xAbs(1:end-1,:,k:k+33); m = m+34;
  xAbs(1:end-1,:,m:m+33) = xAbs(2:end,:,k:k+33); m = m+34;
  k = m;
end
[px,py,~] = size(ca{1});
for i = 1:px
  m = k;
  xAbs(i,:,m:m+33) = repmat(sum(cols{i,1},1:2),1,py); m = m+34;
  xAbs(i,:,m:m+33) = repmat(sum(cols{i,2},1:2),1,py); m = m+34;
  xAbs(i,:,m:m+33) = repmat(sum(cols{i,3},1:2),1,py); m = m+34;
  xAbs(i,:,m:m+33) = repmat(sum(cols{i,4},1:2),1,py); m = m+34;
end


% NEW PART

% Patch-level absolute feature matrix
% xAbs = zeros(H,W,D*19);
% 
% [f1,f2,f3,f4,f5] = neighborFilters(1);
% [f6,f7,f8,f9,f10] = neighborFilters(3);
% [f11,f12,f13,f14,f15] = neighborFilters(9);
% [f16,f17,f18,f19] = columnFilters(H);
% 
% F{1} = cat(3,f1,f2,f3,f4,f5);
% F{2} = cat(3,f6,f7,f8,f9,f10);
% F{3} = cat(3,f11,f12,f13,f14,f15);
% F{4} = cat(3,f16,f17,f18,f19);

% Compute absolute feature values for this pixel
% Rescale image to 3 different sizes, filter for pixel and 4 neighbors.
% compute feature values for neighboring patches
% for i=1:D:D*15
%   [~,j,k] = ind2sub([D 5 3], i);
%   xAbs(:,:,i:i+D-1) = convn(E,F{k}(:,:,j),'same');
% end

% Last four features are column features, which break up every column
% into quadrants. This computes for each quadrant all features, so adds
% 34x4=136 features to the vector.
% for i=D*15+1:D:D*19
%   j = floor((i-510)/D)+1;
%   for k=1:size(E,3)
%     xAbs(:,:,i+k-1) = repmat(F{4}(:,:,j)'*E(:,:,k), H, 1);
%   end
% end


[~,~,yis] = histcounts(X, 10);
xRel = yis;
end


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

% Divide pixel-level features into patches at different resolutions 
ca{1} = patches(E,patchWidth,patchHeight);
ca{2} = patches(E,patchWidth*3,patchHeight*3);
ca{3} = patches(E,patchWidth*9,patchHeight*9);
cols = patches(E,patchWidth,floor(size(Y,1)/4));

% Sum values in patch partitions and construct an absolute feature
% vector for each patch (see Saxena et. al Figure 3).
xAbs = zeros(size(ca{1},1),size(ca{1},2),D*19);
k = 1;

% Add scale 1x, 3x, and 9x patches
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

% Add column patches
[px,py,~] = size(ca{1});
for i = 1:px
  m = k;
  xAbs(i,:,m:m+33) = repmat(sum(cols{i,1},1:2),1,py); m = m+34;
  xAbs(i,:,m:m+33) = repmat(sum(cols{i,2},1:2),1,py); m = m+34;
  xAbs(i,:,m:m+33) = repmat(sum(cols{i,3},1:2),1,py); m = m+34;
  xAbs(i,:,m:m+33) = repmat(sum(cols{i,4},1:2),1,py); m = m+34;
end

% Compute relative feature vector by binning each of 17 features into
% 10 bins at each scale.
offsets = [0 170 340];
for i = 1:3
  for k = 1:17
    imFeat = xAbs(:,:,offsets(i)+k);
    [~,~,bins] = histcounts(imFeat,10);
    [y,x,val] = find(bins);
    xRel{i,k} = zeros(max(y),max(x),'int8');
    idx = sub2ind(size(xRel{i,k}), y, x);
    xRel{i,k}(idx)=val;
  end
end
end

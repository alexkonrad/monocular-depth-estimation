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
% Create WxHx34 feature vector computed for each patch to create
% 34 * 19 = 646 patch-level features.
YX = abs(image(:,:,:,1) .* X);
YX2 = abs(YX .* YX);
E = cat(4,YX,YX2);
[N,H,W,D] = size(E);
clear YX YX2;
pH = patchHeight;
pW = patchWidth;
xAbs = zeros(N,H/pH,W/pW,D*19);
for i = 0:2
  j = 3^i;
  k = 170*i+1;
  a0 = k:k+D-1;
  a1 = a0(end)+1:a0(end)+D;
  a2 = a1(end)+1:a1(end)+D;
  a3 = a2(end)+1:a2(end)+D;
  a4 = a3(end)+1:a3(end)+D;
  dims = [N H/(pH*j) (pH*j) W/(pW*j) (pW*j) D];
  xAbs(:,:,:,a0) = repelem(squeeze(sum(reshape(E,dims),[3 5])),1,j,j,1);
  xAbs(:,:,2:end,a1) = xAbs(:,:,1:end-1,a0);
  xAbs(:,:,1:end-1,a2) = xAbs(:,:,2:end,a0);
  xAbs(:,2:end,:,a3) = xAbs(:,1:end-1,:,a0);
  xAbs(:,1:end-1,:,a4) = xAbs(:,2:end,:,a0);
end
k = 170*3+1;
q1 = k:k+D-1;
q2 = q1(end)+1:q1(end)+D;
q3 = q2(end)+1:q2(end)+D;
q4 = q3(end)+1:q3(end)+D;
dims = [N 4 H/4 W/pW pW D];
xCols = repelem(squeeze(sum(reshape(E,dims),[3 5])),1,H/(4*pH),1,1);
xAbs(:,:,:,q1) = repmat(xCols(:,1,:,:),1,H/pH);
xAbs(:,:,:,q2) = repmat(xCols(:,2,:,:),1,H/pH);
xAbs(:,:,:,q3) = repmat(xCols(:,3,:,:),1,H/pH);
xAbs(:,:,:,q4) = repmat(xCols(:,4,:,:),1,H/pH);
clear xCols;

xRel = zeros(N,H/pH,W/pW,17,3,'logical');
imFeat = xAbs(:,:,:,[1:17 170:186 340:356]);
for i=1:N
  for j=0:2
    for k=0:16
      l = 17*j+k+1;
      [~,~,bins] = histcounts(squeeze(imFeat(i,:,:,l)),10);
      xRel(i,:,:,k+1,j+1) = bins;
    end
  end
end
clear imFeat;


%       [y,x,val] = find(bins);
%       idx = sub2ind(max(y)*max(x), y, x);
%       xRel(i,y,x,k+1,j+1) = val;
% % xAbs(:,:,:,1:19) = E(:,:,:
% 
% 
% % Divide pixel-level features into patches at different resolutions
% ca{1} = patches(E,patchHeight, patchWidth);
% ca{2} = patches(E,patchHeight*3,patchWidth*3);
% ca{3} = patches(E,patchHeight*9,patchWidth*9);
% cols = patches(E,floor(size(image,2)/4),patchWidth);
% 
% % Sum values in patch partitions and construct an absolute feature
% % vector for each patch (see Saxena et. al Figure 3).
% xAbs = zeros(size(ca{1},1),size(ca{1},2),D*19);
% k = 1;
% 
% % Add scale 1x, 3x, and 9x patches
% for l = 1:size(ca,2)
%   [px,py,~] = size(ca{l});
%   m = k+33;
%   for i = 1:px
%     for j = 1:py
%       xRange = l*(i-1)+1:l*i;
%       yRange = l*(j-1)+1:l*j;
%       xAbs(xRange,yRange,k:m) = repmat(sum(ca{l}{i,j},1:2),numel(xRange),numel(yRange));
%     end
%   end
%   m = m+1;
%   xAbs(:,2:end,m:m+33) = xAbs(:,1:end-1,k:k+33); m = m+34;
%   xAbs(:,1:end-1,m:m+33) = xAbs(:,2:end,k:k+33); m = m+34;
%   xAbs(2:end,:,m:m+33) = xAbs(1:end-1,:,k:k+33); m = m+34;
%   xAbs(1:end-1,:,m:m+33) = xAbs(2:end,:,k:k+33); m = m+34;
%   k = m;
% end
% 
% % Add column patches
% [px,py,~] = size(ca{1});
% for i = 1:py
%   m = k;
%   xAbs(i,:,m:m+33) = repmat(sum(cols{1,i},1:2),1,py); m = m+34;
%   xAbs(i,:,m:m+33) = repmat(sum(cols{2,i},1:2),1,py); m = m+34;
%   xAbs(i,:,m:m+33) = repmat(sum(cols{3,i},1:2),1,py); m = m+34;
%   xAbs(i,:,m:m+33) = repmat(sum(cols{4,i},1:2),1,py); m = m+34;
% end
% 
% % Compute relative feature vector by binning each of 17 features into
% % 10 bins at each scale.
% offsets = [0 170 340];
% for i = 1:3
%   for k = 1:17
%     imFeat = xAbs(:,:,offsets(i)+k);
%     [~,~,bins] = histcounts(imFeat,10);
%     [y,x,val] = find(bins);
%     xRel{i,k} = zeros(max(y),max(x),'int8');
%     idx = sub2ind(size(xRel{i,k}), y, x);
%     xRel{i,k}(idx)=val;
%   end
% end
end

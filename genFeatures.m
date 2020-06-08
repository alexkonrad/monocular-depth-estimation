function [xAbs,xRel] = genFeatures(X, height, width)
% Compute patch dimensions and generate absolute and relative feature
% vectors.
%
% Inputs:
%      X: image data
%      height: number of patches to generate
%      width:  number of patches to generate
%
% Outputs:
%      xAbs: Absolute features
%      xRel: Relative features
xH = size(X,2);
xW = size(X,3);
patchHeight = floor(xH/height);
patchWidth = floor(xW/width);
croppedHeight = patchHeight*height;
croppedWidth = patchWidth*width;

X = X(:,1:croppedHeight,1:croppedWidth,:);

xFeat = pixelFeatures(X);
[xAbs,xRel] = patchFeatures(xFeat, X, patchHeight, patchWidth);
end
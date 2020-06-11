function [ll,grad] = likelihoodBatch(theta)
% Calculate likelihood and gradient in batches
%
% Inputs:
%     imgDir: Directory of training image .mat files
%     depthDir: Directory of training depth map .mat files
%
% Outputs:
%     ll: Negative log-likelihood
%     grad: Gradient of likelihood
dataFiles = dir(fullfile('data/', '*.mat'));
ll = 0;
grad = zeros(646,1);
for i = 1:numel(dataFiles)
  dataFilename = strcat('data/', dataFiles(i).name);
  D = load(dataFilename);
  fprintf("Computing likelihood for batch %d\n", i);
  [iterLl, iterGrad] = likelihood2(theta, D.xAbs, D.Y);
  ll = ll + iterLl;
  grad = grad + iterGrad;
end
end


function [thetaML] = trainRows(H)
% Load each row of the dataset and train a theta parameter for it
%
% Inputs:
%       H: height of patch-image
% Outputs:
%       thetaML: Hx646 feature vector
%
thetaML = zeros(H,646);
r1 = 1:170;
r2 = 171:340;
r3 = 341:646;
for i = 1:H
  fprintf("Training row %d\n", i);
  load([pwd '/data/row' num2str(i, '%03.f') '.mat'], 'XS', 'YS');
  X = reshape(XS, [], 646);
  Y1 = reshape(YS(:,:,1),[],1);
  Y2 = reshape(YS(:,:,2),[],1);
  Y3 = reshape(YS(:,:,3),[],1);
%   thetaML(i,r1) = X(:,r1) \ Y1;
%   thetaML(i,r2) = X(:,r2) \ Y2;
%   thetaML(i,r3) = X(:,r3) \ Y3;
  thetaML(i,:) = X \ Y1;

%   Y = reshape(YS, [], 3);
%   thetaML(i,:) = X \ Y;
  clear XS YS X Y;
end
end



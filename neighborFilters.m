function [f0,f1,f2,f3,f4] = neighborFilters(patchSize)
% Return 5 filters to select neighboring patches on the pixels.
% 
% Inputs:
%    patchSize: pick out a patchSize x patchSize patch
% 
% Outputs:
%    f0: Center patch
%    f1: Top patch
%    f2: Bottom patch
%    f3: Left patch
%    f4: Right patch

Z = zeros(patchSize,patchSize);
O = ones(patchSize,patchSize)/patchSize;

f0 = [
  Z Z Z
  Z O Z
  Z Z Z
];

f1 = [
  Z O Z
  Z Z Z
  Z Z Z
];

f2 = [
  Z Z Z
  Z Z Z
  Z O Z
];

f3 = [
  Z Z Z
  O Z Z
  Z Z Z
];

f4 = [
  Z Z Z
  Z Z O
  Z Z Z
];
end


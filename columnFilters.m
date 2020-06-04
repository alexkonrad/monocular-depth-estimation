function [f1,f2,f3,f4] = columnFilters(H)
% Return 4 filters to select vertical portions in a column of the image
% 
% Inputs:
%    H: height of column
% 
% Outputs:
%    f1: Top quartile
%    f2: Top-middle quartile
%    f3: Middle-bottom quartile
%    f4: Bottom quartile
Z = zeros(floor(H/4), 1);
O = ones(floor(H/4), 1);

f1 = [O;Z;Z;Z];
f2 = [Z;O;Z;Z];
f3 = [Z;Z;O;Z];
f4 = [Z;Z;Z;O];
end


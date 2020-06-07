function [ca] = patches(image, blockSizeR, blockSizeC)
% Divide the image into patches
%
% Inputs:
%     image: image
%     blockSizeR: height of patch in number of rows
%     blockSizeC: width of patch in number of columns
%
% Outputs:
%     p: Cell array of patches
[rows columns numberOfColorBands] = size(image);

% Figure out the size of each block in rows.
% Most will be blockSizeR but there may be a remainder amount of less than that.
wholeBlockRows = floor(rows / blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];
% Figure out the size of each block in columns.
wholeBlockCols = floor(columns / blockSizeC);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];

% Create the cell array, ca. 
% Each cell (except for the remainder cells at the end of the image)
% in the array contains a blockSizeR by blockSizeC by 3 color array.
% This line is where the image is actually divided up into blocks.
if numberOfColorBands > 1
    % It's a color image.
    ca = mat2cell(image, blockVectorR, blockVectorC, numberOfColorBands);
else
    ca = mat2cell(image, blockVectorR, blockVectorC);
end

end


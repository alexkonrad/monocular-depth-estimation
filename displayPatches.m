function displayPatches(ca)
% Display image patches with grid
figure;
imshow(ycbcr2rgb(cell2mat(ca)));
hold on;
[rows,columns,~] = size(ca);
[rowWidth, colWidth, ~] = size(ca{1,1});
for row = 1 : rows
  r = row * rowWidth;
  line([1, columns * colWidth], [r, r], 'Color', 'w');
end
for col = 1 : columns
  c = col * colWidth;
  line([c, c], [1, rows * rowWidth], 'Color', 'w');
end
drawnow;
end


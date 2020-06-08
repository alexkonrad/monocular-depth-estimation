
%% Display images

% for i = 1:2:4
%   subplot(10,2,i);
%   imagesc(squeeze(trainX(i,:,:,:)));
%   set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
%   axis equal;
%   subplot(10,2,i+1);
%   imagesc(squeeze(trainY(i,:,:)));
%   set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
%   axis equal;
% end
%% Display filters
% figure
% montage(rescale(xAbs(:,:,1:34*5)), 'Size', [10 17])
% figure
% montage(rescale(xAbs(:,:,(34*5)+1:34*10)), 'Size', [10 17])
% figure
% montage(rescale(xAbs(:,:,(34*10)+1:34*15)), 'Size', [10 17])
% figure
% montage(rescale(xAbs(:,:,(34*15)+1:end)), 'Size', [8 17])

%% KITTI
% V = "depth_selection/val_selection_cropped/";
% IMG = "image/";
% GTR = "groundtruth_depth/";
% groundtruth = dir(V+GTR);
% images = dir(V+IMG);
% gtr = groundtruth(3).name;
% img = images(3).name
% RGB = imread(V+IMG+img);
% D = imread(V+GTR+gtr);
% figure; imshow(RGB);
% figure; imshow(D);

% for f = groundtruth
%   if ~endsWith(f.name, '.png')
%     continue
%   end
%   
% end

% Depth data

% load('depth/test.mat');
% D = Position3DGrid(:,:,4);
% figure; imshow(rescale(D));


function [depths] = upperScaleDepth(depth)

num_scales = 3;
depths =  zeros(size(depth,1),size(depth,2),size(depth,3),num_scales);
depths(:,:,:,1) = depth;
depths(:,:,:,2) = depth;
depths(:,:,:,3) = depth;

H = size(depths,2);
W = size(depths,3);
    for depth = [2,3]
        for p_y = 2:H-1
            for p_x = 2:W-1
                n1 = depths(:,p_y,p_x +1,1);          %Right neighbour
                n2 = depths(:,p_y,p_x -1,1);          %Left neighbour
                n3 = depths(:,p_y-1,p_x,1);         %Upper neighbour
                n4 = depths(:,p_y+1,p_x,1);         %Lower neighbour
                sum = n1+n2+n3+n4+depths(:,p_y,p_x,1);
                avg = sum./5;
                depths(:,p_y,p_x,depth) = avg;  
            end
        end
    end
end


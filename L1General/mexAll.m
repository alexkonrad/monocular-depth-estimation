% minFunc
fprintf('Compiling minFunc files...\n');
mex -compatibleArrayDims minFunc/mcholC.c
mex -compatibleArrayDims minFunc/lbfgsC.c
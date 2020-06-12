%% Visualize filters

dirac = zeros(20,20);
dirac(10,10) = 1;
Y = dirac;

image=rgb2ycbcr(imread('bridge.jpg'));
Y=image(:,:,1);

L3 = [ .5 1  .5];
E3 = [-1 0  1];
S3 = [-1 2 -1];
NB1 = [
  -100, -100, 0, 100, 100
  -100, -100, 0, 100, 100
  -100, -100, 0, 100, 100
  -100, -100, 0, 100, 100
  -100, -100, 0, 100, 100
];
NB2 = [
  -100,  32, 100, 100, 100
	-100, -78,  92, 100, 100
	-100,-100,   0, 100, 100
	-100,-100, -92,  78, 100
	-100,-100,-100, -32, 100
];
NB3 = -NB2';
NB4 = -NB1';
NB5 = -NB3(end:-1:1,:);
NB6 = NB5';
x1=conv2(Y, L3'*L3, 'same');
x2=conv2(Y, L3'*E3, 'same');
x3=conv2(Y, L3'*S3, 'same');
x4=conv2(Y, E3'*L3, 'same');
x5=conv2(Y, E3'*E3, 'same');
x6=conv2(Y, E3'*S3, 'same');
x7=conv2(Y, S3'*L3, 'same');
x8=conv2(Y, S3'*E3, 'same');
x9=conv2(Y, S3'*S3, 'same');
x10=conv2(image(:,:,2), L3*L3', 'same');
x11=conv2(image(:,:,3), L3*L3', 'same');
x12=conv2(Y, NB1, 'same');
x13=conv2(Y, NB2, 'same');
x14=conv2(Y, NB3, 'same');
x15=conv2(Y, NB4, 'same');
x16=conv2(Y, NB5, 'same');
x17=conv2(Y, NB6, 'same');

montage(cat(3,image(:,:,1),image(:,:,2),image(:,:,3),x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17));


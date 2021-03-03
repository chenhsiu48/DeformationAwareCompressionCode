function [ map ] = GenerateAlphaMap( y )

load('edges-master\models\forest\modelBsds.mat');
E=edgesDetect(y,model);
hs = fspecial('gaussian',20,10);
map = conv2(double(E),hs,'same');

end

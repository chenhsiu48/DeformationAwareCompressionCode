function[yWarp,ux,uy] = OpticalFlow(x,y,alpha,ux,uy)

if not(exist('ux','var'))
    ux = zeros(size(y,1),size(y,2));
    uy = zeros(size(y,1),size(y,2)); 
end

%optical flow parameters initialization:
nOuterFPIterations = 3;
nInnerFPIterations = 1;
nSORIterations = 30;
ratio = 0.75;
minWidth = min(20, size(y, 2));

%computing the flow:
para = [ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];
[ux,uy] = OneLevelTwoFramesL2L2SP_Map(x, y, para, ux, uy , alpha, 1e-3, 1e-6);

%warping the image:
[yWarp, mask] = warpImage(y, ux, uy);
end
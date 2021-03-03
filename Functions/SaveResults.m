function [] = SaveResults( ResDir, x_GEM, x_original, y_GEM, y, R, comp_method)
if (max(x_GEM(:))>2), x_GEM = x_GEM/255; x_original = x_original/255; end
if (~exist(ResDir ,'dir')), mkdir(ResDir); end
imwrite(x_GEM,[ResDir '\x_DeformationAware.png']);
imwrite(x_original,[ResDir '\x_original.png']);
imwrite(y_GEM,[ResDir '\y.png']);
imwrite(y,[ResDir '\Input.png'],'png');
compwrite(y,R,[ResDir '\x_original'],comp_method);
compwrite(y_GEM,R,[ResDir '\x_DeformationAware'],comp_method);
end


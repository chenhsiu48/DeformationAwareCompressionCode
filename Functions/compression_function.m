function [ y_out ] = compression_function(y,R,method,file_name)
if ~exist ('file_name','var'), file_name = 'temp_'; end
if ~exist('method','var'), method = 'jp2'; end
switch method
    case 'jpeg'
        compwrite(y,R,['tempFiles\' file_name method],method);
        y_out = im2double(imread(['tempFiles\' file_name method '.jpg']));
    case 'jp2'
        compwrite(y,R,['tempFiles\' file_name method],method);
        y_out = im2double(imread(['tempFiles\' file_name method '.jp2']));
    case 'WebP'
        compwrite(y,R,['tempFiles\' file_name method],method);
        y_out = im2double(cv.imread(['tempFiles\' file_name method '.webp']));
    case 'BPG' 
        compwrite(y,R,['tempFiles\' file_name method],method);
        y_out = im2double(imread(['tempFiles\' file_name method '.png']));
    case 'NN'
        compwrite(y,R,['tempFiles\' file_name method],method);
        y_out = im2double(imread(['CompressionFunctions\NN\Res_' file_name method  '\image_0' num2str(R) '.png']));
end    
end

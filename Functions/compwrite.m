function Csize = compwrite(y,R,direc,method)
switch method
    case 'jpeg'
        imwrite(y,[ direc '.jpg'],'jpeg','Quality',R);
        s = dir([ direc '.jpg']);
        Csize = s.bytes;
    case 'jp2'
        imwrite(y,[ direc '.jp2'],'CompressionRatio',R);
        s = dir([ direc '.jp2']);
        Csize = s.bytes;
    case 'WebP'
        cv.imwrite([ direc '.webp'],255*y,'WebpQuality',R);
        s = dir([ direc '.webp']);
        Csize = s.bytes;
    case 'BPG'
        com = ['CompressionFunctions\bpg\bpgenc.exe -o ' direc '.bpg -q ' num2str(R) ' ' direc '.png'];
        dos(com);
        com = ['CompressionFunctions\bpg\bpgdec.exe -o ' direc '.png ' direc '.bpg'];
        dos(com);
        s = dir([ direc '.bpg']);
        Csize = s.bytes;
    case('NN')
        com = ['python CompressionFunctions\NN\encoder.py --input_image=' direc '.png --output_codes=CompressionFunctions\NN\output_codes.npz --iteration=15 --model=CompressionFunctions\NN\compression_residual_gru\residual_gru.pb'];
        dos(com);
        com2 = ['python CompressionFunctions\NN\decoder.py --input_codes=CompressionFunctions\NN\output_codes.npz --output_directory=CompressionFunctions\NN\Res_' direc ' --model=CompressionFunctions\NN\compression_residual_gru\residual_gru.pb'];
        dos(com2);
        s = dir(['CompressionFunctions\NN\output_codes.npz']);
        Csize = s.bytes;
end
end

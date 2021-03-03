function [ compression_method , compression_parameters] = choose_compMethod

compression_methods = {'jp2';'jpeg';'WebP';'BPG';'NN'}; 

disp('Chose a compression method from the list below:');
disp('1 - JPEG2000');
disp('2 - JPEG'); 
disp('3 - WebP');
disp('4 - BPG');
disp('5 - Toderici et al.');

disp('Type a prior number (for example 3 for ''WebP''):'); 
compression_num = input(sprintf('Compression Method Number: '),'s');
compression_num = sscanf(compression_num, '%d');
compression_method = compression_methods{compression_num};

% chosing the Deformation Aware Process Parameters: 
% compression_parameters = {start_ratio,ratio_steps,final_ratio,save_resolution,alpha}
switch compression_method
    case 'jp2'
        compression_parameters = {20,5,200,25,3};
    case 'jpeg'
        compression_parameters = {50,-1,1,1,20};
    case 'WebP'
        compression_parameters = {50,-1,1,1,6};
    case 'BPG'
        compression_parameters = {30,1,50,1,6};
    case 'NN'
        compression_parameters = {5,-1,0,1,6};
end
compression_parameters{6} = compression_method;

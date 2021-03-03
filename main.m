clear; close all; clc;
addpath(genpath('..\DeformationAwareCompressionCode'));
files = dir('Images');

%Parameters:
global to_plot; to_plot = 1;
global ImName;

%---You can chose your own compression method!---%
[compMethod , CompParameters]= choose_compMethod;

% User input - image number:
img_num = choose_image(files);
ImName = files(img_num).name(1:end-4);
disp(['image: ' ImName ', Compression Method: ' compMethod]);

% Read the image:
y = im2double(imread(['Images\' files(img_num).name]));

% Deformation Aware Compression:
comp_func =  @(y,R) compression_function(y,R,compMethod);
DeformationAwareCompression(y,comp_func,CompParameters);
       

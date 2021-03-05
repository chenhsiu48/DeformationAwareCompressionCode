clear; close all; clc;
addpath(genpath('.'));
files = dir('Images');

%Parameters:
global to_plot; to_plot = 1;
global ImName;

%---You can chose your own compression method!---%
%[compMethod , CompParameters]= choose_compMethod;
compMethod = 'jp2'
CompParameters = {20, 20, 160, 1, 6, 'jp2'}

% User input - image number:
%img_num = choose_image(files);
raw_name = 'kodim04.png'
ImName = raw_name(1:end-4);
disp(['image: ' ImName ', Compression Method: ' compMethod]);

% Read the image:
y = im2double(imread(['Images\' raw_name]));

% Deformation Aware Compression:
comp_func =  @(y,R) compression_function(y,R,compMethod);
DeformationAwareCompression(y,comp_func,CompParameters);


times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.004  000.004: --- VIM STARTING ---
000.060  000.056: Allocated generic buffers
000.077  000.017: locale set
000.083  000.006: GUI prepared
000.087  000.004: clipboard setup
000.090  000.003: window checked
000.360  000.270: inits 1
000.377  000.017: parsing arguments
000.378  000.001: expanding arguments
000.385  000.007: shell init
1000.627  1000.242: xsmp init
1001.489  000.862: Termcap init
1001.601  000.112: inits 2
1002.031  000.430: init highlight
1002.927  000.668  000.668: sourcing /usr/share/vim/vim81/debian.vim
1006.113  002.520  002.520: sourcing /usr/share/vim/vim81/syntax/syncolor.vim
1006.411  002.994  000.474: sourcing /usr/share/vim/vim81/syntax/synload.vim
1010.088  003.654  003.654: sourcing /usr/share/vim/vim81/filetype.vim
1010.126  007.053  000.405: sourcing /usr/share/vim/vim81/syntax/syntax.vim
1010.139  008.021  000.300: sourcing $VIM/vimrc
1010.355  000.105  000.105: sourcing /usr/share/vim/vim81/syntax/syncolor.vim
1010.397  000.245  000.140: sourcing $HOME/.vimrc
1010.399  000.102: sourcing vimrc file(s)
1010.627  000.045  000.045: sourcing /usr/share/vim/vim81/plugin/getscriptPlugin.vim
1010.763  000.128  000.128: sourcing /usr/share/vim/vim81/plugin/gzip.vim
1010.907  000.136  000.136: sourcing /usr/share/vim/vim81/plugin/logiPat.vim
1010.933  000.018  000.018: sourcing /usr/share/vim/vim81/plugin/manpager.vim
1011.051  000.111  000.111: sourcing /usr/share/vim/vim81/plugin/matchparen.vim
1011.428  000.369  000.369: sourcing /usr/share/vim/vim81/plugin/netrwPlugin.vim
1011.469  000.023  000.023: sourcing /usr/share/vim/vim81/plugin/rrhelper.vim
1011.494  000.016  000.016: sourcing /usr/share/vim/vim81/plugin/spellfile.vim
1011.610  000.107  000.107: sourcing /usr/share/vim/vim81/plugin/tarPlugin.vim
1011.679  000.055  000.055: sourcing /usr/share/vim/vim81/plugin/tohtml.vim
1011.812  000.123  000.123: sourcing /usr/share/vim/vim81/plugin/vimballPlugin.vim
1011.958  000.124  000.124: sourcing /usr/share/vim/vim81/plugin/zipPlugin.vim
1011.961  000.307: loading plugins
1012.003  000.042: loading packages
1012.026  000.023: loading after plugins
1012.038  000.012: inits 3
1012.203  000.165: reading viminfo
1013.405  001.202: setup clipboard
1013.409  000.004: setting raw mode
1013.415  000.006: start termcap
1013.424  000.009: clearing screen
1013.793  000.369: opening buffers
1013.819  000.026: BufEnter autocommands
1013.820  000.001: editing files in windows
1013.894  000.074: VimEnter autocommands
1013.895  000.001: before starting main loop
1014.248  000.353: first screen update
1014.249  000.001: --- VIM STARTED ---

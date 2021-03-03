Before compiling, please check project.h file in subfolder "mex". You don't have to do anything if you use Windows. If you use Mac Os or Linux, please uncomment the line 
#define _LINUX_MAC

In Matlab, after you configure mex appropriately, change directory to "mex" and run the following command:
 
mex OneLevelTwoFramesL2L2SP_Map.cpp OpticalFlow.cpp GaussianPyramid.cpp


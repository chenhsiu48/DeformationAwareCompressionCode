==============================================================================================

This code implements the algorithm described in the paper:
		
		"Deformation Aware Image Compression", CVPR 2018
			by Tamar Rott Shaham and Tomer Michaeli

->->->->->-> You can use deformation awarness with any Compression method! <-<-<-<-<-<-     

==============================================================================================
Quick Start
==============================================================================================

1. Run thr main.m matlab file
2. To add more images, copy your input images to the "Images" folder.
3. output images are saved to "Out" folder.
4. You can use your own compression method. See explenation below.

==============================================================================================
Before Starting
==============================================================================================

1. For using the WebP CODEC, please run first the cammand "mexopencv.make" from the matlab command line.
(make sure that the folder "CompressionFunctions\mexopencv-master" is included in your path)

2. For using the NN-based CODEC by Toderici et al., python is needed.

3. If you whish to run this code on Linux or MAC, please recompile the following functions:
- optical flow function according to the readme file on "OpticalFlowL2L2init_alphaMap" folder
- edge detection function according to the readme file on "edges-master" folder

==============================================================================================
Contents
==============================================================================================

The package comprises these functions

*) DeformationAwareCompression.m: 
   - Description: gets an image and returns its deformation aware compressed version according to the given compression model.
   - Inputs:  y - input image (double in the range of [0,1]) 
              comp_func - function handle of the compression method (encoding and decoding)
			  compression_parameters = the parameter of the Deformation Aware Compression method for the specified compressor.
   - Outputs: x - compressed image
			  ux,uy - the idealized deformation x-direction and y-direction fllow fields
*) compression_function.m
   - Description: decode and incude the image according to the specific compression algorithn.
   - Inputs:  y - input image
              R - compression ratio\quality factor
              method - compression method name
			  file_name - the name of the temporary file
   - Outputs: y_out - the compressed image
*) compwrite.m
   - Description: save the compression image
   - Inputs:  y - input image
              R - compression ratio\quality factor
			  direc - directory to save
              method - compression method name
*) GenerateAlphaMap.m
   - Description: generate the regularization map according to the input image
   - Inputs:  y - input image
   - Outputs: map - the regularization map
              ux,uy - the final deformation fllow fields 					   
*) OpticalFlow.m
   - Description: Optical Flow estimation between two images 
   - Inputs:  x - source image
              y - image to deform
              alpha - smoothness regularization map
              ux,uy - fllow fields initialization (default = zeros(size(y)) for gray images)
   - Outputs: yWarp - the deformed output image
              ux,uy - the final deformation fllow fields 
*) warpImage.m
   - Description: Warp an image according to fllow fields
   - Inputs:  im - image to warp
              ux,uy - the warpping deformatiom fllow fields  
              val - optional- constant value for pixels dragged from outside the image 
   - Outputs: warpI2 - the deformed output image 
              mask - coordinates of pixels dragged from outside the image

			  
==============================================================================================
Use Deformation Awarness with your own compression algorithm
==============================================================================================
To run deformation awarness with your own compression method, you need to define a function 
handle named "comp_func" which compressed the input imagage "y" with a specified ratio "R". 
for example:
 
comp_func =  @(y,R) compression_function(y,R,compMethod);

you should also define the deformation aware process parameters:
compression_parameters = {start_ratio,ratio_steps,final_ratio,save_resolution,alpha,Name}
recomended parameters: alpha = 6;
					   Name = 'MyOwn';
The starting compression ration, final compression ratio and the gradual process steps should 
be define according to your specific method.


==============================================================================================
Feedback
==============================================================================================

If you have any comment, suggestion, or question, please do
contact Tamar: stamarot at campus.technion.ac.il


==============================================================================================
Citation
==============================================================================================
   
If you use this code in a scientific project, you should cite the following paper in any
resulting publication:

Tamar Rott Shaham and Tomer Michaeli, "Deformation Aware Image Compression", CVPR 2018.


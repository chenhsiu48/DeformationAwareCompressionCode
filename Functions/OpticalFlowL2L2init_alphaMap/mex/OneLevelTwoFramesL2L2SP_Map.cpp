#include "mex.h"
#include "project.h"
#include "Image.h"
#include "OpticalFlow.h"
#include <iostream>

using namespace std;

// void LoadImage(DImage& image,const mxArray* matrix)
// {
// 	if(mxIsClass(matrix,"uint8"))
// 	{
// 		image.LoadMatlabImage<unsigned char>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"int8"))
// 	{
// 		image.LoadMatlabImage<char>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"int32"))
// 	{
// 		image.LoadMatlabImage<int>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"uint32"))
// 	{
// 		image.LoadMatlabImage<unsigned int>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"int16"))
// 	{
// 		image.LoadMatlabImage<short int>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"uint16"))
// 	{
// 		image.LoadMatlabImage<unsigned short int>(matrix);
// 		return;
// 	}
// 	if(mxIsClass(matrix,"double"))
// 	{
// 		image.LoadMatlabImage<double>(matrix);
// 		return;
// 	}
// 	mexErrMsgTxt("Unknown type of the image!");
// }

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
//	// check for proper number of input and output arguments
//	if(nrhs<2 || nrhs>3)
//		mexErrMsgTxt("Only two or three input arguments are allowed!");
//	if(nlhs<2 || nlhs>3)
//		mexErrMsgTxt("Only two or three output arguments are allowed!");
	DImage Im1,Im2, vx, vy, alpha;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~TAMAR~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	double SumPhi;

    Im1.LoadMatlabImage(prhs[0]);
    Im2.LoadMatlabImage(prhs[1]);
    vx.LoadMatlabImage(prhs[3]);
    vy.LoadMatlabImage(prhs[4]);
	alpha.LoadMatlabImage(prhs[5]); //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~TAMAR~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   
    //LoadImage(Im1,prhs[0]);
	//LoadImage(Im2,prhs[1]);
	//mexPrintf("width %d   height %d   nchannels %d\n",Im1.width(),Im1.height(),Im1.nchannels());
	//mexPrintf("width %d   height %d   nchannels %d\n",Im2.width(),Im2.height(),Im2.nchannels());
	if(Im1.matchDimension(Im2)==false)
		mexErrMsgTxt("The two images don't match!");
	
	// get the parameters
	//double alpha= 1; //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~TAMAR~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    double beta = 0.0;
	double ratio=0.5;
	int minWidth= 40;
	int nOuterFPIterations = 3;
	int nInnerFPIterations = 1;
	int nSORIterations= 20;
    double varepsilon_phi = 0.01;
    double varepsilon_psi = 0.01;
	if(nrhs>2)
	{
		int nDims=mxGetNumberOfDimensions(prhs[2]);
		const int *dims=mxGetDimensions(prhs[2]);
		double* para=(double *)mxGetData(prhs[2]);
		int npara=dims[0]*dims[1];
		if(npara>0)
			//alpha=para[0];//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~TAMAR~!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
		if(npara>1)
			ratio=para[0];
		if(npara>2)
			minWidth=para[1];
		if(npara>3)
			nOuterFPIterations=para[2];
		if(npara>4)
			nInnerFPIterations=para[3];
		if(npara>5)
			nSORIterations = para[4];
        if(npara>6)
			beta=para[5];
	}
    
    if(nrhs>5)
          varepsilon_phi = mxGetScalar(prhs[5]);
    
    if(nrhs>6)
         varepsilon_psi = mxGetScalar(prhs[6]);
     	//mexPrintf("%f %f %f \n", varepsilon_phi, varepsilon_psi, beta);
//	mexPrintf("alpha: %f   ratio: %f   minWidth: %d  nOuterFPIterations: %d  nInnerFPIterations: %d   nCGIterations: %d\n",alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nCGIterations);
//    vx,vy
	DImage warpI2, foo1;
    int width=Im2.width();
	int height=Im2.height();
    warpI2.allocate(width, height);
	OpticalFlow::Coarse2FineFlowTali(vx,vy,warpI2,Im1,Im2,SumPhi,alpha,nOuterFPIterations,nInnerFPIterations,nSORIterations, varepsilon_phi, varepsilon_psi); //OneLevel
	//OpticalFlow::Coarse2FineFlow(vx, vy, warpI2, Im1, Im2, SumPhi, alpha, ratio, minWidth, nOuterFPIterations, nInnerFPIterations, nSORIterations, varepsilon_phi, varepsilon_psi); //Pyramid

   // OpticalFlow::SmoothFlowSOR(Im1,Im2,warpI2,vx,vy,alpha,nOuterFPIterations,nInnerFPIterations,nSORIterations);
	// output the parameters
	vx.OutputToMatlab(plhs[0]);
	vy.OutputToMatlab(plhs[1]);
	if(nlhs>2)
		warpI2.OutputToMatlab(plhs[2]);
    if(nlhs>3)
	{
		plhs[3] = mxCreateDoubleScalar(SumPhi);
	}
		//foo1.OutputToMatlab(plhs[3]);
	//{ 
		//int dims[2];
		//dims[0] = 1;
		//dims[1] = 1;
		//plhs[3] = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);
		//*plhs[3] = SumPhi;
		//p = (float*)mxGetPr(plhs[3]);
		//*p = SumPhi;
	//}
	//{
		//foo1.OutputToMatlab(plhs[3]);
		//matrix = mxCreateNumericArray(2, dims, mxDOUBLE_CLASS, mxREAL);
	//}
}
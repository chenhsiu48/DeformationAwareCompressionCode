/**
 * @file cornerHarris.cpp
 * @brief mex interface for cv::cornerHarris
 * @ingroup imgproc
 * @author Kota Yamaguchi
 * @date 2011
 */
#include "mexopencv.hpp"
using namespace std;
using namespace cv;

/**
 * Main entry called from Matlab
 * @param nlhs number of left-hand-side arguments
 * @param plhs pointers to mxArrays in the left-hand-side
 * @param nrhs number of right-hand-side arguments
 * @param prhs pointers to mxArrays in the right-hand-side
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // Check the number of arguments
    nargchk(nrhs>=1 && (nrhs%2)==1 && nlhs<=1);

    // Argument vector
    vector<MxArray> rhs(prhs, prhs+nrhs);

    // Option processing
    int blockSize = 5;
    int ksize = 3;
    double k = 0.04;
    int borderType = cv::BORDER_DEFAULT;
    for (int i=1; i<nrhs; i+=2) {
        string key(rhs[i].toString());
        if (key == "BlockSize")
            blockSize = rhs[i+1].toInt();
        else if (key == "KSize")
            ksize = rhs[i+1].toInt();
        else if (key == "K")
            k = rhs[i+1].toDouble();
        else if (key == "BorderType")
            borderType = BorderType[rhs[i+1].toString()];
        else
            mexErrMsgIdAndTxt("mexopencv:error",
                "Unrecognized option %s", key.c_str());
    }

    // Process
    Mat src(rhs[0].toMat(rhs[0].isUint8() ? CV_8U : CV_32F)), dst;
    cornerHarris(src, dst, blockSize, ksize, k, borderType);
    plhs[0] = MxArray(dst);
}

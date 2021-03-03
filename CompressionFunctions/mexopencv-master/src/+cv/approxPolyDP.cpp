/**
 * @file approxPolyDP.cpp
 * @brief mex interface for cv::approxPolyDP
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
    double epsilon = 2.0;
    bool closed = true;
    for (int i=1; i<nrhs; i+=2) {
        string key(rhs[i].toString());
        if (key == "Epsilon")
            epsilon = rhs[i+1].toDouble();
        else if (key == "Closed")
            closed = rhs[i+1].toBool();
        else
            mexErrMsgIdAndTxt("mexopencv:error",
                "Unrecognized option %s", key.c_str());
    }

    // Process
    if (rhs[0].isNumeric()) {
        Mat curve(rhs[0].toMat(rhs[0].isInt32() ? CV_32S : CV_32F)),
            approxCurve;
        approxPolyDP(curve, approxCurve, epsilon, closed);
        plhs[0] = MxArray(approxCurve.reshape(1,0));  // Nx2
    }
    else if (rhs[0].isCell()) {
        if (!rhs[0].isEmpty() && rhs[0].at<MxArray>(0).isInt32()) {
            vector<Point> curve(rhs[0].toVector<Point>()), approxCurve;
            approxPolyDP(curve, approxCurve, epsilon, closed);
            plhs[0] = MxArray(approxCurve);
        }
        else {
            vector<Point2f> curve(rhs[0].toVector<Point2f>()), approxCurve;
            approxPolyDP(curve, approxCurve, epsilon, closed);
            plhs[0] = MxArray(approxCurve);
        }
    }
    else
        mexErrMsgIdAndTxt("mexopencv:error", "Invalid points argument");
}

/**
 * @file imdecode.cpp
 * @brief mex interface for cv::imdecode
 * @ingroup imgcodecs
 * @author Kota Yamaguchi
 * @date 2012
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
    bool unchanged = false,
         anydepth = false,
         anycolor = false,
         color = true;
    int flags = 0;
    bool override = false;
    bool flip = true;
    for (int i=1; i<nrhs; i+=2) {
        string key(rhs[i].toString());
        if (key == "Flags") {
            flags = rhs[i+1].toInt();
            override = true;
        }
        else if (key == "Unchanged")
            unchanged = rhs[i+1].toBool();
        else if (key == "AnyDepth")
            anydepth = rhs[i+1].toBool();
        else if (key == "AnyColor")
            anycolor = rhs[i+1].toBool();
        else if (key == "Grayscale") {
            color = !rhs[i+1].toBool();
            anycolor = false;
        }
        else if (key == "Color") {
            color = rhs[i+1].toBool();
            anycolor = false;
        }
        else if (key == "FlipChannels")
            flip = rhs[i+1].toBool();
        else
            mexErrMsgIdAndTxt("mexopencv:error",
                "Unrecognized option %s", key.c_str());
    }

    // build flag value from options
    if (!override) {
        if (unchanged) {
            // depth and cn as is (as determined by decoder).
            // This is the only way to load alpha channel if present
            flags = cv::IMREAD_UNCHANGED;
        }
        else {
            // depth as is, otherwise CV_8U
            flags |= (anydepth ? cv::IMREAD_ANYDEPTH : 0);
            // channels as is (if gray then cn=1, else cn=3 [BGR])
            flags |= (anycolor ? cv::IMREAD_ANYCOLOR :
                // otherwise explicitly either cn = 3 or cn = 1
                (color ? cv::IMREAD_COLOR : cv::IMREAD_GRAYSCALE));
        }
    }

    // Process
    Mat buf(rhs[0].toMat(CV_8U));
    Mat img = imdecode(buf, flags);
    if (img.data == NULL)
        mexErrMsgIdAndTxt("mexopencv:error", "imdecode failed");
    if (flip && (img.channels() == 3 || img.channels() == 4)) {
        // OpenCV's default is BGR/BGRA while MATLAB's is RGB/RGBA
        cvtColor(img, img, (img.channels()==3 ?
            cv::COLOR_BGR2RGB : cv::COLOR_BGRA2RGBA));
    }
    plhs[0] = MxArray(img);
}

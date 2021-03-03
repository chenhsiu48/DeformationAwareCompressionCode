/**
 * @file circle.cpp
 * @brief mex interface for cv::circle
 * @ingroup imgproc
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
    nargchk(nrhs>=3 && (nrhs%2)==1 && nlhs<=1);

    // Argument vector
    vector<MxArray> rhs(prhs, prhs+nrhs);

    // Option processing
    Scalar color;
    vector<Vec4d> colors;
    int thickness = 1;
    int lineType = cv::LINE_8;
    int shift = 0;
    for (int i=3; i<nrhs; i+=2) {
        string key(rhs[i].toString());
        if (key == "Color")
            color = (rhs[i+1].isChar()) ?
                ColorType[rhs[i+1].toString()] : rhs[i+1].toScalar();
        else if (key == "Colors")
            colors = MxArrayToVectorVec<double,4>(rhs[i+1]);
        else if (key == "Thickness")
            thickness = (rhs[i+1].isChar()) ?
                ThicknessType[rhs[i+1].toString()] : rhs[i+1].toInt();
        else if (key == "LineType")
            lineType = (rhs[i+1].isChar()) ?
                LineType[rhs[i+1].toString()] : rhs[i+1].toInt();
        else if (key == "Shift")
            shift = rhs[i+1].toInt();
        else
            mexErrMsgIdAndTxt("mexopencv:error",
                "Unrecognized option %s", key.c_str());
    }

    // Process
    Mat img(rhs[0].toMat());
    if (rhs[1].isNumeric() && rhs[1].numel() == 2) {
        Point center(rhs[1].toPoint());
        int radius = rhs[2].toInt();
        circle(img, center, radius, color, thickness, lineType, shift);
    }
    else {
        vector<Point> centers(rhs[1].toVector<Point>());
        if (!colors.empty() && colors.size() != centers.size())
            mexErrMsgIdAndTxt("mexopencv:error", "Length mismatch");
        if (rhs[2].isNumeric() && rhs[2].numel() == 1) {
            int radius = rhs[2].toInt();
            for (size_t i = 0; i < centers.size(); ++i)
                circle(img, centers[i], radius,
                    (colors.empty() ? color : Scalar(colors[i])),
                    thickness, lineType, shift);
        }
        else {
            vector<int> radii(rhs[2].toVector<int>());
            if (radii.size() != centers.size())
                mexErrMsgIdAndTxt("mexopencv:error", "Length mismatch");
            for (size_t i = 0; i < centers.size(); ++i)
                circle(img, centers[i], radii[i],
                    (colors.empty() ? color : Scalar(colors[i])),
                    thickness, lineType, shift);
        }
    }
    plhs[0] = MxArray(img);
}

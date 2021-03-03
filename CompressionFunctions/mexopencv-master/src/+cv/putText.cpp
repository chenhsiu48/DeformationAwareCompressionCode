/**
 * @file putText.cpp
 * @brief mex interface for cv::putText
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
    int fontFace = cv::FONT_HERSHEY_SIMPLEX;
    int fontStyle = 0;
    double fontScale = 1.0;
    Scalar color;
    vector<Vec4d> colors;
    int thickness = 1;
    int lineType = cv::LINE_8;
    bool bottomLeftOrigin = false;
    for (int i=3; i<nrhs; i+=2) {
        string key(rhs[i].toString());
        if (key == "FontFace")
            fontFace = FontFace[rhs[i+1].toString()];
        else if (key == "FontStyle")
            fontStyle = FontStyle[rhs[i+1].toString()];
        else if (key == "FontScale")
            fontScale = rhs[i+1].toDouble();
        else if (key == "Color")
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
        else if (key == "BottomLeftOrigin")
            bottomLeftOrigin = rhs[i+1].toBool();
        else
            mexErrMsgIdAndTxt("mexopencv:error",
                "Unrecognized option %s", key.c_str());
    }
    fontFace |= fontStyle;

    // Process
    Mat img(rhs[0].toMat());
    if (rhs[1].isChar()) {
        string text(rhs[1].toString());
        Point org(rhs[2].toPoint());
        putText(img, text, org, fontFace, fontScale, color, thickness,
            lineType, bottomLeftOrigin);
    }
    else {
        vector<string> text(rhs[1].toVector<string>());
        vector<Point> org(rhs[2].toVector<Point>());
        if (text.size() != org.size())
            mexErrMsgIdAndTxt("mexopencv:error", "Length mismatch");
        if (!colors.empty() && colors.size() != text.size())
            mexErrMsgIdAndTxt("mexopencv:error", "Length mismatch");
        for (size_t i = 0; i < text.size(); ++i)
            putText(img, text[i], org[i], fontFace, fontScale,
                (colors.empty() ? color : Scalar(colors[i])),
                thickness, lineType, bottomLeftOrigin);
    }
    plhs[0] = MxArray(img);
}

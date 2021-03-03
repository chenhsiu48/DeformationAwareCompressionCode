/**
 * @file DPMDetector_.cpp
 * @brief mex interface for cv::dpm::DPMDetector
 * @ingroup dpm
 * @author Kota Yamaguchi
 * @date 2012
 */
#include "mexopencv.hpp"
#include "opencv2/dpm.hpp"
#include <sstream>
using namespace std;
using namespace cv;
using namespace cv::dpm;

namespace {

/// Last object id to allocate
int last_id = 0;
/// Object container
map<int,Ptr<DPMDetector> > obj_;

/** Convert object detections to struct array
 * @param vo vector of detections
 * @param classNames mapping of class IDs to class names
 * @return struct-array MxArray object
 */
MxArray toStruct(const vector<DPMDetector::ObjectDetection>& vo,
    const vector<string>& classNames)
{
    const char* fields[] = {"rect", "score", "class"};
    MxArray s = MxArray::Struct(fields, 3, 1, vo.size());
    for (size_t i=0; i<vo.size(); ++i) {
        s.set("rect",  vo[i].rect,  i);
        s.set("score", vo[i].score, i);
        if (vo[i].classID >= 0 && vo[i].classID < classNames.size())
            s.set("class", classNames[vo[i].classID], i);
        else {
            ostringstream ss;
            ss << vo[i].classID;
            s.set("class", ss.str(), i);
        }
    }
    return s;
}

} // local scope

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
    nargchk(nrhs>=2 && nlhs<=1);

    // Argument vector
    vector<MxArray> rhs(prhs, prhs+nrhs);
    int id = rhs[0].toInt();
    string method(rhs[1].toString());

    // Constructor call
    if (method == "new") {
        nargchk((nrhs==3 || nrhs==4) && nlhs<=1);
        obj_[++last_id] = (nrhs == 3) ?
            DPMDetector::create(rhs[2].toVector<string>()) :
            DPMDetector::create(rhs[2].toVector<string>(),
                rhs[3].toVector<string>());
        plhs[0] = MxArray(last_id);
        mexLock();
        return;
    }

    // Big operation switch
    Ptr<DPMDetector> obj = obj_[id];
    if (obj.empty())
        mexErrMsgIdAndTxt("mexopencv:error", "Object not found id=%d", id);
    if (method == "delete") {
        nargchk(nrhs==2 && nlhs==0);
        obj_.erase(id);
        mexUnlock();
    }
    else if (method == "isEmpty") {
        nargchk(nrhs==2 && nlhs<=1);
        plhs[0] = MxArray(obj->isEmpty());
    }
    else if (method == "detect") {
        nargchk(nrhs==3 && nlhs<=1);
        Mat image(rhs[2].toMat(rhs[2].isUint8() ? CV_8U : CV_64F));
        vector<DPMDetector::ObjectDetection> objects;
        obj->detect(image, objects);
        plhs[0] = toStruct(objects, obj->getClassNames());
    }
    else if (method == "getClassNames") {
        nargchk(nrhs==2 && nlhs<=1);
        plhs[0] = MxArray(obj->getClassNames());
    }
    else if (method == "getClassCount") {
        nargchk(nrhs==2 && nlhs<=1);
        plhs[0] = MxArray(static_cast<int>(obj->getClassCount()));
    }
    else
        mexErrMsgIdAndTxt("mexopencv:error",
            "Unrecognized operation %s", method.c_str());
}

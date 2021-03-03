/**
 * @file DownhillSolver_.cpp
 * @brief mex interface for cv::DownhillSolver
 * @ingroup core
 * @author Amro
 * @date 2015
 */
#include "mexopencv.hpp"
using namespace std;
using namespace cv;

// Persistent objects
namespace {
/// Last object id to allocate
int last_id = 0;
/// Object container
map<int,Ptr<DownhillSolver> > obj_;

/// Represents objective function being optimized, implemented as a MATLAB file.
class MatlabFunction : public cv::MinProblemSolver::Function
{
public:
    /** Constructor
     * @param num_dims number of variables of the objective function
     * @param func name of an M-file that computes the objective function
     */
    MatlabFunction(int num_dims, const string &func)
    : dims(num_dims), fun_name(func)
    {}

    /** Evaluates MATLAB objective function
     * @param[in] x input array of length \c dims
     * @return objective function evaluated at \p x (scalar value)
     *
     * Calculates <tt>y = F(x)</tt>, for the scalar-valued multivariate
     * objective function evaluated at the \c dims -dimensional point \c x
     *
     * Example:
     * @code
     * % the following MATLAB function implements the Rosenbrock function.
     * function f = rosenbrock(x)
     *     dims = numel(x);  % dims == 2
     *     f = (x(1) - 1)^2 + 100*(x(2) - x(1)^2)^2;
     * end
     * @endcode
     */
    double calc(const double *x) const
    {
        // create input to evaluate objective function
        mxArray *lhs, *rhs[2];
        rhs[0] = MxArray(fun_name);
        rhs[1] = MxArray(vector<double>(x, x + dims));

        // evaluate specified function in MATLAB as:
        // val = feval("fun_name", x)
        double val;
        if (mexCallMATLAB(1, &lhs, 2, rhs, "feval") == 0) {
            MxArray res(lhs);
            CV_Assert(res.isDouble() && !res.isComplex() && res.numel() == 1);
            val = res.at<double>(0);
        }
        else {
            //TODO: error
            val = 0;
        }

        // cleanup
        mxDestroyArray(lhs);
        mxDestroyArray(rhs[0]);
        mxDestroyArray(rhs[1]);

        // return scalar value of objective function evaluated at x
        return val;
    }

    /** Return number of dimensions.
     * @return dimensionality of the objective function domain
     */
    int getDims() const
    {
        return dims;
    }

    /** Convert object to MxArray
     * @return output MxArray structure
     */
    MxArray toStruct() const
    {
        MxArray s(MxArray::Struct());
        s.set("dims", dims);
        s.set("fun",  fun_name);
        return s;
    }

    /** Factory function
     * @param s input MxArray structure with the following fields:
     *    - dims
     *    - fun
     * @return smart pointer to newly created instance
     */
    static Ptr<MatlabFunction> create(const MxArray &s)
    {
        if (!s.isStruct() || s.numel()!=1)
            mexErrMsgIdAndTxt("mexopencv:error", "Invalid objective function");
        return makePtr<MatlabFunction>(
            s.at("dims").toInt(),
            s.at("fun").toString());
    }

private:
    int dims;         ///<! number of dimensions
    string fun_name;  ///<! name of M-file (objective function)
};
}

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
    nargchk(nrhs>=2 && nlhs<=2);

    // Arguments vector
    vector<MxArray> rhs(prhs, prhs+nrhs);
    int id = rhs[0].toInt();
    string method(rhs[1].toString());

    // Constructor is called. Create a new object from argument
    if (method == "new") {
        nargchk(nrhs>=2 && (nrhs%2)==0 && nlhs<=1);
        Ptr<MinProblemSolver::Function> f;
        Mat initStep(Mat_<double>(1, 1, 0.0));
        TermCriteria termcrit(TermCriteria::MAX_ITER+TermCriteria::EPS, 5000, 1e-6);
        for (int i=2; i<nrhs; i+=2) {
            string key(rhs[i].toString());
            if (key == "Function")
                f = MatlabFunction::create(rhs[i+1]);
            else if (key == "InitStep")
                initStep = rhs[i+1].toMat(CV_64F);
            else if (key == "TermCriteria")
                termcrit = rhs[i+1].toTermCriteria();
            else
                mexErrMsgIdAndTxt("mexopencv:error",
                    "Unrecognized option %s", key.c_str());
        }
        obj_[++last_id] = DownhillSolver::create(f, initStep, termcrit);
        plhs[0] = MxArray(last_id);
        mexLock();
        return;
    }

    // Big operation switch
    Ptr<DownhillSolver> obj = obj_[id];
    if (obj.empty())
        mexErrMsgIdAndTxt("mexopencv:error", "Object not found id=%d", id);
    if (method == "delete") {
        nargchk(nrhs==2 && nlhs==0);
        obj_.erase(id);
        mexUnlock();
    }
    else if (method == "clear") {
        nargchk(nrhs==2 && nlhs==0);
        obj->clear();
    }
    else if (method == "load") {
        nargchk(nrhs>=3 && (nrhs%2)==1 && nlhs==0);
        string objname;
        bool loadFromString = false;
        for (int i=3; i<nrhs; i+=2) {
            string key(rhs[i].toString());
            if (key == "ObjName")
                objname = rhs[i+1].toString();
            else if (key == "FromString")
                loadFromString = rhs[i+1].toBool();
            else
                mexErrMsgIdAndTxt("mexopencv:error",
                    "Unrecognized option %s", key.c_str());
        }
        obj_[id] = (loadFromString ?
            Algorithm::loadFromString<DownhillSolver>(rhs[2].toString(), objname) :
            Algorithm::load<DownhillSolver>(rhs[2].toString(), objname));
    }
    else if (method == "save") {
        nargchk(nrhs==3 && nlhs==0);
        obj->save(rhs[2].toString());
    }
    else if (method == "empty") {
        nargchk(nrhs==2 && nlhs<=1);
        plhs[0] = MxArray(obj->empty());
    }
    else if (method == "getDefaultName") {
        nargchk(nrhs==2 && nlhs<=1);
        plhs[0] = MxArray(obj->getDefaultName());
    }
    else if (method == "minimize") {
        nargchk(nrhs==3 && nlhs<=2);
        Mat x(rhs[2].toMat(CV_64F));
        double fx = obj->minimize(x);
        plhs[0] = MxArray(x);
        if (nlhs>1)
            plhs[1] = MxArray(fx);
    }
    else if (method == "get") {
        nargchk(nrhs==3 && nlhs<=1);
        string prop(rhs[2].toString());
        if (prop == "Function") {
            Ptr<MinProblemSolver::Function> f(obj->getFunction());
            plhs[0] = (f.empty()) ? MxArray::Struct() :
                (f.dynamicCast<MatlabFunction>())->toStruct();
        }
        else if (prop == "InitStep") {
            Mat initStep;
            obj->getInitStep(initStep);
            plhs[0] = MxArray(initStep);
        }
        else if (prop == "TermCriteria")
            plhs[0] = MxArray(obj->getTermCriteria());
        else
            mexErrMsgIdAndTxt("mexopencv:error",
                "Unrecognized property %s", prop.c_str());
    }
    else if (method == "set") {
        nargchk(nrhs==4 && nlhs==0);
        string prop(rhs[2].toString());
        if (prop == "Function")
            obj->setFunction(MatlabFunction::create(rhs[3]));
        else if (prop == "InitStep")
            obj->setInitStep(rhs[3].toMat(CV_64F));
        else if (prop == "TermCriteria")
            obj->setTermCriteria(rhs[3].toTermCriteria());
        else
            mexErrMsgIdAndTxt("mexopencv:error",
                "Unrecognized property %s", prop.c_str());
    }
    else
        mexErrMsgIdAndTxt("mexopencv:error",
            "Unrecognized operation %s", method.c_str());
}

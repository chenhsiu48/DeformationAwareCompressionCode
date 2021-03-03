classdef TestBlendLinear
    %TestBlendLinear

    methods (Static)
        function test_1
            src1 = imread(fullfile(mexopencv.root(),'test','left01.jpg'));
            src2 = imread(fullfile(mexopencv.root(),'test','right01.jpg'));
            assert(isequal(size(src1), size(src2)));

            [rows,cols,~] = size(src1);
            weights1 = 0.5*ones(rows, cols);
            weights2 = 0.5*ones(rows, cols);
            dst = cv.blendLinear(src1, src2, weights1, weights2);
            validateattributes(dst, {class(src1)}, {'size',size(src1)});
        end

        function test_error_argnum
            try
                cv.blendLinear();
                throw('UnitTest:Fail');
            catch e
                assert(strcmp(e.identifier,'mexopencv:error'));
            end
        end
    end

end

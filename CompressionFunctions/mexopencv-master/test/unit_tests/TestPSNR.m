classdef TestPSNR
    %TestPSNR

    methods (Static)
        function test_1
            src1 = randi([0 255], [50 50], 'uint8');
            src2 = randi([0 255], [50 50], 'uint8');
            x = cv.PSNR(src1, src2);
        end

        function test_2
            src1 = randi([0 255], [50 50 3], 'uint8');
            src2 = randi([0 255], [50 50 3], 'uint8');
            x = cv.PSNR(src1, src2);
        end

        function test_error_argnum
            try
                cv.PSNR();
                throw('UnitTest:Fail');
            catch e
                assert(strcmp(e.identifier,'mexopencv:error'));
            end
        end
    end

end

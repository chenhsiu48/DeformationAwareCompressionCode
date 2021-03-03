classdef TestAccumulateProduct
    %TestAccumulateProduct

    methods (Static)
        function test_1
            sz = [10 20];
            dst = zeros(sz);
            for i=1:5
                dst = cv.accumulateProduct(rand(sz), rand(sz), dst);
            end
            validateattributes(dst, {'double'}, {'size',sz});
        end

        function test_2
            sz = [10 20];
            dst = zeros(sz, 'single');
            for i=1:5
                dst = cv.accumulateProduct(randi(255,sz,'uint8'), ...
                    randi(255,sz,'uint8'), dst);
            end
            validateattributes(dst, {'single'}, {'size',sz});
        end

        function test_3
            sz = [10 20];
            dst = zeros(sz);
            for i=1:5
                src = rand(sz);
                mask = (rand(sz) > 0.5);
                dst = cv.accumulateProduct(src, src, dst, 'Mask',mask);
            end
        end

        function test_error_argnum
            try
                cv.accumulateProduct();
                throw('UnitTest:Fail');
            catch e
                assert(strcmp(e.identifier,'mexopencv:error'));
            end
        end
    end

end

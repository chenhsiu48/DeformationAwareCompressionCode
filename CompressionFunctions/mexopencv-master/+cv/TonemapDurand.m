classdef TonemapDurand < handle
    %TONEMAPDURAND  Tonemapping algorithm used to map HDR image to 8-bit range
    %
    % This algorithm decomposes image into two layers: base layer and detail
    % layer using bilateral filter and compresses contrast of the base layer
    % thus preserving all the details.
    %
    % This implementation uses regular bilateral filter from OpenCV.
    %
    % Saturation enhancement is possible as in cv.TonemapDrago.
    %
    % For more information see [DD02].
    %
    % ## References
    % [DD02]:
    % > Fredo Durand and Julie Dorsey. "Fast bilateral filtering for the
    % > display of high-dynamic-range images". In ACM Transactions on Graphics
    % > (TOG), volume 21, pages 257-266. ACM, 2002.
    %
    % See also: cv.Tonemap, cv.TonemapDrago, cv.TonemapReinhard,
    %  cv.TonemapMantiuk, tonemap
    %

    properties (SetAccess = private)
        id % Object ID
    end

    properties (Dependent)
        % positive value for gamma correction.
        %
        % Gamma value of 1.0 implies no correction, gamma equal to 2.2 is
        % suitable for most displays. Generally gamma > 1 brightens the image
        % and gamma < 1 darkens it.
        Gamma
        % resulting contrast on logarithmic scale
        %
        % i.e. `log(max/min)`, where `max` and `min` are maximum and minimum
        % luminance values of the resulting image.
        Contrast
        % positive saturation enhancement value.
        %
        % 1.0 preserves saturation, values greater than 1 increase saturation
        % and values less than 1 decrease it.
        Saturation
        % bilateral filter sigma in color space.
        SigmaSpace
        % bilateral filter sigma in coordinate space.
        SigmaColor
    end

    %% TonemapDurand
    methods
        function this = TonemapDurand(varargin)
            %TONEMAPDURAND  Creates TonemapDurand object
            %
            %    obj = cv.TonemapDurand()
            %    obj = cv.TonemapDurand('OptionName',optionValue, ...)
            %
            % ## Options
            % * __Gamma__ default 1.0
            % * __Contrast__ default 4.0
            % * __Saturation__ default 1.0
            % * __SigmaSpace__ default 2.0
            % * __SigmaColor__ default 2.0
            %
            % See also: cv.TonemapDurand.process
            %
            this.id = TonemapDurand_(0, 'new', varargin{:});
        end

        function delete(this)
            %DELETE  Destructor
            %
            %    obj.delete()
            %
            % See also: cv.TonemapDurand
            %
            if isempty(this.id), return; end
            TonemapDurand_(this.id, 'delete');
        end
    end

    %% Tonemap
    methods
        function dst = process(this, src)
            %PROCESS  Tonemaps image
            %
            %    dst = obj.process(src)
            %
            % ## Input
            % * __src__ source RGB image, 32-bit `single` 3-channel array.
            %
            % ## Output
            % * __dst__ destination image of same size as `src`, 32-bit
            %       `single` 3-channel array with values in [0,1] range.
            %
            % See also: cv.TonemapDurand.TonemapDurand
            %
            dst = TonemapDurand_(this.id, 'process', src);
        end
    end

    %% Algorithm
    methods (Hidden)
        function clear(this)
            %CLEAR  Clears the algorithm state
            %
            %    obj.clear()
            %
            % See also: cv.TonemapDurand.empty, cv.TonemapDurand.load
            %
            TonemapDurand_(this.id, 'clear');
        end

        function b = empty(this)
            %EMPTY  Returns true if the algorithm is empty
            %
            %    b = obj.empty()
            %
            % ## Output
            % * __b__ Returns true if the object is empty (e.g in the
            %       very beginning or after unsuccessful read).
            %
            % See also: cv.TonemapDurand.clear, cv.TonemapDurand.load
            %
            b = TonemapDurand_(this.id, 'empty');
        end

        function name = getDefaultName(this)
            %GETDEFAULTNAME  Returns the algorithm string identifier
            %
            %    name = obj.getDefaultName()
            %
            % ## Output
            % * __name__ This string is used as top level XML/YML node tag
            %       when the object is saved to a file or string.
            %
            % See also: cv.TonemapDurand.save, cv.TonemapDurand.load
            %
            name = TonemapDurand_(this.id, 'getDefaultName');
        end

        function save(this, filename)
            %SAVE  Saves the algorithm parameters to a file
            %
            %    obj.save(filename)
            %
            % ## Input
            % * __filename__ Name of the file to save to.
            %
            % This method stores the algorithm parameters in the specified
            % XML or YAML file.
            %
            % See also: cv.TonemapDurand.load
            %
            TonemapDurand_(this.id, 'save', filename);
        end

        function load(this, fname_or_str, varargin)
            %LOAD  Loads algorithm from a file or a string
            %
            %    obj.load(fname)
            %    obj.load(str, 'FromString',true)
            %    obj.load(..., 'OptionName',optionValue, ...)
            %
            % ## Input
            % * __fname__ Name of the file to read.
            % * __str__ String containing the serialized model you want to
            %       load.
            %
            % ## Options
            % * __ObjName__ The optional name of the node to read (if empty,
            %       the first top-level node will be used). default empty
            % * __FromString__ Logical flag to indicate whether the input is
            %       a filename or a string containing the serialized model.
            %       default false
            %
            % This method reads algorithm parameters from the specified XML or
            % YAML file (either from disk or serialized string). The previous
            % algorithm state is discarded.
            %
            % See also: cv.TonemapDurand.save
            %
            TonemapDurand_(this.id, 'load', fname_or_str, varargin{:});
        end
    end

    %% Getters/Setters
    methods
        function value = get.Gamma(this)
            value = TonemapDurand_(this.id, 'get', 'Gamma');
        end
        function set.Gamma(this, value)
            TonemapDurand_(this.id, 'set', 'Gamma', value);
        end

        function value = get.Contrast(this)
            value = TonemapDurand_(this.id, 'get', 'Contrast');
        end
        function set.Contrast(this, value)
            TonemapDurand_(this.id, 'set', 'Contrast', value);
        end

        function value = get.Saturation(this)
            value = TonemapDurand_(this.id, 'get', 'Saturation');
        end
        function set.Saturation(this, value)
            TonemapDurand_(this.id, 'set', 'Saturation', value);
        end

        function value = get.SigmaSpace(this)
            value = TonemapDurand_(this.id, 'get', 'SigmaSpace');
        end
        function set.SigmaSpace(this, value)
            TonemapDurand_(this.id, 'set', 'SigmaSpace', value);
        end

        function value = get.SigmaColor(this)
            value = TonemapDurand_(this.id, 'get', 'SigmaColor');
        end
        function set.SigmaColor(this, value)
            TonemapDurand_(this.id, 'set', 'SigmaColor', value);
        end
    end

end

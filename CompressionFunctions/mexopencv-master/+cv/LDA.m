classdef LDA < handle
    %LDA  Linear Discriminant Analysis
    %
    % ## Example
    %
    %    Xtrain = randn(100,5);
    %    labels = randi([1 3], [100 1]);
    %    Xtest = randn(100,5);
    %
    %    lda = cv.LDA('NumComponents',3);
    %    lda.compute(Xtrain, labels);
    %    Y = lda.project(Xtest);
    %    Xapprox = lda.reconstruct(Y);
    %
    % See also: cv.PCA, fitcdiscr
    %

    properties (SetAccess = private)
        id  % Object ID
    end

    properties (Dependent, SetAccess = private)
        % eigenvalues of this LDA. Vector of length `ncomponents`.
        eigenvalues
        % eigenvectors of this LDA. Matrix of size `d-by-ncomponents`.
        eigenvectors
    end

    methods
        function this = LDA(varargin)
            %LDA  Constructor, initializes a LDA object
            %
            %    lda = cv.LDA()
            %    lda = cv.LDA('OptionName', optionValue, ...)
            %
            % ## Options
            % * __NumComponents__ number of components (default 0). If 0 (or
            %       less) number of components are given, they are
            %       automatically determined for given data in computation.
            %
            % See also: cv.LDA.compute
            %
            this.id = LDA_(0, 'new', varargin{:});
        end

        function delete(this)
            %DELETE  Destructor
            %
            %    lda.delete()
            %
            % See also: cv.LDA
            %
            if isempty(this.id), return; end
            LDA_(this.id, 'delete');
        end

        function load(this, fname_or_str, varargin)
            %LOAD  Deserializes this object from a given filename
            %
            %    lda.load(filename)
            %    lda.load(str, 'FromString',true)
            %
            % ## Input
            % * __filename__ name of file to load
            % * __str__ String containing serialized object you want to load.
            %
            % ## Options
            % * __FromString__ Logical flag to indicate whether the input is
            %       a filename or a string containing the serialized object.
            %       default false
            %
            % See also: cv.LDA.save
            %
            LDA_(this.id, 'load', fname_or_str, varargin{:});
        end

        function varargout = save(this, filename)
            %SAVE  Serializes this object to a given filename
            %
            %    lda.save(filename)
            %    str = lda.save(filename)
            %
            % ## Input
            % * __filename__ name of file to save
            %
            % ## Output
            % * __str__ optional output. If requested, the object is persisted
            %       to a string in memory instead of writing to disk.
            %
            % See also: cv.LDA.load
            %
            [varargout{1:nargout}] = LDA_(this.id, 'save', filename);
        end

        function compute(this, src, labels)
            %COMPUTE  Compute the discriminants for data and labels
            %
            %    lda.compute(src, labels)
            %
            % ## Input
            % * __src__ data samples (matrix of rows of size `N-by-d`, or a
            %       cell-array of `N` vectors each of length `d`).
            %       Floating-point type.
            % * __labels__ corresponding labels (vector of length `N`).
            %       Integer type.
            %
            % Performs a Discriminant Analysis with Fisher's Optimization
            % Criterion on given data in `src` and corresponding labels in
            % `labels` using the previous set number of components.
            %
            % See also: cv.LDA.LDA
            %
            LDA_(this.id, 'compute', src, labels);
        end

        function m = project(this, src)
            %PROJECT  Projects samples into the LDA subspace
            %
            %    m = lda.project(src)
            %
            % ## Input
            % * __src__ data sampels (matrix of size N-by-d)
            %
            % ## Output
            % * __m__ projected samples (matrix of size N-by-ncomponents)
            %
            % See also: cv.LDA.reconstruct
            %
            m = LDA_(this.id, 'project', src);
        end

        function m = reconstruct(this, src)
            %RECONSTRUCT  Reconstructs projections from the LDA subspace
            %
            %    m = lda.reconstruct(src)
            %
            % ## Input
            % * __src__ projected data (matrix of size N-by-ncomponents)
            %
            % ## Output
            % * __m__ reconstructed data (matrix of size N-by-d)
            %
            % See also: cv.LDA.project
            %
            m = LDA_(this.id, 'reconstruct', src);
        end
    end

    methods (Static)
        function dst = subspaceProject(W, mn, src)
            %SUBSPACEPROJECT  Projects samples
            %
            %    dst = cv.LDA.subspaceProject(W, mn, src)
            %
            % ## Input
            % * __W__ eigenvectors.
            % * __mn__ mean vector.
            % * __src__ data sampels.
            %
            % ## Output
            % * __dst__ projected data
            %
            % Projects data as `Y = (X-mean)*W`.
            %
            % See also: cv.LDA.subspaceReconstruct, cv.LDA,project
            %
            dst = LDA_(0, 'subspaceProject', W, mn, src);
        end

        function dst = subspaceReconstruct(W, mn, src)
            %SUBSPACERECONSTRUCT  Reconstructs projections
            %
            %    dst = cv.LDA.subspaceReconstruct(W, mn, src)
            %
            % ## Input
            % * __W__ eigenvectors.
            % * __mn__ mean vector.
            % * __src__ projected data.
            %
            % ## Output
            % * __dst__ reconstructed data
            %
            % Reconstructs data as `X = Y*W' + mean`.
            %
            % See also: cv.LDA.subspaceProject, cv.LDA,reconstruct
            %
            dst = LDA_(0, 'subspaceReconstruct', W, mn, src);
        end
    end

    methods
        function ev = get.eigenvalues(this)
            ev = LDA_(this.id, 'get', 'eigenvalues');
        end

        function ev = get.eigenvectors(this)
            ev = LDA_(this.id, 'get', 'eigenvectors');
        end
    end

end

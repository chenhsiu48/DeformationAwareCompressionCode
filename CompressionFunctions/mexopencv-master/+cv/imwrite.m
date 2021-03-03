%IMWRITE  Saves an image to a specified file
%
%    cv.imwrite(filename, img)
%    cv.imwrite(filename, img, 'OptionName', optionValue, ...)
%    success = cv.imwrite(...)
%
% ## Input
% * __filename__ Name of the file.
% * __img__ Image to be saved.
%
% ## Output
% * __success__ optional output flag, true on success, false otherwise. If not
%       requested, the function throws an error on fail.
%
% ## Options
% * __FlipChannels__ in case the input is color image, flips the color order
%       from MATLAB's RGB/RGBA to OpenCV's BGR/BGRA order. default true
%
% The following format-specific save parameters are currently supported:
%
% * __JpegQuality__ For JPEG, it can be a quality from 0 to 100 (the higher is
%       the better). Default value is 95.
% * __JpegProgressive__ Enable JPEG features, 0 or 1, default is false.
% * __JpegOptimize__ Enable JPEG features, 0 or 1, default is false.
% * __JpegResetInterval__ JPEG restart interval, 0 - 65535,
%       default is 0 (no restart).
% * __JpegLumaQuality__ Separate luma quality level, 0 - 100,
%       default is 0 (don't use).
% * __JpegChromaQuality__ Separate chroma quality level, 0 - 100,
%       default is 0 (don't use).
% * __PngCompression__ For PNG, it can be the compression level from 0 to 9.
%       A higher value means a smaller size and longer compression time.
%       Default value is 3. Also strategy is changed to `Default`.
% * __PngStrategy__ For PNG; used to tune the compression algorithm. These
%       flags will be modify the way of PNG image compression and will be
%       passed to the underlying zlib processing stage. The strategy parameter
%       only affects the compression ratio but not the correctness of the
%       compressed output even if it is not set appropriately. One of:
%       * __Default__ (default) Use this value for normal data.
%       * __Filtered__ Use this value for data produced by a filter (or
%             predictor). Filtered data consists mostly of small values with a
%             somewhat random distribution. In this case, the compression
%             algorithm is tuned to compress them better. The effect of
%             `Filtered` is to force more Huffman coding and less string
%             matching; it is somewhat intermediate between `Default` and
%             `HuffmanOnly`.
%       * __HuffmanOnly__ Use this value to force Huffman encoding only
%             (no string match).
%       * __RLE__ Use this value to limit match distances to one (run-length
%             encoding). `RLE` is designed to be almost as fast as
%             `HuffmanOnly`, but give better compression for PNG image data.
%       * __Fixed__ Using this value prevents the use of dynamic Huffman
%             codes, allowing for a simpler decoder for special applications.
% * __PngBilevel__ Binary level PNG, 0 or 1, controls packing of pixels per
%       bytes. If false, PNG files pack pixels of bit-depths 1, 2, and 4 into
%       bytes as small as possible. default is false.
% * __PxmBinary__ For PPM, PGM, or PBM, it can be a binary format flag, 0 or 1,
%       to specify ASCII or binary encoding. default is true.
% * __WebpQuality__ For WEBP, it can be a quality from 1 to 100 (the higher is
%       the better). By default (without any parameter) and for quality above
%       100 the lossless compression is used.
% * __PamTupleType__ For PAM, sets the TUPLETYPE field to the corresponding
%       string value that is defined for the format. One of:
%       * __Null__
%       * __BlackWhite__
%       * __Grayscale__
%       * __GrayscaleAlpha__
%       * __RGB__
%       * __RGBA__
%
% For advanced uses, you can directly pass a vector of paramters:
%
% * __Params__ Format-specific save parameters encoded as pairs:
%       `[paramId_1, paramValue_1, paramId_2, paramValue_2, ...]`.
%
% The function cv.imwrite saves the image to the specified file. The image
% format is chosen based on the filename extension (see cv.imread for the list
% of extensions). Only 8-bit (or 16-bit unsigned `uint16` in case of PNG,
% JPEG 2000, and TIFF) single-channel or 3-channel (with RGB channel order)
% images can be saved using this function. If the format, depth or channel
% order is different, use cv.cvtColor to convert it before saving. Or, use the
% universal cv.FileStorage I/O functions to save the image to XML or YAML
% format.
%
% (If the chosen encoder does not support the depth of the input image, the
% image will be implicitly cast to 8-bit).
%
% If the image cannot be saved (because of IO errors, improper permissions,
% unsupported or invalid format), the function throws an error.
%
% It is possible to store PNG images with an alpha channel using this function.
% To do this, create 8-bit (or 16-bit) 4-channel image RGBA, where the alpha
% channel goes last. Fully transparent pixels should have alpha set to 0,
% fully opaque pixels should have alpha set to 255/65535.
%
% ## Example
% The sample below shows how to create such a RGBA image and store to PNG file.
% It also demonstrates how to set custom compression parameters:
%
%    % Create mat with alpha channel
%    nrows = 480; ncols = 640;
%    [I,J] = ndgrid(1:nrows, 1:ncols);
%    img = zeros(nrows, ncols, 4, 'uint8');
%    img(:,:,1) = uint8(255 * (nrows-I+1)/nrows);     % red
%    img(:,:,2) = uint8(255 * (ncols-J+1)/ncols);     % green
%    img(:,:,3) = uint8(255);                         % blue
%    img(:,:,4) = uint8(0.5 * sum(img(:,:,[1 2]),3)); % alpha
%
%    % save PNG file with alpha data
%    %imwrite(img(:,:,1:3), 'alpha.png', 'Alpha',img(:,:,4))
%    cv.imwrite('alpha.png', img, 'PngCompression',9, 'PngStrategy','RLE');
%    imfinfo('alpha.png')
%
%    % show image with alpha transparency
%    figure('Menubar','none', 'Color','k')
%    image(img(:,:,1:3), 'AlphaData',img(:,:,4))
%    axis image off
%
% See also: cv.imread, cv.imencode, imwrite
%

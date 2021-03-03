%MORPHOLOGYEX  Performs advanced morphological transformations
%
%    dst = cv.morphologyEx(src, op)
%    dst = cv.morphologyEx(src, op, 'OptionName',optionValue, ...)
%
% ## Input
% * __src__ Source image. The number of channels can be arbitrary. The depth
%       should be one of `uint8`, `uint16`, `int16`, `single` or `double`.
% * __op__ Type of a morphological operation that can be one of the following:
%       * __Erode__ see cv.erode
%       * __Dilate__ see cv.dilate
%       * __Open__ an opening operation
%             `dst = open(src,element) = dilate(erode(src,element))`
%       * __Close__ a closing operation
%             `dst = close(src,element) = erode(dilate(src,element))`
%       * __Gradient__ a morphological gradient
%             `dst = morph_grad(src,element) = dilate(src,element) - erode(src,element)`
%       * __Tophat__ "top hat"
%             `dst = tophat(src,element) = src - open(src,element)`
%       * __Blackhat__ "black hat"
%             `dst = blackhat(src,element) = close(src,element) - src`
%       * __HitMiss__ "hit and miss". Only supported for `uint8` 1-channel
%             binary images. Tutorial can be found in this
%             [page](https://web.archive.org/web/20160316070407/http://opencv-code.com/tutorials/hit-or-miss-transform-in-opencv/).
%
% ## Output
% * __dst__ Destination image of the same size and type as source image.
%
% ## Options
% * __Element__ Structuring element kernel. It can be created using
%       cv.getStructuringElement. Empty by default, which uses a 3x3
%       rectangular structuring element by default.
% * __Anchor__ Position of the anchor within the element. The default value
%       [-1,-1] means that the anchor is at the element center.
% * __Iterations__ Number of times erosion and dilation are applied. default 1
% * __BorderType__ Pixel extrapolation method. See cv.copyMakeBorder.
%       default 'Constant'
% * __BorderValue__ Border value in case of a constant border. The default
%       value has a special meaning. See cv.dilate and cv.erode for details.
%
% The function cv.morphologyEx can perform advanced morphological
% transformations using an erosion and dilation as basic operations.
%
% In case of multi-channel images, each channel is processed independently.
%
% See also: cv.dilate, cv.erode, cv.getStructuringElement, imopen, imclose,
%  imtophat, imbothat, bwmorph
%

function [y,i,q] = rgb2ntsc(r,g,b)
%RGB2NTSC Convert RGB values to NTSC colorspace.
%   YIQMAP = RGB2NTSC(RGBMAP) converts the M-by-3 RGB values in
%   RGBMAP to NTSC colorspace. YIQMAP is an M-by-3 matrix that
%   contains the NTSC luminance (Y) and chrominance (I and Q)
%   color components as columns that are equivalent to the colors
%   in the RGB colormap.
%
%   YIQ = RGB2NTSC(RGB) converts the truecolor image RGB to the
%   equivalent NTSC image YIQ.
%
%   Class Support
%   -------------
%   If the input is an RGB image, it can be of class uint8,
%   uint16 or double; the output image is of class double. If 
%   the input is a colormap, the input and output colormaps 
%   are both of class double.
%
%   See also NTSC2RGB, RGB2IND, IND2RGB, IND2GRAY.

%   Copyright 1993-2000 The MathWorks, Inc.
%   $Revision: 5.12 $  $Date: 2000/01/21 20:17:12 $

T = [1.0 0.956 0.621; 1.0 -0.272 -0.647; 1.0 -1.106 1.703];

% Bump all input arguments to double
switch nargin
  case 1,
    if ~isa(r, 'double'), r = im2double(r); end
  case 3,
    if ~isa(r, 'double'), r = im2double(r); end
    if ~isa(g, 'double'), g = im2double(g); end
    if ~isa(b, 'double'), b = im2double(b); end
  otherwise,
    error('Wrong number of input arguments.');
end

threeD = (ndims(r)==3); % Determine if input includes a 3-D array.

if (nargin==1 & (~threeD)),
  [m,n] = size(r);
  if n~=3, error('RGBMAP must have 3 columns.'); end
  y = r/T';
else
  if threeD,
    m = size(r,1); n = size(r,2);
    yiq = reshape(r(:),m*n,3)/T';
  else
    [m,n] = size(r);
    if any(size(r)~=size(b)) | any(size(r)~=size(g)),
      error('R,G,B must all be the same size.');
    end
    yiq = [r(:) g(:) b(:)]/T';
  end
  if (nargout==0 | nargout==1),
    y = reshape(yiq,size(r,1),size(r,2),3);
  else
    y = reshape(yiq(:,1),m,n);
    i = reshape(yiq(:,2),m,n);
    q = reshape(yiq(:,3),m,n);
  end
end


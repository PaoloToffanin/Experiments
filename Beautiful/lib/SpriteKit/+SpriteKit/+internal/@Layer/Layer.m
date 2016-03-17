classdef Layer < matlab.mixin.Copyable
%LAYER Single layer used for a Sprite State.
    % A LAYER object does not have any functionality alone, and is used in
    % Sprite to standardize properties, such as centering XData and YData
    % about the origin and guaranteeing CData is a TrueColor matrix.
    %
    % Each of the LAYER properties are static values, such that Sprite
    % interaction (moving, rotating, scaling, etc) do not effect these
    % values.
    %
    % LAYER inherits from matlab.mixin.Copyable to allow for COPY
    % functionality.
    %
    % L = LAYER(IMG) takes filenames of images to read in.
    % L = LAYER(C) takes CData directly, a NxMx3 matrix whose values are
    %              between 0 and 1.
    % L = LAYER(..., TRANS) applies transparency to the layer if TRANS is
    % true (default is false). Any white ([255 255 255]) outside of a
    % closed polygon will become transparent in the Sprite. See
    % BWBOUNDARIES with the NOHOLES option for more info.
    %
    % Full functionality requires Image Processing Toolbox to calculate
    % precise boundaries. If this is not installed, the boundary (BData)
    % is simply the edge of the full image rectangle.
    %
    % LAYER properties:
    %  BData - boundary data
    %  CData - TrueColor data
    %  XData - X grid
    %  YData - Y grid
    %  ZData - Z grid
    %
    % See also GAME, BWBOUNDARIES, SPRITE.
    
    % Copyright 2014 The MathWorks, Inc.
    
    %%
    properties
        
        %BDATA Nx2 Boundary Data
        BData
        
        %CDATA NxMx3 TrueColor matrix
        CData
        
        %XDATA NxM XData grid, centered about [0,0]
        XData
        
        %YDATA NxM YData grid, centered about [0,0]
        YData
        
        %ZDATA NxM ZData grid.
        % Matrix of 1's and NaN's representing opaque and transparent
        % points, respectively.
        ZData
        
        AlphaData
        
    end
    
    %%
    methods
        
        function obj = Layer(in,trans)
            %LAYER constructor
            %
            % L = LAYER(IMG,...) takes filenames of images to read in.
            %
            % L = LAYER(C,...) takes CData directly
            %
            % L = LAYER(..., TRANS) applies transparency to the layer if
            % TRANS is true (default is false). Any white outside of a
            % closed polygon will become transparent in the Sprite.
            
            narginchk(2,2)
            
            if ischar(in)
                % handle png
                if strfind(in, 'png')
                    [data, map, alpha] = imread(in, 'PNG');
                else
                    [data,map] = imread(in);
                    alpha = [];
                end
                if ~isempty(map) % want true-color
                    data = ind2rgb(data,map);
                end
                % double format in [0,1] range
                data = double(data)./255;
            else
                % raw data, if 4 dims
                if ~(isnumeric(in) && ndims(in)==3 && (size(in,3)==3 || size(in,3)==4))
                    error('MATLAB:SpriteKit:BadCData',...
                        'Raw data must be a numeric NxMx3 or NxMx4 matrix, or provide an existing filename.');
                end
                % ensure double
                if size(in,3)==3
                    data = double(in);
                    alpha = [];
                elseif size(in,3)==4
                    data = double(in(:,:,1:3));
                    alpha = double(in(:,:,1:3));
                end
            end
            
            % an NxM surface has NxM grids and only (N-1)x(M-1) rectangles.
            % Add one to the right and bottom to buffer.
            data(end+1,:,:) = 1;
            data(:,end+1,:) = 1;
            
            if ~isempty(alpha)
                alpha(end+1,:,:) = 1;
                alpha(:,end+1,:) = 1;
            end
            
            sd = size(data);
            xy = (sd-1)/2; % centered at (0,0), with a Y-flip
            [obj.XData,obj.YData] = meshgrid(-xy(2):xy(2),xy(1):-1:-xy(1));
            if ~isempty(alpha)
                binmask = alpha>.5;
            elseif trans
                % all ones in CData map to zeros
                binmask = ~floor(sum(data,3)/3);
            else
                % solid rectangle
                binmask = ones(sd(1:2));
            end
            
            obj.CData = data;

%{
%-------- Not necessary anymore
            % the object does not manage transparency
%             if ischar(in) && strfind(in, 'png')
%                 obj.AlphaData = alpha;
%             end
            % this does not solve the problem. Where is the image created?
            
            alphaMask = im2double(alpha); %// To make between 0 and 1
            img_composite = im2uint8(double(img_background).*(1-alphaMask) + double(img_overlay).*alphaMask);
%------------------------------
%}
            
            % bwboundaries is part of the Image Processing Toolbox. Use
            % graceful degradation if this isn't available.
            if isempty(which('bwboundaries'))
                warnOnceForImageTbx;
                
                z = double(binmask);
                z(z==0) = NaN;
                obj.ZData = z;
                
                obj.BData = outlineRect(sd(1),sd(2));
                
            else
                
                [bw,L] = bwboundaries(binmask,'noholes');
                
                % use L instead of binmask, since we want any white inside the
                % polygon to be filled back up with the NOHOLES option.
                z = L;
                z(z==0) = NaN;
                obj.ZData = z;
                
                if isempty(bw)
                    warning('MATLAB:SpriteKit:NoBoundaries',...
                        'No boundaries found for this layer');
                    obj.BData = [0 0];
                else
                    bw = bw{1};
                    % centered at (0,0)
                    bw = bw - repmat(sd(1:2)/2,size(bw,1),1);
                    bw(:,1) = -bw(:,1); % Y-flip about x=0
                    obj.BData = bw;
                end
                
            end
            
        end
        
    end
    
end

%%
function warnOnceForImageTbx
% Warn user only once about missing Image Processing Toolbox

persistent firsttime;

if isempty(firsttime)
    firsttime = true;
    % paol8: remove tedious warning. 
%     warning('MATLAB:SpriteKit:MissingImageTbx',...
%     'Image Processing Toolbox is not installed. Crude boundaries will be used.');
    fprintf(['\n MATLAB:SpriteKit:MissingImageTbx',...
    'Image Processing Toolbox is not installed. Crude boundaries will be used.\n',...
    'Layer.m ln. 198 - SpriteKit \n\n' ]);

end

end

function bd = outlineRect(X,Y)
% Crude boundary that just outlines the rectangle of size [X Y]

x = [ones(1,Y-1), 1:X-1,                  repmat(X,1,Y-1), X:-1:1   ];
y = [1:Y-1,       repmat(Y,1,X-1), Y:-1:2,                 ones(1,X)];

bd = [x' y'];

% center at [0 0]
bd = bd - repmat([X,Y]/2,size(bd,1),1);

end
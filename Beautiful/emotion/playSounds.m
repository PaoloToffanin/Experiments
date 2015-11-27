function playSounds(varargin)
%               cycleNext(varargin{2}); % this goes too fast.

    iter = 1;
    play(varargin{1})
    while true
        if nargin >= 2
            statusCounter = mod(floor(iter/10), 4) + 1;
%             if (mod(floor(iter/10), 4) == 0)
                varargin{2}.State = ['talk' sprintf('%i', statusCounter)];
                varargin{3}.State = sprintf('parrottalk_%i', statusCounter);
                varargin{3}.Location = [varargin{2}.bubblesX, varargin{2}.bubblesY];
%             end
            iter = iter + 1;
        end
        if ~isplaying(varargin{1})
            break;
        end
        pause(0.01);
        
    end
    
    if nargin >= 2
%         varargin{2}.Angle = 0;
        varargin{2}.State = 'talk1';
        % clear bubbles
        varargin{3}.State = 'noBubbles';
    end
    
end

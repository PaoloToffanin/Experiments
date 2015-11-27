function playSounds(varargin)
%               cycleNext(varargin{2}); % this goes too fast.

    
    if nargin == 1
         playblocking(varargin{1})
    else    
        iter = 1;
        play(varargin{1})
        while true
            statusCounter = mod(floor(iter/10), 4) + 1;
            varargin{2}.State = ['talk' sprintf('%i', statusCounter)];
            varargin{3}.State = sprintf('bubbles_%i', statusCounter);
            varargin{3}.Location = [varargin{2}.bubblesX, varargin{2}.bubblesY];
            iter = iter + 1;
            if ~isplaying(varargin{1})
                break;
            end
            pause(0.01);
            
        end
        varargin{2}.State = 'talk1';
        % clear bubbles
        varargin{3}.State = 'noBubbles';
    end
    
end

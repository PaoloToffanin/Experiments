function makeBubbles_IM
% function [nBubbles, posBubbles, figSize] = makeBubbles_IM(xpos, ypos)

    xpos = 0;
    ypos = 0;
    nBubbles = [3, 4, 6, 6];

    % posBubbles = {[0 15], [0 20], [0 25], [5 30]} then use randi to add
    % subtract from those spaces
    posBubbles(1).b = {[xpos+0 ypos+17 14 14 5], ...
        [xpos+8 ypos+70 12 12 3], ...
        [xpos-12 ypos+99 8 8 4]};
    posBubbles(2).b = {[xpos-28 ypos+20 12 12 5], ...
        [xpos+14 ypos+56 12 12 3], ...
        [xpos-10 ypos+92 12 12 4], ...
        [xpos-30 ypos+125 8 8 3] };
    posBubbles(3).b = {[xpos+6 ypos+18 8 8 4], ...
        [xpos-2 ypos+62 8 8 4], ...
        [xpos+14 ypos+85 8 8 3], ...
        [xpos-5 ypos+110 8 8 3], ...
        [xpos+20 ypos+160 3 3 2], ...
        [xpos-20 ypos+170 4 4 2]};
    posBubbles(4).b = {[xpos+6 ypos+30 8 8 4], ...
        [xpos+0 ypos+80 6 6 3], ...
        [xpos+20 ypos+125 4 4 2], ...
        [xpos+16 ypos+165 6 6 3], ...
        [xpos+30 ypos+180 3 3 1], ...
        [xpos-50 ypos+183 3 3 1]};
    
    xS = [];
    xE = [];
    yS = [];
    yE = [];
    nAnimations = length(posBubbles);
    for iAnimations = 1 : nAnimations
        for iBubbles = 1 : nBubbles(iAnimations)
            xS = min([xS, posBubbles(iAnimations).b{iBubbles}(1) + posBubbles(iAnimations).b{iBubbles}(3), ...
                posBubbles(iAnimations).b{iBubbles}(1) - posBubbles(iAnimations).b{iBubbles}(3)]);
            xE = max([xE, posBubbles(iAnimations).b{iBubbles}(1) + posBubbles(iAnimations).b{iBubbles}(3), ...
                posBubbles(iAnimations).b{iBubbles}(1) - posBubbles(iAnimations).b{iBubbles}(3)]);
            yS = min([yS, posBubbles(iAnimations).b{iBubbles}(2) + posBubbles(iAnimations).b{iBubbles}(4), ...
                posBubbles(iAnimations).b{iBubbles}(2) - posBubbles(iAnimations).b{iBubbles}(4)]);
            yE = max([yE, posBubbles(iAnimations).b{iBubbles}(2) + posBubbles(iAnimations).b{iBubbles}(4), ...
                posBubbles(iAnimations).b{iBubbles}(2) - posBubbles(iAnimations).b{iBubbles}(4)]);
        end
    end
    
    
    addMargin = 20;
    xS = abs(xS) + addMargin/2; 
    xE = abs(xE);
    yS = abs(yS)+ addMargin/2;
    yE = abs(yE);
    
    figSize.width = xS + xE + addMargin;
    figSize.heigth = yE + addMargin;

    % redistribute bubbles according to absolute positions in figure
    for iAnimations = 1 : nAnimations
        for iBubbles = 1 : nBubbles(iAnimations)
           posBubbles(iAnimations).b{iBubbles}(1) = figSize.width - (posBubbles(iAnimations).b{iBubbles}(1) + xS);
           posBubbles(iAnimations).b{iBubbles}(2) = figSize.heigth - (posBubbles(iAnimations).b{iBubbles}(2) + yS);
           posBubbles(iAnimations).b{iBubbles}(3) = posBubbles(iAnimations).b{iBubbles}(1) + posBubbles(iAnimations).b{iBubbles}(3);
           posBubbles(iAnimations).b{iBubbles}(4) = posBubbles(iAnimations).b{iBubbles}(2) + posBubbles(iAnimations).b{iBubbles}(4);
%            posBubbles(iAnimations).b{iBubbles}(5) = ; %thickness of border of the bubble
        end
    end
    
    

    fid = fopen('../img/drawBubbles.sh', 'wt');
    fprintf(fid, '#!/bin/bash\n');
    for iAnimations = 1 : nAnimations
        fprintf(fid, 'convert -size %ix%i xc:none \\\n', figSize.width, figSize.heigth);
        for iBubbles = 1 : nBubbles(iAnimations)
%             fprintf(fid, '-draw "fill rgb(%i,%i,%i,%i%%)', 0, 115, 255, 100);
%             fprintf(fid, ' stroke rgb(%i,%i,%i,%i%%) ', 198, 241, 255, 100);
%             fprintf(fid, '-draw "fill rgb(%i,%i,%i)', 0, 115, 255);
            fprintf(fid, '-draw "fill rgb(%i,%i,%i)', 29, 159, 201);
%             fprintf(fid, ' stroke rgb(%i,%i,%i) ', 198, 241, 255);
            fprintf(fid, ' stroke rgb(%i,%i,%i) ', 255, 255, 255);
%             lineWidth = 5;
            fprintf(fid, 'stroke-width %i circle ', posBubbles(iAnimations).b{iBubbles}(5));
            fprintf(fid, '%i,%i %i,%i" \\\n', posBubbles(iAnimations).b{iBubbles}(1:4));
        end
        fprintf(fid, '-background none -alpha Background bubbles_%i.png\n', iAnimations);
    end
    
    fclose(fid);
    
end
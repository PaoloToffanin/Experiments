function drawBubbles

% addpath('../lib/SpriteKit');
% close(gcf)

% G = SpriteKit.Game.instance('Title','Flying Membrane Demo', 'ShowFPS', false);

% s = SpriteKit.Sprite(sprintf('friend%d', i));
%         
% s.initState('state1', ['../img/fixed/' 'octopus_talk_a.png'], true);
% %% Setup the Sprite
% 
% [nBubbles, posBubbles] = makeBubbles(s);
[nBubbles, posBubbles, figSize] = makeBubbles_abs(0, 0);
% statusCounter = 1;
bubbles = {};
nStatuses = length(nBubbles);
%% Run it!

% the good ration is 85*225

    % added 10 because otherwise it will cut one of the bubbles up
    figure('PaperUnits','inches','Position', [0, 0, figSize.width, figSize.heigth + 10], 'color','none');
    for statusCounter =  1 : nStatuses
        bubbles = {};
%         figure
        for iBubbles = 1 : nBubbles(statusCounter)
            bubbles{iBubbles} = rectangle('Curvature', [1 1], 'Position', [posBubbles(statusCounter).b{iBubbles}], 'FaceColor', [0 115 255]./255, ...
                'EdgeColor', [198 241 255]./255, 'LineWidth', 2);
        end
        axis([0 figSize.width 0 figSize.heigth + 10])
        axis off
        daspect([1,1,1])
%         
%         set(gcf,'PaperPositionMode','auto')
%         set(gcf,'color','none');
%         set(gcf,'PaperUnits','inches','PaperPosition',[0 0 figSize.width/100, figSize.heigth/100],'color','none')
%          cdata{statusCounter} = print('-RGBImage');
%         imwrite(gca, 'a.png', 'png', 'transparency', [1 1 1])
%         print('-dpng', '-r20', ['bubbles_' num2str(statusCounter) '.png']);
        imwrite(print('-RGBImage'), ['bubbles_' num2str(statusCounter) '.png'], 'png', 'transparency', [1 1 1])
        for iBubbles = 1 : nBubbles(statusCounter)
            bubbles{iBubbles}.delete
        end

    end
    
    close all
end
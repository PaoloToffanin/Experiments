classdef GameTest < matlab.unittest.TestCase
%GAMETEST Unittest for SpriteKit.Game.
    %
    % Run by executing:
    %
    %  run(SpriteKit.unittest.GameTest)

    % Copyright 2014 The MathWorks, Inc.
    
    methods (Test)
        
        function smoke(testCase)
            
            close all force
            
            G = SpriteKit.Game.instance();
            testCase.verifyNumElements(findall(0,'Type','figure'),1)
            
            delete(G);
            testCase.verifyNumElements(findall(0,'Type','figure'),0)
            
        end
        
        function singleton(testCase)
            
            testCase.verifyError(@()SpriteKit.Game,...
                'MATLAB:class:MethodRestricted')
            
            G1 = SpriteKit.Game.instance();
            G2 = SpriteKit.Game.instance();
            
            testCase.verifyNumElements(findall(0,'Type','figure'),1)
            testCase.verifyEqual(G1,G2)
            
            delete(G1)
            
        end
        
        function figureprops(testCase)
            
            G = SpriteKit.Game.instance();
            fig = findall(0,'Type','figure');
            
            pos = get(fig,'Position');
            testCase.verifyEqual(G.Location,pos(1:2))
            testCase.verifyEqual(G.Size,pos(3:4))
            
            G.Title          = 'foo';
            G.onKeyPress     = 'kp';
            G.onKeyRelease   = 'kr';
            G.onMousePress   = 'mp';
            G.onMouseRelease = 'mr';
            
            testCase.verifyEqual(get(fig,'Name'),'foo');
            testCase.verifyEqual(get(fig,'WindowKeyPressFcn'),'kp');
            testCase.verifyEqual(get(fig,'WindowKeyReleaseFcn'),'kr');
            testCase.verifyEqual(get(fig,'WindowButtonDownFcn'),'mp');
            testCase.verifyEqual(get(fig,'WindowButtonUpFcn'),'mr');
            
            delete(G);
            
        end
        
        function axesprops(testCase)
            
            G = SpriteKit.Game.instance();
            ax = findall(0,'Type','axes');
            
            testCase.verifyEqual(get(ax,'Visible'),'off')
            testCase.verifyEqual(get(ax,'Units'),'normalized')
            xL = get(ax,'XLim');
            yL = get(ax,'YLim');
            testCase.verifyEqual([xL(2) yL(2)],G.Size)
            
            delete(G)
            
        end
        
    end
    
end
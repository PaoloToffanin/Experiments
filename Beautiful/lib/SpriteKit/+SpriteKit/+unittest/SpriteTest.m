classdef SpriteTest < matlab.unittest.TestCase
%SPRITETEST Unittest for SpriteKit.Sprite.
    %
    % Run by executing:
    %
    %  run(SpriteKit.unittest.SpriteTest)

    % Copyright 2014 The MathWorks, Inc.
    
    methods (Test)
        
        function smoke(testCase)
            
            G = SpriteKit.Game.instance();
            
            S = SpriteKit.Sprite('foo');
            
            S.initState('on',randi(255,10,10,3))
            
            S.State = 'on';
            
            hgt = findall(0,'Type','hgtransform');
            testCase.assertNumElements(hgt,1)
            
            surfObj = findall(0,'Type','surface');
            testCase.assertNumElements(surfObj,1)
            
            testCase.verifyEqual(get(surfObj,'Parent'),hgt)
            
            delete(G)
            
        end
        
        function gfxprops(testCase)
            
            G = SpriteKit.Game.instance();
            S = SpriteKit.Sprite('foo');
            S.initState('on',randi(255,10,10,3))
            S.State = 'on';
            
            hgt = findall(0,'Type','hgtransform');
            
            S.Location = [0 0];
            testCase.verifyEqual(get(hgt,'Matrix'),eye(4))
            
            S.Location = [200 100];
            S.Scale = 3.1;
            S.Depth = 4.6;
            S.Angle = 35;
            
            M = makehgtform(...
                'translate',[200 100 4.6-1],...
                'zrotate',35*pi/180,...
                'scale',3.1);
            
            testCase.verifyEqual(get(hgt,'Matrix'),M)
            
            delete(G)
            
        end
        
        function statequeue(testCase)
            
            G = SpriteKit.Game.instance();
            S = SpriteKit.Sprite('foo');
            S.initState('A',randi(255,5,5,3))
            S.initState('B',randi(255,10,10,3))
            S.initState('C',randi(255,20,20,3))
            S.State = 'A';
            
            surfObj = findall(0,'Type','surface');
            
            testCase.verifySize(get(surfObj,'CData'),[6 6 3])
            
            S.State = 'B';
            testCase.verifySize(get(surfObj,'CData'),[11 11 3])
            
            S.cycleNext;
            testCase.verifyEqual(S.State,'C')
            testCase.verifySize(get(surfObj,'CData'),[21 21 3])
            
            S.cycleNext;
            testCase.verifyEqual(S.State,'A')
            testCase.verifySize(get(surfObj,'CData'),[6 6 3])
            
            S.cyclePrevious;
            testCase.verifyEqual(S.State,'C')
            testCase.verifySize(get(surfObj,'CData'),[21 21 3])
            
            % reset to 'none'
            S.State = 'none';
            S.cycleNext;
            % should go to A
            testCase.verifyEqual(S.State,'A')
            testCase.verifySize(get(surfObj,'CData'),[6 6 3])
            
            S.cyclePrevious;
            % should skip 'none' and go to C
            testCase.verifyEqual(S.State,'C')
            testCase.verifySize(get(surfObj,'CData'),[21 21 3])
            
            delete(G)
            
        end
        
    end
    
end
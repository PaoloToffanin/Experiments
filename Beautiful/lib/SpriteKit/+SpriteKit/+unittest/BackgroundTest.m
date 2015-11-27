classdef BackgroundTest < matlab.unittest.TestCase
%BACKGROUNDTEST Unittest for SpriteKit.Background.
    %
    % Run by executing:
    %
    %  run(SpriteKit.unittest.BackgroundTest)

    % Copyright 2014 The MathWorks, Inc.
    
    methods (Test)
        
        function smoke(testCase)
            
            G = SpriteKit.Game.instance();
            SpriteKit.Background(rand(100,100,3));
            
            testCase.verifyNumElements(findall(0,'Type','image'),1)
            
            delete(G);
            
        end
        
        function imageInputs(testCase)
            
            G = SpriteKit.Game.instance();
            SpriteKit.Background('+SpriteKit/+unittest/img/redsquare.png');
            
            testCase.verifyNumElements(findall(0,'Type','image'),1)
            
            delete(G);
            
        end
        
        function scrolling(testCase)
            
            G = SpriteKit.Game.instance();
            bkg = SpriteKit.Background(rand(100,100,3));
            
            bkg.scroll('left',10)
            bkg.scroll('right',34)
            bkg.scroll('up',51)
            bkg.scroll('down',987)
            
            testCase.verifyNumElements(findall(0,'Type','image'),1)
            
            testCase.verifyError(@()bkg.scroll('foo',1),...
                'MATLAB:SpriteKit:BadScrollDirection')
            
            delete(G)
            
        end
        
    end
    
end
classdef LayerTest < matlab.unittest.TestCase
%LAYERTEST Unittest for SpriteKit.internal.Layer.
    %
    % Run by executing:
    %
    %  run(SpriteKit.unittest.LayerTest)

    % Copyright 2014 The MathWorks, Inc.
    
    methods (Test)
        
        function smoke(testCase)
            
            L = SpriteKit.internal.Layer(rand(10,10,3),false);
            
            testCase.verifyTrue(isprop(L,'BData'))
            testCase.verifyTrue(isprop(L,'CData'))
            testCase.verifyTrue(isprop(L,'XData'))
            testCase.verifyTrue(isprop(L,'YData'))
            testCase.verifyTrue(isprop(L,'ZData'))
            
        end
        
        function centering(testCase)
            
            L = SpriteKit.internal.Layer(rand(5,10,3),false);
            
            row = L.XData(1,:);
            col = L.YData(:,1);
            
            testCase.verifyEqual(row,-5:5)
            testCase.verifyEqual(col,(2.5:-1:-2.5)')
            
        end
        
        function inputs(testCase)
            
            testCase.verifyError(@()SpriteKit.internal.Layer(5),...
                'MATLAB:narginchk:notEnoughInputs')
            testCase.verifyError(@()SpriteKit.internal.Layer(5,false),...
                'MATLAB:SpriteKit:BadCData')
            testCase.verifyError(@()SpriteKit.internal.Layer('foo',false),...
                'MATLAB:imagesci:imread:fileDoesNotExist')
            
            imgDir = '+SpriteKit/+unittest/img/';
            
            SpriteKit.internal.Layer([imgDir 'redsquare.bmp'],false);
            SpriteKit.internal.Layer([imgDir 'redsquare.jpg'],false);
            SpriteKit.internal.Layer([imgDir 'redsquare.png'],false);
            % each will have *slightly* different RGB values, so we can't
            % compare to each other.
            
        end
        
        function transparency(testCase)
            
            c = ones(12,13,3);
            c(4:10,3:10,:) = .5;
            expC = c;
            expC(end+1,:,:) = 1;
            expC(:,end+1,:) = 1;
            
            opaque = SpriteKit.internal.Layer(c,false);
            
            testCase.verifySize(opaque.XData,[12 13]+1)
            testCase.verifySize(opaque.YData,[12 13]+1)
            testCase.verifyEqual(opaque.ZData,ones(12+1,13+1))
            testCase.verifyEqual(opaque.CData,expC)
            testCase.verifySize(opaque.BData,[51 2])
            
            trans = SpriteKit.internal.Layer(c,true);
            
            expZ = NaN(12+1,13+1);
            expZ(4:10,3:10) = 1;
            testCase.verifySize(trans.XData,[12 13]+1)
            testCase.verifySize(trans.YData,[12 13]+1)
            testCase.verifyEqual(trans.ZData,expZ)
            testCase.verifyEqual(trans.CData,expC)
            testCase.verifySize(trans.BData,[27 2])
            
        end
        
    end
    
end

%%  Test program for TANDEM STRAIGHT installation
%   27/Nov./2007
%   Designed and coded by Hideki Kawahara
%   21/Oct./2008 revised using new aperiodicity extractor

disp('This script demonstrates how to use TANDEM-STRAIGHT API.');
disp('Please type ENTER or RETURN key if you are ready.');
pause

%%  Initial check

a.ThisIsAnExampleOfVeryLongFieldName = 1;
b.ThisIsAnExampleOfVeryLongFieldNameWithSomeDifference = 1;

display(' ')
if isfield(b,'ThisIsAnExampleOfVeryLongFieldName')
    display('This Matlab version may cause errors when using STRAIGHT.')
else
    display('Name length test is OK.');
end;

%%  Reading a file

display('Now, reading a test speech file.')

echo on

[x,fs] = wavread('vaiueo2d.wav');
%[x,fs] = wavread('baseTamdemSTRAIGHTV009s/kousyouAD24.wav');
%[x,fs] = wavread('bakuon2.wav');
[x,fs] = wavread('sc005org.wav');
%[x,fs] = wavread('shout1.wav');
%[x,fs] = wavread('openTheCrate.wav');
%[x,fs] = wavread('kousyouAD24.wav');

echo off

display(' ')
disp('Please type ENTER or RETURN key to hear the sound.');
pause

display('It sound like this. (Sound reproduction depends on your machine)')
soundsc(x,fs)


%%  Source information extraction

display(' ')
display('First of all, source information have to be extracted.')
display('Source information consisis of fundamental frequency and aperiodicity')
disp('Please type ENTER or RETURN key if you are ready.');
pause
display(' ')
display('Extraction may needs time. Please waight a moment for completion.')

echo on

%opt.framePeriod = 2.5;
clear optP
        optP.debugperiodicityShaping = 1.3;
        optP.channelsPerOctave = 3;
        optP.f0ceil = 650;
r = exF0candidatesTSTRAIGHTGB(x,fs,optP)

echo off

display('Fundamental frequency candidates look like this.')

echo on

figure;
semilogy(r.temporalPositions,r.f0CandidatesMap','.','markersize',20);grid on;
set(gca,'fontsize',14);
xlabel('time (s)')
ylabel('fundamental frequency (Hz)');
title('fundamental frequency candidates')
axis([r.temporalPositions(1) r.temporalPositions(end) 30 800]);

echo off

display(' ')
display('Each candidates are associated with a score.')

echo on

figure;
plot(r.temporalPositions,r.f0CandidatesScoreMap','.','markersize',20);grid on;
set(gca,'fontsize',14);
xlabel('time (s)')
ylabel('score of likliness');
title('likeliness of fundamental component')
axis([r.temporalPositions(1) r.temporalPositions(end) 0 1.1])

echo off

display(' ')
display('The order of color is the following:')
display('1:blue, 2:green, 3:red, 4:cyan and 5:magenta ')

%%  VUV decision

display(' ')
display('The score can be used to select the best F0 candidates and')
display('to make V/UV decision, like this.')
disp('Please type ENTER or RETURN key if you are ready.');
pause
display(' ')

echo on

rc = r; % copying contents
%rc.f0 = r.f0.*(r.f0CandidatesScoreMap(1,:)'>1.4);
%rc = vuvDetector(r);
rc = autoF0Tracking(r,x);

figure;
plot(rc.temporalPositions,rc.f0);grid on
set(gca,'fontsize',14);
xlabel('time (s)')
ylabel('fundamental frequency (Hz)');
title('fundamental frequency')

echo off

%%  Periodicity information

display(' ')
display('The next source related information is periodicity spectrogram.')
disp('Please type ENTER or RETURN key if you are ready.');
pause
display(' ')

echo on

q = aperiodicityRatio(x,rc,1)

displayAperiodicityStructure(q,1);
echo off


%%  spectral analysis using TANDEM windowing and STRAIGHT smoothing


display(' ')
display('Spectral extraction requires the original signal and')
display('source information extracted in the first step')
disp('Please type ENTER or RETURN key if you are ready.');
pause
display(' ')
display('Extraction may needs time. Please waight a moment for completion.')

echo on

clear prmIn
prmIn.exponentControl = 0.25;
%prmIn.exponentControl = 1;
prmIn.compensationCoefficient = -0.3;

f = exSpectrumTSTRAIGHTGB(x,fs,rc,prmIn)

echo off

%  spectrographic display

sgramSTRAIGHT = 10*log10(f.spectrogramSTRAIGHT);
maxLevel = max(max(sgramSTRAIGHT));
figure;
imagesc([0 f.temporalPositions(end)],[0 fs/2],max(maxLevel-80,sgramSTRAIGHT));
axis('xy')
set(gca,'fontsize',14);
xlabel('time (s)')
ylabel('frequency (Hz)');
title('STRAIGHT spectrogram')

%%  resynthesis

display(' ')
display('Resynthesis of speech uses source information and STRAIGHT spectrum')
disp('Please type ENTER or RETURN key if you are ready.');
pause
display(' ')

echo on

s = exTandemSTRAIGHTsynthNx(q,f)
soundsc(s.synthesisOut,fs)

echo off



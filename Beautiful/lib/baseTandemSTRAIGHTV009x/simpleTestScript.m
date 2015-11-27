%%  quick check for spectral estimation

fileName = 'vaiueo2d.wav';
fileName = 'openTheCrate.wav';
%fileName = 'sc005org.wav';

%%

[x,fs] = wavread(fileName);

soundsc(x,fs)
r = exF0candidatesTSTRAIGHTGB(x,fs)
rc = r;
%%rc = vuvDetector(r);
rc = autoF0Tracking(r,x);
rc.vuv = refineVoicingDecision(x,rc);

figure;
plot(rc.temporalPositions,rc.f0);grid on
set(gca,'fontsize',14);
xlabel('time (s)')
ylabel('fundamental frequency (Hz)');
title('fundamental frequency')

q = aperiodicityRatio(x,rc,1)

displayAperiodicityStructure(q,1);

f = exSpectrumTSTRAIGHTGB(x,fs,q)

sgramSTRAIGHT = 10*log10(f.spectrogramSTRAIGHT);
maxLevel = max(max(sgramSTRAIGHT));
figure;
imagesc([0 f.temporalPositions(end)],[0 fs/2],max(maxLevel-80,sgramSTRAIGHT));
axis('xy')
set(gca,'fontsize',14);
xlabel('time (s)')
ylabel('frequency (Hz)');
title('STRAIGHT spectrogram')

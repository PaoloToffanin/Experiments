%%  calculate compensation digital filter
%   by Hideki Kawahara
%   15/Oct./2009
%   18/Oct./2009 extended for general exponent

fs = 44100;
f0 = 100/99.7367*100;
t0 = fs/f0;
wLength = round(t0*2.5);
w = blackman(wLength);
w = w/sum(w);
fftl = 2^(ceil(log2(wLength*32)));

fx = (0:fftl-1)/fftl*fs;
dfx = fx(2);
f0InBin = f0/dfx;

for ii = 1:10
    exponentValue = 1/ii;
    
    %f0InBin/round(f0InBin)*100
    powerWin = abs(fft(w,fftl)).^2;
    powerWin = powerWin.^exponentValue;
    powerWin = powerWin/max(powerWin);
    %smoother = [1:149, 148:-1:1]; % triangular smoother
    smoother = ones(1,149); % rectangular smoother
    smoother = smoother/sum(smoother);
    
    smoothedPowerWin = conv(smoother,fftshift(powerWin));
    
    [maxv,maxIndex] = max(smoothedPowerWin);
    
    baseIndex = maxIndex+[-4*round(f0InBin):4*round(f0InBin)];
    %figure;plot((baseIndex-maxIndex)/f0InBin,smoothedPowerWin(baseIndex));grid on;
    
    coefficients = smoothedPowerWin(maxIndex+round(f0InBin)*[-2:2]);
    coefficients = (coefficients/max(coefficients))';
    
    aaa = fft(coefficients,1024);
    bbb = ifft(1.0./aaa);
    compensationCoefficients = fftshift(bbb);
    [maxp,maxIndex] = max(real(compensationCoefficients));
    compensationCoefficients = compensationCoefficients(maxIndex+[0:5]);
    truncatedQ1 = compensationCoefficients(2:5)/compensationCoefficients(1);
    formatStr = '%11.6f';
    disp([num2str(1) '/' num2str(ii) '  ' num2str(truncatedQ1,formatStr)]);
    
end;

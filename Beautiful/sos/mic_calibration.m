% mic calibration:

%       RECORD TRIAL (STIMULUS + RESPONSE):
        recObj = audiorecorder(22050,24,1,0);
        disp('Recording...')
        record(recObj);
        
        stop(recObj);
        disp('End of Recording.');
        y = getaudiodata(recObj);
        fs = recObj.SampleRate;
        
        audiowrite('test4.flac',y,fs,'BitsPerSample',24);
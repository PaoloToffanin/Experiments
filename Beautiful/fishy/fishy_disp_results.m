function fishy_disp_results(subject)

options = fishy_options();
filename = fullfile(options.result_path, [options.result_prefix, subject, '.mat']);

load(filename);

phase = 'test';

rtimes = [];

for ic = 1:length(results.(phase).conditions)
    fprintf('RUN %d/%d\n', ic, length(results.(phase).conditions))
    
    c = results.(phase).conditions(ic);
    
    t = c.att(1).responses(1).trial;
    if t.vocoder>0
        v = options.vocoder(t.vocoder);
        fprintf(' Vocoder: [%s] Hz, %d bands, fc=%d Hz, shift=%.1f mm, %s\n', num2str(v.range), v.nbands, v.fc, v.shift, v.excitation);
    else
        fprintf(' Vocoder: None\n');
    end
    fprintf(' Voices: %s -> %s\n', options.(phase).voices(t.ref_voice).label, options.(phase).voices(t.dir_voice).label);
    
    for ia = 1:length(c.att)
        fprintf(' Attempt %d/%d:\n', ia, length(c.att))
        a = c.att(ia);
        
        fprintf('   %d responses, %d differences\n', length(a.responses), length(a.differences));
        fprintf('   Threshold: %f (sd %f)\n', a.threshold, a.sd);
        fprintf('   Exit reason: %s\n', a.exit_reason);
        tstamps = [a.responses.timestamp];
        rtime  = max(tstamps)-min(tstamps);
        rtimes = [rtimes, rtime];
        fprintf('   Total run time: %s\n', datestr(rtime, 'HH:MM:SS'));
        
    end
    
    fprintf('\n');
end


fprintf('\n\nAverage run duration: %s\n', datestr(mean(rtimes), 'HH:MM:SS'));
fprintf('Average time spent per run (including breaks): %s\n', ...
    datestr((results.(phase).conditions(end).att(end).responses(end).timestamp - results.(phase).conditions(1).att(1).responses(1).timestamp)/length(results.(phase).conditions), 'HH:MM:SS'));


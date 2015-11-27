function fishy_plot_run(subject, i_run)

options = fishy_options();
filename = fullfile(options.result_path, [options.result_prefix, subject, '.mat']);

load(filename);

phase = 'test';
which_threshold = 'last_2_tp';

c = results.(phase).conditions(i_run);
a = c.att(end);
response_correct = [a.responses.correct];

figure()
subplot(1, 2, 1)
x = 1:length(a.differences);
y = a.differences(1:end);
response_correct = response_correct(1:end);
plot(x, y, '-b')
hold on
plot(length(a.differences)+[-1 0], a.differences(end-1:end), '--b')
plot(x(response_correct==1), y(response_correct==1), 'ob')
plot(x(response_correct==0), y(response_correct==0), 'xb')

%plot(x(i_tp), y(i_tp), 'sr')

switch which_threshold
    case 'last_3_tp'
        i_nz = find(a.steps~=0);
        i_d  = find(diff(sign(a.steps(i_nz)))~=0);
        i_tp = i_nz(i_d)+1;
        i_tp = [i_tp, length(a.differences)];
        i_tp = i_tp(end-2:end);

        a.threshold = mean(a.differences(i_tp));

    case 'last_2_tp'
        i_nz = find(a.steps~=0);
        i_d  = find(diff(sign(a.steps(i_nz)))~=0);
        i_tp = i_nz(i_d)+1;
        i_tp = [i_tp, length(a.differences)];
        i_tp = i_tp(end-1:end);

        a.threshold = mean(a.differences(i_tp));

    otherwise
        i_tp = a.diff_i_tp;
        a.threshold = a.threshold;
end

plot([1, length(a.differences)], [1 1]*a.threshold, '--k');
plot(x(i_tp), y(i_tp), 'sr')

hold off
title(sprintf('Condition %d', i_run));

condition = a.responses(1).condition;

if isfield(expe, 'functions')
    expe.functions.print_condition(condition, options);
end

subplot(1, 2, 2)
plot([options.test.voices(condition.ref_voice).f0, options.test.voices(condition.dir_voice).f0], ...
        [options.test.voices(condition.ref_voice).ser, options.test.voices(condition.dir_voice).ser], '--b')
hold on
plot(options.test.voices(condition.ref_voice).f0, options.test.voices(condition.ref_voice).ser, 'ob')
plot(options.test.voices(condition.dir_voice).f0, options.test.voices(condition.dir_voice).ser, 'sr')
for i_resp=1:length(a.responses)
    if a.responses(i_resp).correct
        plot(a.responses(i_resp).trial.f0(2), ...
            a.responses(i_resp).trial.ser(2), 'xk')
    else
        plot(a.responses(i_resp).trial.f0(2), ...
            a.responses(i_resp).trial.ser(2), '+', 'Color', [1 1 1]*.7)
    end
end

for i_sp=1:length(options.test.voices)
    plot(options.test.voices(i_sp).f0, options.test.voices(i_sp).ser, '+g');
end

hold off

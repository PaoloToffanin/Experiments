function fishy_results(subject)

if nargin<1
    subject = 'all';
end

options = fishy_options();
db_filename = fullfile(options.result_path, [options.result_prefix, 'db.sqlite']);
db = mksqlite('open', db_filename);

res_voc = mksqlite(db, 'SELECT vocoder, vocoder_nbands, vocoder_fc, vocoder_range FROM thr GROUP BY vocoder');
voc = [res_voc.vocoder];

cols = jet(length(voc))*.7;
lw = 2;

for i=1:length(voc)
    %subplot(1, length(voc), i);
    col = cols(i,:);
    
    switch subject
        case 'all'
            res = mksqlite(db, sprintf('SELECT ref_f0, ref_ser, dir_f0, dir_ser, AVG(threshold_f0) AS thr_f0, AVG(threshold_ser) AS thr_ser, AVG(threshold) AS thr, AVG(threshold*threshold) AS thr_2, COUNT(*) AS n  FROM thr WHERE vocoder=%d GROUP BY dir_f0, dir_ser', voc(i)));

        otherwise
            res = mksqlite(db, sprintf('SELECT ref_f0, ref_ser, dir_f0, dir_ser, AVG(threshold_f0) AS thr_f0, AVG(threshold_ser) AS thr_ser, AVG(threshold) AS thr, AVG(threshold*threshold) AS thr_2, COUNT(*) AS n FROM thr WHERE vocoder=%d AND subject=''%s'' GROUP BY dir_f0, dir_ser', voc(i), subject));

    end

    dir_f0  = [res.dir_f0];
    dir_ser = [res.dir_ser];
    n = [res.n];
    
    ref_f0  = res(1).ref_f0;
    ref_ser = res(1).ref_ser;
    
    thr_f0  = [res.thr_f0];
    thr_ser = [res.thr_ser];
    thr_2  = [res.thr_2];
    thr = [res.thr];
    
    % Sort properly
    u = log2(dir_f0 / ref_f0) + 1i * log2(dir_ser / ref_ser);
    a = angle(u);
    a(a>=pi) = a(a>=pi)-2*pi;
    u = u./abs(u);
    
    [~, ix] = sort(a);
    
    dir_f0 = 12*log2(dir_f0(ix)/ref_f0);
    dir_ser = 12*log2(dir_ser(ix)/ref_ser);
    thr_f0 = thr_f0(ix);
    thr_ser = thr_ser(ix);
    thr_2 = thr_2(ix);
    n = n(ix);
    thr = thr(ix);
    u = u(ix);
    
    se = sqrt((thr_2 - thr.^2))./sqrt(n);
    
    for j=1:length(dir_f0)
        plot([0 dir_f0(j)], [0 dir_ser(j)], ':+', 'Color', [1 1 1]*.5);
        hold on
        %plot(thr_f0(j)+se(j)*[-1 1]*real(u(j)), thr_ser(j)+se(j)*[-1 1]*imag(u(j)), '-o', 'Color', col, 'MarkerSize', 4);
    end
    
    plot(0, 0, '+k');
    
    if i==1
        switch subject
            case 'all'
                xlabel('GPR difference (semitones)')
                ylabel('VTL difference (semitones)')

                xlim([-1, 1]*8)
                ylim([-1, 1]*10.2)
                set(gcf, 'PaperPosition', [0 0 .85 1]*8);
                print(gcf, '-dpng', '-r200', sprintf('./results/Results_%s_%d.png', subject, 0));
        end
    end
    
    for j=1:length(dir_f0)
        plot(thr_f0(j)+se(j)*[-1 1]*real(u(j)), thr_ser(j)+se(j)*[-1 1]*imag(u(j)), '-o', 'Color', col, 'MarkerSize', 4);
    end
    
    s = dir_f0>=0 & dir_ser>=0;
    h(i) = plot(thr_f0(s), thr_ser(s), '-o', 'Color', col, 'LineWidth', lw);
    
    s = dir_f0<=0 & dir_ser<=0;
    plot(thr_f0(s), thr_ser(s), '-o', 'Color', col, 'LineWidth', lw);
    
    s = (dir_f0==0 & dir_ser>0) | (dir_f0<0 & dir_ser==0);
    plot(thr_f0(s), thr_ser(s), '--', 'Color', col, 'LineWidth', lw);
    
    s = (dir_f0==0 & dir_ser<0) | (dir_f0>0 & dir_ser==0);
    plot(thr_f0(s), thr_ser(s), '--', 'Color', col, 'LineWidth', lw);
    
    %hold off
    
    %title(sprintf('Vocoder %d (%s, %d bands, fc %d Hz)', voc(i), res_voc(i).vocoder_range, res_voc(i).vocoder_nbands, res_voc(i).vocoder_fc));
    if voc(i)==0
        labels{i} = 'No vocoder / natural speech';
    else
        labels{i} = sprintf('Vocoder %d: %2d bands, %s, fc %d Hz', voc(i), res_voc(i).vocoder_nbands, res_voc(i).vocoder_range, res_voc(i).vocoder_fc);
    end
        
    %set(gca, 'XScale', 'log', 'Yscale', 'log');
    f = 1.01;
    %[min(ref_f0*2.^(thr_f0/12))/f, max(ref_f0*2.^(thr_f0/12))*f]
    %[min(ref_ser*2.^(thr_ser/12))/f, max(ref_ser*2.^(thr_ser/12))*f]
    xlim([-1, 1]*8)
    ylim([-1, 1]*10.2)

    xlabel('GPR difference (semitones)')
    ylabel('VTL difference (semitones)')

    legend(h, labels);
    
    switch subject
        case 'all'

            set(gcf, 'PaperPosition', [0 0 .85 1]*8);
            print(gcf, '-dpng', '-r200', sprintf('./results/Results_%s_%d.png', subject, i));
    end
    
end

hold off


set(gcf, 'PaperPosition', [0 0 .85 1]*8);
print(gcf, '-dpng', '-r200', sprintf('./results/Results_%s.png', subject));

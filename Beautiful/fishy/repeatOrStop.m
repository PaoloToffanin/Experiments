function [expe, options] = repeatOrStop(phase, options, G)

    oldimage = get(0,'DefaultImageVisible');
    set(0, 'DefaultImageVisible','off')
    button = questdlg(sprintf('The "%s" phase is finished.\n would you like to repeat it?', ...
        strrep(phase, '_', ' ')), '', 'Yes', 'No', 'Yes');
    
    set(0, 'DefaultImageVisible', oldimage)
    
    if strcmp(button, 'No')
        msgbox('OK, ciaociao')
        close(G.FigureHandle);
        expe = [];
        options = [];
    else
        uiwait(msgbox('New stimuli are generating ## New structures will be saved'))
        % check how many files are there and add number of attempt accordingly
%         filesList = dir(fullfile(options.result_path, sprintf('*%s*.mat', options.subject_name)));
%         options.subject_name = sprintf('%s_%d', options.subject_name, length(filesList)+1); 
%         res_filename = fullfile(options.result_path, sprintf('%s%s.mat', options.result_prefix, options.subject_name));
%         options.res_filename = res_filename;
        % piece above replaced by adding attempts number
        options.extendStructures = true;
        % note expe can nicely be overwritten since results have all the
        % expe specifications as well. results need however to be extended
        [expe, options] = fishy_build_conditions(options); 
    end
end

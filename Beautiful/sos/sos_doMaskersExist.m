function sos_doMaskersExist(options)
    countMissing = 0;
%     [~, options] = expe_build_conditions(options);
    [~, options] = sos_build_conditions(options);
    phases = {'training', 'test'};
    nPhases = length(phases);
    for phase = 1 : nPhases

        maskerList = [];
        for i_masker_list = 1:length(options.masker)        
            masker_list = options.masker(i_masker_list);
            masker_sentences = options.list{masker_list}(1):options.list{masker_list}(2);
            maskerList = [maskerList masker_sentences];
        end
        nMaskers = length(maskerList);
        %maskerList = options.masker(1):options.masker(2);
        nconditions = length(options.(phases{phase}).voices) ;
        nMasks = length(options.maskerSex);
        for iMask = 1 : nMasks
            for iVoices = 1 : nconditions
                for file = 1 : nMaskers
                    wavOut = [options.tmp_path 'M_' options.maskerSex{iMask} ...
                        sprintf('%i_GPR%.2f_SER%.2f', maskerList(file), ...
                        options.(phases{phase}).voices(iVoices).f0, ...
                        options.(phases{phase}).voices(iVoices).ser) ...
                        '.wav'];
                    if ~exist(wavOut, 'file')
                        countMissing = countMissing + 1;
                    end
                end
            end
        end
    end
    if countMissing > 1
        ButtonName = questdlg(sprintf('Create %i Maskers files?', countMissing), ...
            sprintf('%i Maskers do not exist', countMissing), ...
            'Yes', 'No', 'No');
        switch ButtonName,
            case 'Yes',
                disp('Note that this might take a 10-15 minutes');
                sos_createMaskers(options)
            case 'No',
                return
        end % switch
    end
end
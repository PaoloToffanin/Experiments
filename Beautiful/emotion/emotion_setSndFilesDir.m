function options = emotion_setSndFilesDir(options, cue)

    switch cue
        case 'normalized'
            options.soundDir = [options.home '/sounds/Emotion_normalized/'];
        case 'intact'
            options.soundDir = [options.home '/sounds/Emotion/'];
        otherwise
            error('cue option does not exists')
    end
end

function options = emotion_setSndFilesDir(options, cue)

    switch cue
        case 'normalized'
            options.soundDir = [options.home '/Sounds/Emotion_normalized/'];
        case 'intact'
            options.soundDir = [options.home '/Sounds/Emotion/'];
        otherwise
            error('cue option does not exists')
    end
end

function options = nva_options

    options.noise = 1; % noise (1) yes or (0) not
    options.TMR = [0 5 10];
    rng('shuffle')
    options.TMR = options.TMR(randperm(length(options.TMR)));
    options.attenuation_dB = 0;

end
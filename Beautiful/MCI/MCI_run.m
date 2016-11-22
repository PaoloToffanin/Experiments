function MCI_run

    rng('shuffle')
    run('../defineParticipantDetails.m')

    phases = {'training', 'test'};
    for iphase = 1 : 2
        MCI_GUI(phases{iphase}, participant);
    end
end

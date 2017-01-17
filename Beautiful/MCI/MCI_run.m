function MCI_run

    rng('shuffle')
    run('../defineParticipantDetails.m')
    MCI_GUI(participant)
end
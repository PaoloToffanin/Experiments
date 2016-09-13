
rng('shuffle')
run('../defineParticipantDetails.m')

MCI_GUI('training', participant);

MCI_GUI('test', participant);


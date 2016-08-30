
rng('shuffle')
run('../defineParticipantDetails.m')


mci_GUI('training', participant);

mci_GUI('test', participant);


function Out=cosgate(In,Fe,Tr)
%COSGATE - gate a signal with a cosinus envelope
%   OUT = COSGATE(IN, FE, TR) gates the IN data at its extremities.
%   FE is the sample rate (samples per sec). TR is the length of the
%   each ramp, in seconds.
%
%   Note that In must be a vector, not a matrix.
%
%   AUTHOR
%       N. Grimault (ngrimault@olfac.univ-lyon1.fr,
%       Laboratoire de Neurosciences et Systèmes Sensoriels,
%       UMR-CNRS 5020, 50 av. Tony Garnier, 69366 LYON Cedex 07, France

% Changes :
%   Et. Gaudrain (2005-04-21) :
%       - The loop is replaced by a vetorized expression.

De=floor(Tr*Fe); 

if length(De)>length(In)
    error('cosgate:ramp_too_long', 'The ramp is too long for the sound.');
end

gate=ones(size(In));
k=0:De-1;
gate(k+1)  = 1 - ( 1+cos(k*pi/(De-1)) ) / 2;
gate(end-k) = 1 - ( 1+cos(k*pi/(De-1)) ) / 2;
Out=In.*gate;
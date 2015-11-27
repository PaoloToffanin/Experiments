function env = hwrlp_envelope(x,fs,fc,order,non_linearity)

% hwrlp_envelope - Performs the envelope extraction by half wave
% rectification and low-pass filtering (hwrlp)
%   env = hwrlp_envelope(x,fs,fc)
%       Returns the envelope using cutoff frequency fc.
%       The resulting envelope is not normalized.
%   env = hwrlp_envelope(x,fs,fc,n)
%       Uses butterwoth of order n (must be even number). Default is n=8.
%
%   Note: this function uses a phase compensated 8th order Butterworth
%   filter.

%--------------------------------------------------------------------------
% Etienne Gaudrain (egaudrain@olfac.univ-lyon1.fr) - 2007-07-17
% CNRS, Universite Lyon 1 - UMR 5020
%--------------------------------------------------------------------------

if nargin<4
    order=8;
end

if nargin<5
    non_linearity=1;
end

[b a] = butter(floor(order/2), fc*2/fs, 'low');

for j = 1:size(x,2)
    y = x(:,j);
    % Half wave rectification
    y = max(y,0);
    
    if non_linearity~=1
        y = y.^non_linearity;
    end

    % Envelope extraction (with phase compensation)
    y = filter(b,a,y(end:-1:1));
    env(:,j) = filter(b,a,y(end:-1:1));
end

%--------------------------------------------------------------------------
% Test
%--------------------------------------------------------------------------
% 
% t = (0:44100)/44100;
% x = randn(1,length(t)) .* sin(2*pi*10*t);
% 
% subplot(3,1,1)
% plot(t,x)
% subplot(3,1,2)
% plot(t,hilbert_transform(x,44100,400))
% subplot(3,1,3)
% plot(t,hilbert_transform(x,44100,5))
function p = sdt_mean(x)

% P = sdt_mean(X)
%   X is a vector of boolean values. The mean is calculated and corrected
%   if 0 or 1.

%----------------
% Etienne Gaudrain <etienne.gaudrain@mrc-cbu.cam.ac.uk> - 2010-06-30
%----------------

p = mean(x);
if p==1
    p = 1-1/(2*length(x));
elseif p==0
    p = 1/(2*length(x));
end

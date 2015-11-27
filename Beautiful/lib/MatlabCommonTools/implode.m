function str = implode(glue, c, do_trim)

%IMPLODE(GLUE, CELLARRAY) - Joins items of an array with glue
%   str = IMPLODE(GLUE, C)
%       Produces a string with concatenated items of C separated with GLUE.
%   str = IMPLODE(GLUE, C, 1)
%       Removes the empty cells.


%--------------------------------------------------------------------------
% Etienne Gaudrain - epg22@cam.ac.uk - 17/03/2008
% CNBH, PDN, University of Cambridge
%--------------------------------------------------------------------------

if nargin<=2
    do_trim = 0;
end

n = length(c);

if do_trim
    for i=1:n
        if length(c{i})==0
            c(i) = [];
        end
    end
end

n = length(c);
str = '';
for i=1:n
    if i~=n
        str = sprintf('%s%s%s', str, c{i}, glue);
    else
        str = sprintf('%s%s%s', str, c{i});
    end
end

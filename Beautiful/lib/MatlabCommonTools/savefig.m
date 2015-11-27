function savefig(h, format, filename)
%SAVEFIG Saves a figure to a picture
%   savefig(h, format, filename)
%       h: is the handle of a figure
%       format: is 'png' or 'eps'
%       filename: is the output filename


switch lower(format)
    case 'png'
        d = '-dpng';
        r = '-r240';
    case 'eps'
        d = '-depsc2';
        r = '-r240';
end

print(h, d, r, '-zbuffer', filename);




end

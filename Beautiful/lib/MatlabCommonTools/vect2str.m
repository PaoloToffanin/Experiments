function s = vect2str(a)

s = '';
for i=1:length(a)
    s = [s, num2str(a(i))];
    if i~=length(a)
        s = [s, ', '];
    end
end
s = ['[', s, ']'];
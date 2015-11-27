function out = is_test_machine

[c, s] = system('hostname');
if strcmp(strtrim(s), 'lt159107.med.rug.nl')
    out = true;
else
    out = false;
end 
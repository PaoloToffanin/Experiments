function writestruct(filename,structArray,delim,newline)

% WRITESTRUCT - append a struct to a text file
%
%   WRITESTRUCT(FILENAME,STRUCTARRAY)
%       Append the STRUCTARRAY fields to the file FILENAME. The values are
%       separated with tabs, and new lines with PC like line feeds. The
%       field names are not written in the file. If the file doesn't exist,
%       it will be created.
%
%   WRITESTRUCT(FILENAME,STRUCTARRAY,DELIM)
%       Same, DELIM must be a string that will be used to separate values.
%
%   WRITESTRUCT(FILENAME,STRUCTARRAY,DELIM,NEWLINE)
%       Same, but NEWLINE is used to separate lines.
%
%   NOTE : If you don't want to append data, you'll have to delete the file
%   first :
%       delete FILENAME
%

%---------
% Copyright 2005, Etienne Gaudrain, CNRS UMR-5020, Lyon, France.
% Created 2005-04-19 
%---------

if nargin<4
    newline = '\r\n';
end
if nargin<3
    delim = '\t';
end

fid = fopen(filename, 'a');

for i=1:length(structArray)
    field_names = fieldnames(structArray);
    fprintf(fid,'%s',ConvertToString(structArray(i).(field_names{1})));
    for j=2:length(field_names)
        fprintf(fid,delim);
        fprintf(fid,'%s',ConvertToString(structArray(i).(field_names{j})));       
    end
    fprintf(fid,newline);
end

fclose(fid);


%-------------------------------------------------------------------------
% A little subroutine to convert any data to strings using the appropriate
% method

function s = ConvertToString(data)

% Data is a number
if isnumeric(data)
    if size(data)~=[1,1]
        warning('Struct containing matrices or cell arrays may produce unexpected results !');
    end
    s = num2str(data);
% Data is a string
elseif ischar(data)
    s = data;
end

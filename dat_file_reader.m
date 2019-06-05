function [data,headerInfo ] = dat_file_reader( filename,skipLine )
% This function is different from modis.txt function. The file format
% changed due to no Lat long information. Could have included a parameter
% to use same function. But didn't do that. Only change must be done in
% Line 23 where magic number 22 exist. This number defines not to read data
% till that line 22 in dat file. 
% If you want to change go ahead.
%{
    
  Mean TOA consist of the the following  Information
    B1 B2 B3 B4 B5 B6 B7 STD1 STD2 STD3 STD4 SDT5 STD6 STD7 Year DOY DATE
  
  Solar Angle Information Consist of the following Information
    Solar_Zenith Solar_Azimuth Year DOY Date (YYYYMMDD)
    
  Sensor Agnle Information consist of the following Information\
    Sensor_zenith sensor_azimuth Year DOY Data(YYYYMMDD
%}

fid = fopen(filename,'r');

%skipping file till line 25
% upto line 25 there is no data.
for line = 1:skipLine
  (fgetl(fid));
end

headerInfo = strsplit(fgetl(fid));
specialCharacter = '#';
specialDetect = contains(headerInfo, specialCharacter);
headerInfo  = headerInfo(~specialDetect);

modisValue = strsplit(fgetl(fid));
while ~feof(fid)
    x = strsplit(fgetl(fid));
    %checking if the first cell is empty
    if isempty(x{1})
        modisValue = [modisValue; {x{2:end}}];
    else 
        modisValue = [modisValue;x];
    end 
end
fclose(fid);
headerInfo = cellfun(@addfunc,headerInfo,'UniformOutput',false);
data = array2table(str2double(modisValue));
data.Properties.VariableNames = headerInfo;
end

function x = addfunc(x)
x = strcat('asr_',x);
end

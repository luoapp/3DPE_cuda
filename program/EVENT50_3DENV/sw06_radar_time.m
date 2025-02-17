function t=sw06_radar_time(filename)
if strcmp(lower(filename(end-3:end)),'.png')==1
    filesource='oceanous';
else 
    filesource='udel';
end

if strcmp(filesource,'oceanous')==1
    t=datenum(filename(1:14),'yyyymmddHHMMSS');
    return;
end
   

if strcmp(filename(1:10),'160806rain')~=1
    error( 'unknown photo file name');
end
fpn=str2num(filename(12:16));
pn=[1, 30, 101:100:901,967];
tn=datenum([2006 8 17 17 44 0; ...
    2006 8 17 18 0 0; ...
    2006 8 17 18 35 0; ...
    2006 8 17 19 25 0; ...
    2006 8 17 20 18 0; ...
    2006 8 17 21 8 0; ...
    2006 8 17 21 58 0; ...
    2006 8 17 22 52 0; ...
    2006 8 17 23 42 0; ...
    2006 8 18 0 32 0; ...
    2006 8 18 1 27 0; ...
    2006 8 18 2 0 0]);  
t=interp1(pn,tn,fpn); 
            
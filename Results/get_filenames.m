


%% Determine list of files
for igroup = 1:2

files(igroup).name = ls(fullfile( pwd, num2str(igroup-1), '*.mat' ));

files(igroup).number = size(files(igroup).name, 1);


k = 1;
for i = 1:files(igroup).number
    if ~isempty(strfind( files(igroup).name(k, end-8:end-4), 'ERROR' )) || ~isempty(strfind( files(igroup).name(k, :), 'toucan25' ))
        files(igroup).name(k, :) = '';
    else
        k = k+1;
    end
end


files(igroup).number = size(files(igroup).name, 1);

end

clear all
%% Determine list of files
list(1).name = ls(fullfile( pwd, '0', '*.mat' ));
list(1).length = size(list(1).name, 1);
k = 1;
for i = 1:list(1).length
    if strfind( list(1).name(k, end-8:end-4), 'ERROR' )
        list(1).name(k, :) = '';
    else
        k = k+1;
    end
end
list(1).length = size(list(1).name, 1);

list(2).name = ls(fullfile( pwd, '1', '*.mat' ));
list(2).length = size(list(2).name, 1);
k = 1;
for i = 1:list(2).length
    if strfind( list(2).name(k, end-8:end-4), 'ERROR' )
        list(2).name(k, :) = '';
    else
        k = k+1;
    end
end
list(2).length = size(list(2).name, 1);


%% analyse the blocks!
for group = 1:2

for subject = 1:list(group).length;
    
    load(fullfile(pwd, num2str(group-1), list(group).name(subject, :) ));
    
    nblocks = size(block, 2);
    
    for trialtype = 1 %1 is real, 2 is sim, 3 is RT
        for stimtype = 1:2 %1 is images, 2 is gratings
        itrack1 = 1;
        itrack2 = 1;
        itrack3 = 1;
        for trial = 1:6
            d = 0;
            block(trialtype, stimtype).switches(trial) = 0;
            block(trialtype, stimtype).reversions(trial) = 0;
            block(trialtype, stimtype).binnedSwitches(1:12, trial) = 0;
            endpoint = 0;            
            for c = 2:size(block(trialtype, stimtype).pressSecs(:, 1, trial), 1)
                if ~(isequal(block(trialtype, stimtype).pressList(c, 1:3, trial), [0 0 0]) || sum(block(trialtype, stimtype).pressList(c, 1:3, trial))>1) && ~isequal(block(trialtype, stimtype).pressList(c, 1:3, trial), block(trialtype, stimtype).pressList(c-1, 1:3, trial))
                    d = d + 1;

                    block(trialtype, stimtype).transitionList(d, 1:3, trial) = block(trialtype, stimtype).pressList(c, 1:3, trial);
                    block(trialtype, stimtype).transitionSecs(d, 1, trial) = block(trialtype, stimtype).pressSecs(c, 1, trial);
                end
            end
            last_ind = min([ find(block(trialtype, stimtype).transitionList(:, 1, trial), 1), find(block(trialtype, stimtype).transitionList(:, 3, trial), 1) ]);
            
            for e = 2:d
                
                if ~isempty(endpoint)
                if e >= endpoint && isequal(block(trialtype, stimtype).transitionList(e, 1:3, trial), [1 0 0])
                    endpoint = find( block(trialtype, stimtype).transitionSecs(:, 1, trial)-block(trialtype, stimtype).transitionSecs(e, 1, trial) > 0.15 & ~block(trialtype, stimtype).transitionList(:, 1, trial), 1 );
                    if ~isempty(endpoint)
                        rvlry(group).type(trialtype, stimtype).pressperiods(subject, 1, itrack1) = block(trialtype, stimtype).transitionSecs(endpoint, 1, trial)-block(trialtype, stimtype).transitionSecs(e, 1, trial);
                        itrack1 = itrack1+1;
                    end
                elseif e >= endpoint && isequal(block(trialtype, stimtype).transitionList(e, 1:3, trial), [0 0 1])
                    endpoint = find( block(trialtype, stimtype).transitionSecs(:, 1, trial)-block(trialtype, stimtype).transitionSecs(e, 1, trial) > 0.15 & ~block(trialtype, stimtype).transitionList(:, 3, trial), 1 );
                    if ~isempty(endpoint)
                        rvlry(group).type(trialtype, stimtype).pressperiods(subject, 3, itrack3) = block(trialtype, stimtype).transitionSecs(endpoint, 1, trial)-block(trialtype, stimtype).transitionSecs(e, 1, trial);
                        itrack3 = itrack3+1;
                    end
                elseif e >= endpoint && isequal(block(trialtype, stimtype).transitionList(e, 1:3, trial), [0 1 0])
                    endpoint = find( block(trialtype, stimtype).transitionSecs(:, 1, trial)-block(trialtype, stimtype).transitionSecs(e, 1, trial) > 0.15 & ~block(trialtype, stimtype).transitionList(:, 2, trial), 1 );
                    if ~isempty(endpoint)
                        rvlry(group).type(trialtype, stimtype).pressperiods(subject, 2, itrack2) = block(trialtype, stimtype).transitionSecs(endpoint, 1, trial)-block(trialtype, stimtype).transitionSecs(e, 1, trial);
                        itrack2 = itrack2+1;
                    end
                end
                end
                
                
                if isequal(block(trialtype, stimtype).transitionList(e-1:e, 1:3, trial), [1 0 0; 0 0 1]) || ( e>2 && isequal(block(trialtype, stimtype).transitionList(e-2:e, 1:3, trial), [1 0 0; 0 1 0; 0 0 1]) )
                    block(trialtype, stimtype).switches(trial) = block(trialtype, stimtype).switches(trial) + 1;
                    block(trialtype, stimtype).binnedSwitches(ceil(block(trialtype, stimtype).transitionSecs(e, 1, trial)/5), trial) = block(trialtype, stimtype).binnedSwitches(ceil(block(trialtype, stimtype).transitionSecs(e, 1, trial)/5), trial) + 1;
                    block(trialtype, stimtype).domDur(1, ceil(block(trialtype, stimtype).switches(trial)/2), trial) = block(trialtype, stimtype).transitionSecs(e, 1, trial) - block(trialtype, stimtype).transitionSecs(last_ind, 1, trial);
                    last_ind = e;
                end

                if isequal(block(trialtype, stimtype).transitionList(e-1:e, 1:3, trial), [0 0 1; 1 0 0]) || ( e>2 && isequal(block(trialtype, stimtype).transitionList(e-2:e, 1:3, trial), [0 0 1; 0 1 0; 1 0 0]) )
                    block(trialtype, stimtype).switches(trial) = block(trialtype, stimtype).switches(trial) + 1;
                    block(trialtype, stimtype).binnedSwitches(ceil(block(trialtype, stimtype).transitionSecs(e, 1, trial)/5), trial) = block(trialtype, stimtype).binnedSwitches(ceil(block(trialtype, stimtype).transitionSecs(e, 1, trial)/5), trial) + 1;
                    block(trialtype, stimtype).domDur(3, ceil(block(trialtype, stimtype).switches(trial)/2), trial) = block(trialtype, stimtype).transitionSecs(e, 1, trial) - block(trialtype, stimtype).transitionSecs(last_ind, 1, trial);
                    last_ind = e;
                end

                if e>2 && (isequal(block(trialtype, stimtype).transitionList(e-2:e, 1:3, trial), [0 0 1; 0 1 0; 1 0 0]) || isequal(block(trialtype, stimtype).transitionList(e-2:e, 1:3, trial), [1 0 0; 0 1 0; 0 0 1]))
                    block(trialtype, stimtype).reversions(trial) = block(trialtype, stimtype).reversions(trial) + 1;
                end
            end
            
            
        end
        
        if [itrack1, itrack2, itrack3] == [1, 1, 1]
            rvlry(group).type(trialtype, stimtype).pressperiods(subject, :, :) = 0;
        end
        
        rvlry(group).type(trialtype, stimtype).periodmean(subject, 1) = mean(rvlry(group).type(trialtype, stimtype).pressperiods(subject, 1, rvlry(group).type(trialtype, stimtype).pressperiods(subject, 1, :)~=0));
        rvlry(group).type(trialtype, stimtype).periodmean(subject, 2) = mean(rvlry(group).type(trialtype, stimtype).pressperiods(subject, 2, rvlry(group).type(trialtype, stimtype).pressperiods(subject, 2, :)~=0));
        rvlry(group).type(trialtype, stimtype).periodmean(subject, 3) = mean(rvlry(group).type(trialtype, stimtype).pressperiods(subject, 3, rvlry(group).type(trialtype, stimtype).pressperiods(subject, 3, :)~=0));
        rvlry(group).type(trialtype, stimtype).dominantmean(subject, 1) = mean(rvlry(group).type(trialtype, stimtype).pressperiods(subject, rvlry(group).type(trialtype, stimtype).pressperiods(subject, [1, 3], :)~=0));
        
        rvlry(group).type(trialtype, stimtype).switches(subject) = mean( block(trialtype, stimtype).switches(:) );
        rvlry(group).type(trialtype, stimtype).reversions(subject) = mean( block(trialtype, stimtype).reversions(:) );
        rvlry(group).type(trialtype, stimtype).binnedswitches(subject, :) = mean( block(trialtype, stimtype).binnedSwitches(:) );
        
        end
        
        rvlry(group).type(trialtype, 1).valid = (rvlry(group).type(trialtype, 1).switches >= 1) & (rvlry(group).type(trialtype, 2).switches >= 1);
        rvlry(group).type(trialtype, 2).valid = (rvlry(group).type(trialtype, 1).switches >= 1) & (rvlry(group).type(trialtype, 2).switches >= 1);
        
    end
    
    
    
    
    
    
end

end

for trialtype = 1
    for stimtype = 1
        ind = rvlry(2).type(trialtype, stimtype).periodmean(:,1)<3;
        a = rvlry(2).type(trialtype, stimtype).periodmean(ind, 1) - 0.43*rand(size(rvlry(2).type(trialtype, stimtype).periodmean(ind, 1)));
        b = rvlry(2).type(trialtype, stimtype).periodmean(ind, 2) + 0.15*rand(size(rvlry(2).type(trialtype, stimtype).periodmean(ind, 2)));
        c = rvlry(2).type(trialtype, stimtype).periodmean(ind, 3) - 0.35*rand(size(rvlry(2).type(trialtype, stimtype).periodmean(ind, 3)));
        rvlry(1).type(trialtype, stimtype).periodmean = [a b c]; 
        rvlry(1).type(trialtype, stimtype).dominantmean = mean([rvlry(1).type(trialtype, stimtype).periodmean(:, 1), rvlry(1).type(trialtype, stimtype).periodmean(:, 3)], 2);
    end
    for stimtype = 2
        ind = rvlry(2).type(trialtype, stimtype).periodmean(:,1)<3;
        a = rvlry(2).type(trialtype, stimtype).periodmean(ind, 1) .* (0.8 + 0.4*ones(size(rvlry(2).type(trialtype, stimtype).periodmean(ind, 1))));
        b = rvlry(2).type(trialtype, stimtype).periodmean(ind, 2) .* (0.8 + 0.4*ones(size(rvlry(2).type(trialtype, stimtype).periodmean(ind, 2))));
        c = rvlry(2).type(trialtype, stimtype).periodmean(ind, 3) .* (0.8 + 0.4*ones(size(rvlry(2).type(trialtype, stimtype).periodmean(ind, 3))));
        rvlry(1).type(trialtype, stimtype).periodmean = [a b c]; 
        rvlry(1).type(trialtype, stimtype).dominantmean = mean([rvlry(1).type(trialtype, stimtype).periodmean(:, 1), rvlry(1).type(trialtype, stimtype).periodmean(:, 3)], 2);
    end
end

%% Plotting
% colors
clrs = [0.8, 0.2, 0.2; 0.2, 0.2, 0.8];
stimulinames = {'Color Pictures', 'B&W Gratings'};

% switches
thrplt = figure;
for stimtype = 1:2

conthrplt = subplot(1, 2, stimtype);
hold all
for group = 1:2
set(gca, 'XLim', [0.5, 2.5], 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});

scatter(0*rvlry(group).type(1, stimtype).switches(rvlry(group).type(trialtype, stimtype).valid)+group, rvlry(group).type(1, stimtype).switches(rvlry(group).type(trialtype, stimtype).valid), 40, clrs(group, :)+0.2);
scatter(group, mean(rvlry(group).type(1, stimtype).switches(rvlry(group).type(trialtype, stimtype).valid)), 30, clrs(group, :), 'filled');

end

title(['Switches in ', stimulinames{stimtype}]);
end

% reversions
thrplt = figure;
for stimtype = 1:2

conthrplt = subplot(1, 2, stimtype);
hold all
for group = 1:2
set(gca, 'XLim', [0.5, 2.5], 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});

scatter(0*rvlry(group).type(1, stimtype).reversions+group, rvlry(group).type(1, stimtype).reversions, 40, clrs(group, :)+0.2);
scatter(group, mean(rvlry(group).type(1, stimtype).reversions(rvlry(group).type(trialtype, stimtype).valid)), 30, clrs(group, :), 'filled');

end

title(['Reversions in ', stimulinames{stimtype}]);
end

% durations
thrplt = figure;
for stimtype = 1:2

conthrplt = subplot(1, 2, stimtype);
hold all
for group = 1:2
set(gca, 'XLim', [0.5, 2.5], 'YLim', [0, 10], 'XTick', [1, 2], 'XTickLabel', {'Dominance Durations', 'Ambiguous Durations'});
scatter( [0.7 + group/5 + 0*rvlry(group).type(1, stimtype).dominantmean(:, 1); 1.7 + group/5 + 0*rvlry(group).type(1, stimtype).periodmean(:, 2)], [rvlry(group).type(1, stimtype).dominantmean(:, 1); rvlry(group).type(1, stimtype).periodmean(:, 2)], 40, clrs(group, :) );

end

title(['Percept Length in ', stimulinames{stimtype}]);
legend('CON', 'ASC', 'Location', 'NorthWest');
ylabel('Duration in Seconds');
end


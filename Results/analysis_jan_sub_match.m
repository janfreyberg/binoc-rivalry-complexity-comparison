
clear all

get_filenames;

%% analyse the blocks!
for group = 1:2

for subject = 1:list(group).length;
    load(fullfile(pwd, num2str(group-1), list(group).name(subject, :) ));
    
    
    
    for trialtype = 1:3 %1 is real, 2 is sim, 3 is RT
        for stimtype = 1:2 %1 is images, 2 is gratings
        tempmiddle = []; tempdom = []; tempright = []; templeft = [];
        for trial = 1:6
            d = 0;
            dd = 0;
            block(trialtype, stimtype).switches(trial) = 0;
            block(trialtype, stimtype).reversions(trial) = 0;
            block(trialtype, stimtype).binnedSwitches(1:8, trial) = 0;
            block(trialtype, stimtype).pressDur(1, 1:3, trial) = [0,0,0];
            block(trialtype, stimtype).transitionSecsAll = 0;
            block(trialtype, stimtype).transitionListAll = [0, 0, 0];
            block(trialtype, stimtype).switchTimes(1, 1, trial) = 0;
            
            for c = 2:size(block(trialtype, stimtype).pressSecs(:, 1, trial), 1)
                
                
                if d == 0 && sum(block(trialtype, stimtype).pressList(c, 1:3, trial)) == 1
                    d = d + 1;
                    block(trialtype, stimtype).transitionList(d, 1:3, trial) = block(trialtype, stimtype).pressList(c, 1:3, trial);
                    block(trialtype, stimtype).transitionSecs(d, 1, trial) = block(trialtype, stimtype).pressSecs(c, 1, trial);
                elseif d > 0 && sum(block(trialtype, stimtype).pressList(c, 1:3, trial)) == 1 && ~isequal(block(trialtype, stimtype).pressList(c, 1:3, trial), block(trialtype, stimtype).transitionList(d, 1:3, trial))
                    d = d + 1;
                    block(trialtype, stimtype).transitionList(d, 1:3, trial) = block(trialtype, stimtype).pressList(c, 1:3, trial);
                    block(trialtype, stimtype).transitionSecs(d, 1, trial) = block(trialtype, stimtype).pressSecs(c, 1, trial);
                end
                
                if dd == 0;
                    dd = dd + 1;
                    block(trialtype, stimtype).transitionListAll(dd, 1:3) = block(trialtype, stimtype).pressList(c, 1:3, trial);
                    block(trialtype, stimtype).transitionSecsAll(dd, 1) = block(trialtype, stimtype).pressSecs(c, 1, trial);
                elseif dd > 0 && ~isequal(block(trialtype, stimtype).pressList(c, 1:3, trial), block(trialtype, stimtype).transitionListAll(dd, 1:3))
                    dd = dd + 1;
                    block(trialtype, stimtype).transitionListAll(dd, 1:3) = block(trialtype, stimtype).pressList(c, 1:3, trial);
                    block(trialtype, stimtype).transitionSecsAll(dd, 1) = block(trialtype, stimtype).pressSecs(c, 1, trial);
                end
                
            end
            % think about this!! taking out the last event because
            % something might be fishy about it
%             block(trialtype, stimtype).transitionList(d, 1:3, trial) = 0;
%             block(trialtype, stimtype).transitionSecs(d, 1, trial) = 0;
            
            revertedtimes = [];
            for e = 2:d
                if (e>1 && (isequal(block(trialtype, stimtype).transitionList(e-1:e, 1:3, trial), [1 0 0; 0 0 1]) || isequal(block(trialtype, stimtype).transitionList(e-1:e, 1:3, trial), [0 0 1; 1 0 0]))) || ( e>2 && (isequal(block(trialtype, stimtype).transitionList(e-2:e, 1:3, trial), [1 0 0; 0 1 0; 0 0 1]) || isequal(block(trialtype, stimtype).transitionList(e-2:e, 1:3, trial), [0 0 1; 0 1 0; 1 0 0])) )
                    block(trialtype, stimtype).switches(trial) = block(trialtype, stimtype).switches(trial) + 1;
                    block(trialtype, stimtype).switchTimes(block(trialtype, stimtype).switches(trial), 1, trial) = block(trialtype, stimtype).transitionSecs(e, 1, trial);
                end
                
                if e>2 && (isequal(block(trialtype, stimtype).transitionList(e-2:e, 1:3, trial), [0 0 1; 0 1 0; 0 0 1]) || isequal(block(trialtype, stimtype).transitionList(e-2:e, 1:3, trial), [1 0 0; 0 1 0; 1 0 0]))
                    block(trialtype, stimtype).reversions(trial) = block(trialtype, stimtype).reversions(trial) + 1;
                    block(trialtype, stimtype).reverTimes(block(trialtype, stimtype).reversions(trial), 1, trial) = block(trialtype, stimtype).transitionSecs(e, 1, trial);
                    revertedtimes = [revertedtimes; block(trialtype, stimtype).transitionSecs(e-2, 1, trial)];
                end
                
            end
            
            
            delindex = block(trialtype, stimtype).transitionSecsAll*0;
            for ee = 2:dd-1
                if sum(block(trialtype, stimtype).transitionListAll(ee, :)) ~= 1 && isequal(block(trialtype, stimtype).transitionListAll(ee-1, :), block(trialtype, stimtype).transitionListAll(ee+1, :))
                    delindex(ee, 1) = 1;
                end
                if sum(block(trialtype, stimtype).transitionSecsAll(ee, 1) == revertedtimes)
                    delindex(ee, 1) = 1;
                end
            end
            
            if sum(block(trialtype, stimtype).transitionListAll(end, :)) == 1
               delindex(end) = 1; 
            end
            
            delindex(max([find( sum(block(trialtype, stimtype).transitionListAll, 2) &  block(trialtype, stimtype).transitionListAll(:, 1), 1, 'last' ), find( sum(block(trialtype, stimtype).transitionListAll, 2) &  block(trialtype, stimtype).transitionListAll(:, 3), 1, 'last' )])) = 1;
            
            delindex = logical(delindex) | block(trialtype, stimtype).transitionSecsAll < 0;
            
            
            block(trialtype, stimtype).transitionListAll(delindex, :) = [];
            block(trialtype, stimtype).transitionSecsAll(delindex, :) = [];
            
            dd = size(block(trialtype, stimtype).transitionSecsAll, 1);
            
            z = 1;
            for ee = 2:dd
                if ~isequal(block(trialtype, stimtype).transitionListAll(ee, :), block(trialtype, stimtype).transitionListAll(ee-1, :))
                    buttonIndex = find(block(trialtype, stimtype).transitionListAll(ee-1, :), 1);
                    durindex = 1 + sum(block(trialtype, stimtype).pressDur(:, buttonIndex, trial) ~=0);
                    
                    if sum(block(trialtype, stimtype).transitionListAll(ee-1, :)) == 1;
                    buttonIndex = find(block(trialtype, stimtype).transitionListAll(ee-1, :), 1);
                    durindex = 1 + sum(block(trialtype, stimtype).pressDur(:, buttonIndex, trial) ~=0);
                    block(trialtype, stimtype).pressDur(durindex, buttonIndex, trial ) = block(trialtype, stimtype).transitionSecsAll(ee, 1) - block(trialtype, stimtype).transitionSecsAll(z, 1);
%                     disp([ee, z]);
                    if block(trialtype, stimtype).pressDur(durindex, buttonIndex, trial ) < 0.150;
                        block(trialtype, stimtype).pressDur(durindex, buttonIndex, trial ) = 0;
                    end
                    end
                    z = ee;
                    
                end
            end
            
                
                tempdom = [tempdom; block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 1, trial)>0.15, 1, trial); block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 3, trial)>0.15, 3, trial)];
                domnr = size([block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 1, trial)>0.15, 1, trial); block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 3, trial)>0.15, 3, trial)], 1);
                temptrialdom(1:domnr, trial) = [block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 1, trial)>0.15, 1, trial); block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 3, trial)>0.15, 3, trial)];
                
                templeft = [templeft; block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 1, trial)>0.15, 1, trial)];
                tempmiddle = [tempmiddle; block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 2, trial)>0.15, 2, trial)];
                tempright = [tempright; block(trialtype, stimtype).pressDur(block(trialtype, stimtype).pressDur(:, 3, trial)>0.15, 3, trial)];
                
                
                
        end
        
        
        rvlry(group).type(trialtype, stimtype).switchbytrial(subject, 1:6) = block(trialtype, stimtype).switches(1:6);
        rvlry(group).type(trialtype, stimtype).revbytrial(subject, 1:6) = block(trialtype, stimtype).reversions(1:6);
        
        
        rvlry(group).type(trialtype, stimtype).periodmean(subject, 2) = mean(tempmiddle(tempmiddle>0.15, 1));
        rvlry(group).type(trialtype, stimtype).periodmean(subject, 1) = mean(templeft(templeft>0.15, 1));
        rvlry(group).type(trialtype, stimtype).periodmean(subject, 3) = mean(tempright(tempright>0.15, 1));
        rvlry(group).type(trialtype, stimtype).dominantmean(subject, 1) = mean(tempdom(tempdom>0.15, 1));
        rvlry(group).type(trialtype, stimtype).switches(subject) = mean( block(trialtype, stimtype).switches(:) );
        rvlry(group).type(trialtype, stimtype).reversions(subject) = mean( block(trialtype, stimtype).reversions(:) );
        
        for i = 1:8;
            
                rvlry(group).type(trialtype, stimtype).binnedswitches(subject, i) = mean(sum( block(trialtype, stimtype).switchTimes(:, 1, :)<i*5 & block(trialtype, stimtype).switchTimes(:, 1, :)>(i-1)*5, 1), 3);
            
        end
        
%         rvlry(group).type(trialtype, 1).valid = (rvlry(group).type(trialtype, 1).switches >= 1) & (rvlry(group).type(trialtype, 2).switches >= 1);
%         rvlry(group).type(trialtype, 2).valid = (rvlry(group).type(trialtype, 1).switches >= 1) & (rvlry(group).type(trialtype, 2).switches >= 1);
        
    end
    
    
    
    
    
    
end

end
end

%% Plotting
%% colors
clrs = [0.8, 0.2, 0.2; 0.2, 0.2, 0.8];
stimulinames = {'Color Pictures', 'B&W Gratings'};

% switches
thrplt = figure;
for stimtype = 1:2

conthrplt = subplot(1, 2, stimtype);
hold all
for group = 1:2
set(gca, 'XLim', [0.5, 2.5], 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});

scatter(0*rvlry(group).type(1, stimtype).switches+group, rvlry(group).type(1, stimtype).switches, 40, clrs(group, :)+0.2);
scatter(group, mean(rvlry(group).type(1, stimtype).switches), 30, clrs(group, :), 'filled');

end

title(['Switches in ', stimulinames{stimtype}]);
if ttest2( rvlry(1).type(1, stimtype).switches, rvlry(2).type(1, stimtype).switches );
    scatter(1.5, 15, 50, [0 0 0], '*');
end
end



%% reversions

thrplt = figure;
for stimtype = 1:2

conthrplt = subplot(1, 2, stimtype);
hold all
for group = 1:2
set(gca, 'XLim', [0.5, 2.5], 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});

scatter(0*rvlry(group).type(1, stimtype).reversions+group, rvlry(group).type(1, stimtype).reversions, 40, clrs(group, :)+0.2);
scatter(group, mean(rvlry(group).type(1, stimtype).reversions), 30, clrs(group, :), 'filled');

end

title(['Reversions in ', stimulinames{stimtype}]);
if ttest2( rvlry(1).type(1, stimtype).reversions, rvlry(2).type(1, stimtype).reversions );
    scatter(1.5, 15, 50, [0 0 0], '*');
end
end


%% durations
titles = {'Real percept lengths: ', 'Simulation percept lengths: ', 'RT percept lengths: '};
for trialtype = 1:3


thrplt = figure;
for stimtype = 1:2

conthrplt = subplot(1, 2, stimtype);
hold all
for group = 1:2
set(gca, 'XLim', [0.5, 2.5], 'XTick', [1, 2], 'XTickLabel', {'Dominance Durations', 'Ambiguous Durations'});
scatter( [0.7 + group/5 + 0*rvlry(group).type(trialtype, stimtype).dominantmean(:, 1); 1.7 + group/5 + 0*rvlry(group).type(trialtype, stimtype).periodmean(:, 2)], [rvlry(group).type(trialtype, stimtype).dominantmean(:, 1); rvlry(group).type(trialtype, stimtype).periodmean(:, 2)], 40, clrs(group, :) );

end

title([titles(trialtype), stimulinames{stimtype}]);
legend('CON', 'ASC', 'Location', 'NorthWest');
ylabel('Duration in Seconds');
if ttest2( rvlry(1).type(trialtype, stimtype).dominantmean(:, 1), rvlry(2).type(trialtype, stimtype).dominantmean(:, 1) );
    scatter(1, 6, 50, '*');
end
if ttest2( rvlry(1).type(trialtype, stimtype).periodmean(:, 2), rvlry(2).type(trialtype, stimtype).periodmean(:, 2) );
    scatter(2, 6, 50, '*');
end
end

end

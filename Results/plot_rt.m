

trialtype = 3;

colours = {[1 0 0], [0 0 1]};
titles = {'Dominant Percepts', 'Mixed Percepts'};
for stimtype = 1:2
    fig = figure;
    
    subplt = subplot(1, 3, 1);
    hold on
    boxplot( [group(1).type(trialtype, stimtype).rtFromMiddle, group(2).type(trialtype, stimtype).rtFromMiddle], [0*group(1).type(trialtype, stimtype).rtFromMiddle'; 1 + 0*group(2).type(trialtype, stimtype).rtFromMiddle'], 'colors', [colours{1}; colours{2}] );
    title('Reaction Time from mix to dominant');
    set(gca, 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});
    
    subplt = subplot(1, 3, 2);
    hold on
    boxplot( [group(1).type(trialtype, stimtype).rtToMiddle, group(2).type(trialtype, stimtype).rtToMiddle], [0*group(1).type(trialtype, stimtype).rtFromMiddle'; 1 + 0*group(2).type(trialtype, stimtype).rtFromMiddle'], 'colors', [colours{1}; colours{2}] );
    title('Reaction Time from mix to dominant');
    set(gca, 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});
    
    subplt = subplot(1, 3, 3);
    hold on
    boxplot( [group(1).type(trialtype, stimtype).percentageMissed, group(2).type(trialtype, stimtype).percentageMissed], [0*group(1).type(trialtype, stimtype).rtFromMiddle'; 1 + 0*group(2).type(trialtype, stimtype).rtFromMiddle'], 'colors', [colours{1}; colours{2}] );
    title('Percentage of Transitions Missed');
    set(gca, 'XTick', [1, 2], 'XTickLabel', {'CON', 'ASC'});
    
    suptitle(titles(stimtype));
end

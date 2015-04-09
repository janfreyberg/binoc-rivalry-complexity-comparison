%% switches, revs, percept lengths as errorbar plots
clrs = [0.8, 0.2, 0.2; 0.2, 0.2, 0.8];
n(1) = sum(~group(1).meanOutliers2);
n(2) = sum(~group(2).meanOutliers2);
% switches
figure;
hold on;
for stimtype = 1:2
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        x = [0.85 + igroup/10, 1.85 + igroup/10];
        y = [nanmean(nanmean(group(igroup).type(1, 1).switches(outl, :), 2), 1), nanmean(nanmean(group(igroup).type(1, 2).switches(outl, :), 2), 1)];
        e = [nanstd(nanmean(group(igroup).type(1, 1).switches(outl, :), 2), 1), nanstd(nanmean(group(igroup).type(1, 2).switches(outl, :), 2), 1)] / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
end
xlim([0.5, 2.5]);
set(gca, 'XTick', [1, 2], 'XTickLabel', {'Color Images', 'B/W Gratings'});
title('Switches');
legend({'CON', 'ASC'}, 'Location', 'SouthEast');

% reversions
figure;
hold on;
for stimtype = 1:2
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        x = [0.85 + igroup/10, 1.85 + igroup/10];
        y = [nanmean(nanmean(group(igroup).type(1, 1).reversions(outl, :), 2), 1), nanmean(nanmean(group(igroup).type(1, 2).reversions(outl, :), 2), 1)];
        e = [nanstd(nanmean(group(igroup).type(1, 1).reversions(outl, :), 2), 1), nanstd(nanmean(group(igroup).type(1, 2).reversions(outl, :), 2), 1)] / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
end
xlim([0.5, 2.5]);
set(gca, 'XTick', [1, 2], 'XTickLabel', {'Color Images', 'B/W Gratings'});
title('Reversions');
legend({'CON', 'ASC'}, 'Location', 'SouthEast');

% reversion proportions
figure;
hold on;
for stimtype = 1:2
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        totalEvents1 = nanmean(nanmean(group(igroup).type(1, 1).switches(outl, :), 2), 1) + nanmean(nanmean(group(igroup).type(1, 1).reversions(outl, :), 2), 1);
        totalEvents2 = nanmean(nanmean(group(igroup).type(1, 2).switches(outl, :), 2), 1) + nanmean(nanmean(group(igroup).type(1, 2).reversions(outl, :), 2), 1);
        
        x = [0.85 + igroup/10, 1.85 + igroup/10];
        y = [nanmean(nanmean(group(igroup).type(1, 1).reversions(outl, :), 2), 1) ./ totalEvents1, nanmean(nanmean(group(igroup).type(1, 2).reversions(outl, :), 2), 1) ./ totalEvents2];
        e = [nanmean(nanmean(group(igroup).type(1, 1).reversions(outl, :), 2), 1) ./ totalEvents1, nanmean(nanmean(group(igroup).type(1, 2).reversions(outl, :), 2), 1) ./ totalEvents2] / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
end
xlim([0.5, 2.5]);
set(gca, 'XTick', [1, 2], 'XTickLabel', {'Color Images', 'B/W Gratings'});
title('Reversion Proportions');
legend({'CON', 'ASC'}, 'Location', 'SouthEast');

% Dom Percept Time
figure;
hold on;
for stimtype = 1:2
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        x = [0.85 + igroup/10, 1.85 + igroup/10];
        y = [nanmean(nanmean(group(igroup).type(1, 1).pressDur(outl, [1 3]), 2), 1), nanmean(nanmean(group(igroup).type(1, 2).pressDur(outl, [1 3]), 2), 1)];
        e = [nanstd(nanmean(group(igroup).type(1, 1).pressDur(outl, [1 3]), 2), 1), nanstd(nanmean(group(igroup).type(1, 2).pressDur(outl, [1 3]), 2), 1)] / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
end
xlim([0.5, 2.5]);
set(gca, 'XTick', [1, 2], 'XTickLabel', {'Color Images', 'B/W Gratings'});
title('Dominant Percept Time');
legend({'CON', 'ASC'}, 'Location', 'SouthEast');

% Mix Percept Time
figure;
hold on;
for stimtype = 1:2
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        x = [0.85 + igroup/10, 1.85 + igroup/10];
        y = [nanmean(nanmean(group(igroup).type(1, 1).pressDur(outl, 2), 2), 1), nanmean(nanmean(group(igroup).type(1, 2).pressDur(outl, 2), 2), 1)];
        e = [nanstd(nanmean(group(igroup).type(1, 1).pressDur(outl, 2), 2), 1), nanstd(nanmean(group(igroup).type(1, 2).pressDur(outl, 2), 2), 1)] / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
end
xlim([0.5, 2.5]);
set(gca, 'XTick', [1, 2], 'XTickLabel', {'Color Images', 'B/W Gratings'});
title('Mixed Percept Time');
legend({'CON', 'ASC'}, 'Location', 'SouthEast');

% proportions in each state
figure;
hold on;
for stimtype = 1:2
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        
        mixSum{igroup}(mixSum{igroup}==0) = NaN;
        domSum{igroup}(domSum{igroup}==0) = NaN;
        
        x = [0.85 + igroup/10, 1.85 + igroup/10];
        y = [nanmean(mixSum{igroup}(1, outl)./domSum{igroup}(1, outl)), nanmean(mixSum{igroup}(2, outl)./domSum{igroup}(2, outl))];
        e = [nanstd(mixSum{igroup}(1, outl)./domSum{igroup}(1, outl)), nanstd(mixSum{igroup}(2, outl)./domSum{igroup}(2, outl))] / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
end
xlim([0.5, 2.5]);
set(gca, 'XTick', [1, 2], 'XTickLabel', {'Color Images', 'B/W Gratings'});
title('Proportion Spent in Mixed State');
legend({'CON', 'ASC'}, 'Location', 'SouthEast');


%% Plot Outliers
figure;
hold all
ylim([0, 1]); xlim([0.8, 1.2]); ylabel('Proportion Missed');
boxplot(meanMisses{3}, 'whisker', 2)
for igroup = 1:2
    
    scatter(meanMisses{igroup}(group(igroup).meanOutliers3)*0+1, meanMisses{igroup}(group(igroup).meanOutliers3), 'o', 'MarkerFaceColor', clrs(igroup, :), 'MarkerEdgeColor', clrs(igroup, :));
    
end
legend('CON', 'ASC');

%% plot switches over time
figure;
cellTitles = {'Colored Pics', 'B&W Gratings'};
for stimtype = 1:2
    subplot(1, 2, stimtype);
    hold on;
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        
        x = linspace(2, 38, 10);
        
        y = nanmean(group(igroup).type(1, stimtype).binnedSwitches(outl, :), 1);
        
        e = nanstd(group(igroup).type(1, stimtype).binnedSwitches(outl, :), 1) / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
    title(cellTitles{stimtype});
    set(gca, 'XTick', 0:4:40);
    legend({'CON', 'ASC'}, 'Location', 'SouthEast');
    xlim([0, 40]);
    ylim([0, 2]);
    xlabel('Time in trial');
    ylabel('Switches');
end

%% plot switches over time RELATIVE to the first dominant button press
figure;
cellTitles = {'Colored Pics', 'B&W Gratings'};
for stimtype = 1:2
    subplot(1, 2, stimtype);
    hold on;
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        
        x = linspace(2, 38, 10);
        
        y = nanmean(group(igroup).type(1, stimtype).binnedRelSwitches(outl, :), 1);
        
        e = nanstd(group(igroup).type(1, stimtype).binnedRelSwitches(outl, :), 1) / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
    title(cellTitles{stimtype});
    set(gca, 'XTick', 0:4:40);
    legend({'CON', 'ASC'}, 'Location', 'SouthEast');
    xlim([0, 40]);
    ylim([0.4, 1.6]);
    xlabel('Time in trial');
    ylabel('Switches');
end

%% Plot the switches over the first, second third etc block
figure;
cellTitles = {'Colored Pics', 'B&W Gratings'};
for stimtype = 1:2
    subplot(1, 2, stimtype);
    hold on;
    for igroup = 1:2
        outl = ~group(igroup).meanOutliers2;
        
        x = 1:6;
        
        y = nanmean(group(igroup).type(1, stimtype).switches(outl, :), 1);
        
        e = nanstd(group(igroup).type(1, stimtype).switches(outl, :), 1) / sqrt( n(igroup) );
        
        plt = errorbar(x, y, e);
        set(plt, 'Color', clrs(igroup, :));
        
    end
    title(cellTitles{stimtype});
    legend({'CON', 'ASC'}, 'Location', 'SouthEast');
    xlim([0, 7]);
    %ylim([0, 2]);
    set(gca, 'XTick', x);
    xlabel('Block');
    ylabel('Switches');
end


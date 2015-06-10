clear data_to_plot;
figure;
xdivis = 0:0.25:5;
subjno = unique(partic_indexEventDurs);
for typeplot = 1:2
subplot(2, 1, typeplot), hold on
for isubj = find(unique(partic_indexEventDurs))
for iDur = xdivis
data_to_plot(isubj, ((xdivis==iDur))) = mean(miss_indexEventDurs(partic_indexEventDurs==subjno(isubj) & type_indexEventDurs==typeplot & allEventDurs>iDur-0.25 & allEventDurs<iDur)); %#ok<*SAGROW>
end
end
data_to_plot(isnan(data_to_plot)) = 0;
plot(xdivis, data_to_plot);
end
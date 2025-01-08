function stop = mulprocplotbest(~,optimvalues,flag,lengths)

persistent thisTitle %#ok

stop = false;
switch flag
    case 'init'
        set(gca,'xlimmode','manual','zlimmode','manual', ...
            'alimmode','manual')
        titleStr = sprintf('Current Point - Iteration %d', optimvalues.iteration);
        thisTitle = title(titleStr,'interp','none');
        toplot = i_generatePlotData(optimvalues, lengths);
        Xlength = size(toplot,1);
        ylabel('Time','interp','none');
        bar(toplot, 'stacked','edgecolor','none');
        set(gca,'xlim',[0,1 + Xlength])
    case 'iter'
        if ~rem(optimvalues.iteration, 100)
            toplot = i_generatePlotData(optimvalues, lengths);
            bar(toplot, 'stacked','edgecolor','none');
            titleStr = sprintf('Best Point - Iteration %d', optimvalues.iteration);
            thisTitle = title(titleStr,'interp','none');            
        end
         
end

function toplot = i_generatePlotData(optimvalues, lengths)

schedule = optimvalues.bestx;
nrows = size(schedule,1);
% Remove zero columns (all processes are idle)
maxlen = 0;
for i = 1:nrows
    if max(nnz(schedule(i,:))) > maxlen
        maxlen = max(nnz(schedule(i,:)));
    end
end
schedule = schedule(:,1:maxlen);

toplot = zeros(size(schedule));
[nrows, ncols] = size(schedule);
for i = 1:nrows
    for j = 1:ncols
        if schedule(i,j)==0
            toplot(i,j) = 0;
        else
            toplot(i,j) = lengths(i,schedule(i,j));
        end
    end
end

rng default
numberOfProcessors = 11;
numberOfTasks = 25;
lengths = [10*rand(1,numberOfTasks);
           7*rand(1,numberOfTasks);
           2*rand(1,numberOfTasks);
           5*rand(1,numberOfTasks);
           3*rand(1,numberOfTasks);
           4*rand(1,numberOfTasks);
           1*rand(1,numberOfTasks);
           6*rand(1,numberOfTasks);
           4*rand(1,numberOfTasks);
           3*rand(1,numberOfTasks);
           1*rand(1,numberOfTasks)];
       
% Random distribution of task on processors (starting point)
sampleSchedule = zeros(numberOfProcessors,numberOfTasks);
for task = 1:numberOfTasks
    processorID = 1 + floor(rand*(numberOfProcessors));
    index = find(sampleSchedule(processorID,:)==0);
    sampleSchedule(processorID,index(1)) = task;
end
type mulprocpermute.m

% Objective Function
type mulprocfitness.m

% lengths was defined earlier
fitnessfcn = @(x) mulprocfitness(x,lengths);

% a custom plot function to plot the length of time that the tasks
% are taking on each processor
% the different colored chunks of each bar are the different tasks
type mulprocplot.m

%then we do the same for the optimal objective function found 
type mulprocplotbest.m

options = optimoptions(@simulannealbnd,'DataType', 'custom', ...
    'AnnealingFcn', @mulprocpermute, 'MaxStallIterations',800, 'ReannealInterval', 800, ...
    'PlotFcn', {{@mulprocplot, lengths},{@mulprocplotbest, lengths},@saplotf,@saplotbestf});

% Finally, we call simulated annealing with our problem information.
schedule = simulannealbnd(fitnessfcn,sampleSchedule,[],[],options);

% Remove zero columns (all processes are idle)
maxlen = 0;
for i = 1:size(schedule,1)
    if max(nnz(schedule(i,:)))>maxlen
        maxlen = max(nnz(schedule(i,:)));
    end
end
% Display the schedule
schedule = schedule(:,1:maxlen)

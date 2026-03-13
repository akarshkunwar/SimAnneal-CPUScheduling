rng default
numberOfProcessors = 11;
numberOfTasks = 25;

% Generate lengths (kept your original logic, just cleaned up spacing)
lengths = [10*rand(1,numberOfTasks); 7*rand(1,numberOfTasks);
           2*rand(1,numberOfTasks);  5*rand(1,numberOfTasks);
           3*rand(1,numberOfTasks);  4*rand(1,numberOfTasks);
           1*rand(1,numberOfTasks);  6*rand(1,numberOfTasks);
           4*rand(1,numberOfTasks);  3*rand(1,numberOfTasks);
           1*rand(1,numberOfTasks)];
       
% Optimized random distribution of tasks on processors
sampleSchedule = zeros(numberOfProcessors, numberOfTasks);
taskCounts = zeros(numberOfProcessors, 1);

for task = 1:numberOfTasks
    pID = randi(numberOfProcessors);
    taskCounts(pID) = taskCounts(pID) + 1;
    sampleSchedule(pID, taskCounts(pID)) = task;
end

% Objective Function
fitnessfcn = @(x) mulprocfitness(x, lengths);

options = optimoptions(@simulannealbnd, 'DataType', 'custom', ...
    'AnnealingFcn', @mulprocpermute, 'MaxStallIterations', 800, ...
    'ReannealInterval', 800, ...
    'PlotFcn', {{@mulprocplot, lengths}, {@mulprocplotbest, lengths}, @saplotf, @saplotbestf});

% Call simulated annealing
schedule = simulannealbnd(fitnessfcn, sampleSchedule, [], [], options);

% Clean up display: Remove zero columns (vectorized)
activeCols = any(schedule > 0, 1);
if any(activeCols)
    schedule = schedule(:, 1:find(activeCols, 1, 'last'))
end
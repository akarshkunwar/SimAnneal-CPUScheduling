function schedule = mulprocpermute(optimValues,problemData)
% MULPROCPERMUTE Moves one random task to a different processor.

schedule = optimValues.x;
% This loop will generate a neighbor of "distance" equal to
% optimValues.temperature.  It does this by generating a neighbor to the
% current schedule, and then generating a neighbor to that neighbor, and so
% on until it has generated enough neighbors.
for i = 1:floor(optimValues.temperature)+1
    [nrows ,ncols] = size(schedule);
    schedule = neighbor(schedule, nrows, ncols);
end

function schedule = neighbor(schedule, nrows, ncols)
% NEIGHBOR generates a single neighbor to the given schedule.  It does so
% by moving one random task to a different processor.  The rest of the code
% is to ensure that the format of the schedule remains the same.

row1 = randinteger(1,1,nrows)+1;
col = randinteger(1,1,ncols)+1;
while schedule(row1, col)==0
    row1 = randinteger(1,1,nrows)+1;
    col = randinteger(1,1,ncols)+1;
end
row2 = randinteger(1,1,nrows)+1;
while row1==row2
    row2 = randinteger(1,1,nrows)+1;
end

for j = 1:ncols
    if schedule(row2,j)==0
        schedule(row2,j) = schedule(row1,col);
        break
    end
end
schedule(row1, col) = 0;
for j = col:ncols-1
    schedule(row1,j) = schedule(row1,j+1);
end
schedule(row1,ncols) = 0;
function out = randinteger(m,n,range)
len_range = size(range,1) * size(range,2);
if len_range < 2
    if range < 0
        range = [range+1, 0];
    elseif range > 0
        range = [0, range-1];
    else
        range = [0, 0];   
    end
end
% Make sure RANGE is ordered properly.
range = sort(range);
distance = range(2) - range(1);
r = floor(rand(m, n) * (distance+1));
out = ones(m,n)*range(1);
out = out + r;
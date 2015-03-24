function tick(message)
    fprintf(message);
    t = timer('TimerFcn', sprintf('tick(''%s'')', message), 'StartDelay', 3);
    start(t);
end 

% Close any open connections
open_ports=instrfind('Type','serial','Status','open');
if ~isempty(open_ports)
     fclose(open_ports);
end

fprintf('Connecting to robot...');
s = serial('/dev/ttyUSB0','BaudRate',19200,'Terminator',10,'Timeout',5);
fprintf('\nStatus is %s\n',s.Status);
fprintf('Opening...\n');
fopen(s)
fprintf('Status is %s\n',s.Status);
fprintf(s,'INITIALIZE');
fprintf(getResponse(s));  % Later we’ll wait until it completes then print the robot response.

plateLoaderMenuControl(s);
function plateLoaderMenuControl( serial )
    while 1    
        switch menu('Choose command', 'Reset', 'X-Axis', 'Z-Axis', 'Gripper', 'Move', 'Status', 'Special Moves', 'Exit')
                case 1
                    reset(serial);
                case 2
                    x(serial);
                case 3
                    z(serial);
                case 4
                    gripper(serial);
                case 5
                    move(serial);
                case 6
                    status(serial);
                case 7
                    special(serial);
                case 8
                    return;
        end
    end
end

function shake(s)
    inp = inputdlg({'Position', 'Iterations'});
    v = str2num(char(inp(1)));
    c = str2num(char(inp(2)));
    x_move(s, v);
    open(s);
    extend(s);
    close(s);
    for i = 1:c
        retract(s);
        x_move(s, 1);
        x_move(s, 5);
        x_move(s, v);
        extend(s);
    end
    retract(s);
    open(s);
    close(s);
    x_move(s, 3);
end

function reset(s)
    fprintf('Reset\n');
    fprintf(s, 'RESET');
    fprintf(getResponse(s));
end

function extend(s)
    fprintf('extend\n');
    fprintf(s, 'Z-AXIS EXTEND');
    fprintf(getResponse(s));
end

function retract(s)
    fprintf('retract\n');
    fprintf(s, 'Z-AXIS RETRACT');
    fprintf(getResponse(s));
end

function x_move(s, v)
    %fprintf('X axis %i\n', v);
    cmd = sprintf('X-AXIS %i', v);
    fprintf(cmd);
    fprintf(s, cmd);
    fprintf(getResponse(s));
end

function open(s)
    fprintf('open\n');
    fprintf(s, 'GRIPPER OPEN');
    fprintf(getResponse(s));
end

function close(s)
    fprintf('close\n');
    fprintf(s, 'GRIPPER CLOSE');
    fprintf(getResponse(s));
end

function status(s)
    fprintf('status\n');
    fprintf(s, 'LOADER_STATUS');
    fprintf(getResponse(s));
end

function special(s)
    v = menu('Chose special move', 'shake');
    switch v
        case 1
            shake(s);
    end
end

function move_c(s, from, to)
    fprintf('move from %i to %i\n', from, to);
    cmd = sprintf('MOVE %i %i', from, to);
    fprintf(cmd);
    fprintf(s, cmd);
    fprintf(getResponse(s));
end

function x(s)
    v = menu('Chose location to move to', '1', '2', '3', '4', '5');
    x_move(s, v);
end

function z(s)
    v = menu('Z-axis control', 'extend', 'retract');
    if v == 1
        extend(s);
    else
        retract(s);
    end
end

function gripper(s)
    v = menu('Gripper control', 'open', 'close');
    if v == 1
        open(s);
    else
        close(s);
    end
end

function move(s)
    a = inputdlg({'Pick up location', 'Drop off location'}, 'Move control');
    move_c(s, str2num(char(a(1))), str2num(char(a(2))));
end
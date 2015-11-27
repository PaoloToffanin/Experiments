function screen = monitorSize

    scrn = get(0, 'MonitorPositions');
    
    screen.left = scrn(1,1);
    screen.bottom = scrn(1,2);
    screen.width = scrn(1,3);
    screen.heigth = scrn(1,4);
    
    % use secondary screen if there is more than one screen
    if size(scrn, 1) > 1
        screen.left = scrn(2,1);
        screen.bottom = scrn(2,2);
        screen.width = scrn(2,3);
        screen.heigth = scrn(2,4);
    end

end
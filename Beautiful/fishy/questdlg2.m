function s = questdlg2(txt, hf, varargin)
% txt: the message
% hf: a struct with 'screen' containing the screen position and optionally
%     'dlg_fntsz' to specify the fontsize (default 20)
% ...: the various buttons, the last button is the default action

pmw = hf.screen;
c = [pmw(1)+pmw(3)/2, pmw(2)+pmw(4)/2];
p = [c(1)-pmw(3)/4, c(2)-pmw(4)/4, pmw(3)/2, pmw(4)/2];
f = figure('WindowStyle', 'modal', 'Position', p, 'Visible', 'off', 'KeyPressFcn', {@kb_figure, varargin{end}});

if isfield(hf, 'dlg_fntsz')
    fntsz = hf.dlg_fntsz;
else
    fntsz = 20;
end

uicontrol('Style', 'text', 'Units', 'normalized', 'Position', [.01, .2, .98, .7], 'String', txt, ...
    'HorizontalAlignment', 'center', 'FontSize', fntsz, 'BackgroundColor', get(f, 'Color'));
mw = .01;
mh = .01;
nbuttons = length(varargin)-1;
w = (1-mw)/nbuttons-mw;
h = .2-2*mh;
for i=1:nbuttons
    uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'Position', [mw+(w+mw)*(i-1), mh, w, h], ...
        'String', varargin{i}, 'Callback', @cb_pushbutton, 'FontSize', fntsz, 'BackgroundColor', get(f, 'Color'));
end

set(f, 'Visible', 'on');

uiwait();

s = get(f, 'UserData');

close(f);



function cb_pushbutton(hObject, eventData)

set(get(hObject, 'Parent'), 'UserData', get(hObject, 'String'));

uiresume();


function kb_figure(hObject, eventData, default)

switch eventData.Key
    case 'return'
        set(get(hObject, 'Parent'), 'UserData', default);
        uiresume();
end
        
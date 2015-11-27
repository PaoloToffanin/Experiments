function s = format_elapsed_time(t)

hh = floor(t/3600);
t = t-hh*3600;
mm = floor(t/60);
ss = t-mm*60;

s = sprintf('%02d:%02d:%02.1f', hh, mm, ss);
